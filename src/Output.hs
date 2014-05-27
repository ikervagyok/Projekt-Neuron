module Output (filename, printGnuplot, printCSV) where

filename a b = "fmin=" ++ a ++ "Hz_fmax=" ++ b ++ "Hz"

printGnuplot a b =
	unlines [
	"set terminal pngcairo size 1920,1080 enhanced font 'Verdana,12'" ,
	"set logscale x" ,
	"set logscale y" ,
	"set output '" ++ filename a b ++ ".png'",
	"set title \"Average Number of Peaks/Second for different Frequencies\"" ,
	"set xlabel 'Frequency in Hertz'" ,
	"set ylabel 'Average Numer of Peaks/Second'" ,
	"plot '" ++ filename a b ++ ".csv'" ]

printCSV xs
	| null xs	= ""
	| otherwise	= show  (fst $ head xs) ++ "\t" ++ show (snd $ head xs) ++ "\n" ++ printCSV (tail xs)
