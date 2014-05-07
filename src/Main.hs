import System.Environment (getArgs)
import System.IO (hPutStr,hFlush,hClose,openFile,IOMode (WriteMode))
import System.Cmd (rawSystem)

import Neuron (peakAvg)
import Output (filename, printGnuplot, printCSV)

main =	getArgs >>= \[fmin,fmax,fper,refPs,refRefP,deltaRefP] ->

--	Öffne Dateien zum schreiben
	openFile (filename fmin fmax ++ ".csv") WriteMode >>= \csvFile ->
	openFile (filename fmin fmax ++ ".gp") WriteMode >>= \gnuplotFile ->

--	Schreibe inhalt in die Dateien
	hPutStr csvFile (printCSV (peakAvg (read fmin,read fmax,read fper) (read refPs,read refRefP,read deltaRefP))) >>
	hPutStr gnuplotFile (printGnuplot fmin fmax) >>

--	Schließe Dateien
	hFlush csvFile >> hClose csvFile >>
	hFlush gnuplotFile >> hClose gnuplotFile >>

--	führe "gnuplot" aus
	rawSystem "gnuplot" [filename fmin fmax ++ ".gp"]
