module Output (filename, printGnuplot, printCSV) where

import Text.Printf (printf)

filename a b = "fmin=" ++ a ++ "Hz_fmax=" ++ b ++ "Hz"

printGnuplot a b xs =
	unlines [
	"set terminal pngcairo size 1920,1080 enhanced font 'Verdana,12'" ,
	"set logscale x" ,
	"set logscale y" ,
	"set output '" ++ filename a b ++ ".png'",
	"set title \"Average Number of Peaks/Second for different Frequencies\"" ,
	"set xlabel 'Frequency in Hertz'" ,
	"set ylabel 'Average Numer of Peaks/Second'"] ++ "plot " ++ printPlot a b xs

printPlot a b xs
	| null xs	= "'" ++ filename a b ++ ".csv' using 1:" ++ show 2 ++ " title \"Average\" with lines lw 4 lt rgb \"red\"\n"
	| otherwise	= "'" ++ filename a b ++ ".csv' using 1:" ++ show (l+2) ++ " title \"Refactoring Period = " ++ printf "%.2E\" with lines,\\\n" x ++ printPlot a b t
	where l = length xs
	      x = head xs
	      t = tail xs

printCSV xs
	| null xs	= ""
	| otherwise	= show  (fst3 $ head xs) ++ "\t" ++ show (snd3 $ head xs) ++ "\t" ++ printResults (third3 $ head xs) ++ printCSV (tail xs)
	where
		fst3 (a,_,_)	= a
		snd3 (_,a,_)	= a
		third3 (_,_,a)	= a
		printResults xs
			| null xs	= "\n"
			| otherwise	= show (head xs) ++ "\t" ++ printResults (tail xs)
