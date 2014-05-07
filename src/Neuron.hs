module Neuron (peakAvg) where

import Control.Parallel.Strategies (parMap,rpar)

-- Hilfsfuktionen
fullPeriod (freq,_)	= 1/freq				-- Frequenz		-> Dauer einer Periode
minTime (freq,thre)	= asin thre / (2*pi*freq)		-- Frequenz & Threshold	-> Zeitpunkt, ab dem sin(x) >= Threshold
maxTime wave		= fullPeriod wave /2 - minTime wave	-- Frequenz & Threshold	-> Zeitpunkt, ab dem sin(x) <= Threshold

-- Liste der Refraktärzeiten (Anzahl der Refraktärzeiten, Mittlere Refraktärzeit, maximale Abweichung von der Mittleren Refraktärzeit in Prozent der Mittleren Refraktärzeit)
refPList		= \(nrRefPs,refRefP,deltaRefP)	-> refPList' nrRefPs refRefP (refRefP*deltaRefP/100)
	where
	refPList' n r d
		| n <= 1	= [r]
		| n == 2	= [r-d,r+d]
		| otherwise	= [r-d,r-d+2*d/n..r+d]

-- Liste der Frequenzen (Minimale Frequenz, Maximale Frequenz, Schrittweite in Prozent der aktuellen Frequenz zur nächsten
freqList (lowF,highF,percentF) 
	| highF <= lowF	= [highF]
	| next >= highF	= [lowF,highF]
	| otherwise	= lowF : freqList (next,highF,percentF)
	where next	= lowF * (1.0+percentF/100)

-- Sucht den Zeitpunkt, zu dem das Neuron auslöst
peak :: Double -> (Double,Double) -> (Double,Double) -> Double
peak n wave neuron@(_,offS)
	| n*fpT+maxT < offS	= (n+1)*fpT+minT
	| n*fpT+minT > offS	= n*fpT+minT
	| otherwise		= offS
	where
		n	= fromIntegral $ floor $ offS/fpT
		fpT	= fullPeriod wave			-- Hilfsfunktionen anwenden
		minT	= minTime wave				-- Hilfsfunktionen anwenden
		maxT	= maxTime wave				-- Hilfsfunktionen anwenden

-- Sucht (rekursiv) die Anzahl der Peaks pro Sekunde
peaks count wave neuron@(refP,offS) repetitions
	| count >= repetitions	= count / (offS-refP)							-- Anzahl der Peaks/Sekunde, falls "count >= repetitions"
	| otherwise		= peaks (count+1) wave (refP,refP + peak 0 wave neuron) repetitions	-- nächsten Peak suchen und "count" vergrößern

-- Wrapper für "peaks", mit default Werten für Threshold (0.9) und Offset (0)
peaksPerSecond freq refP	= cT $ tmp 100
	where
	pPS	= peaks 0.0 (freq, 0.9) (refP, 0)	-- rufe Peaks mit Default Werten auf
	tmp rep	= pPS rep : tmp (rep*1.10)		-- mache eine Liste, mit immer größerer Zahl für repetitions
	cT (x:y:ss)					-- nimm das Element der vorher erstellten liste, das sich kaum mehr ändert (<=1Promille) bei 10% größerer "repetitions"
		| abs(1-x/y) < 0.001	= x		-- ab maximal 1 Promille Unteschied -> aus
		| otherwise		= cT (y:ss)	-- sonst vergleiche die nächsten 2 Elemente

-- Mittelt über alle Refraktärzeiten bei einer Frequenz - gibt dann eine Liste von Paaren aus in der Form (Frequenz, Mittlere Anzahl an Peaks/Sekunde)
peakAvg f@(fmin,fmax,fper) r@(refPs,refRefP,deltaRefP) =
	map (\freq -> (freq,peakAverage freq)) (freqList f)
	where
		avg xs			= sum xs / fromIntegral (length xs)
		pPS 			= peaksPerSecond
		list			= refPList r
		peakAverage freq	= avg $ parMap rpar (pPS freq) list
