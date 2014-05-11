Hier noch die notwendige (kurze) Erklärung zum Programm:

Das Programm habe ich umstrukturiert und kommentiert. Ich hoffe, dass die Funktionsweise jetzt leichter ersichtlich und verständlich ist. Dabei habe ich den Code der Übersichtlichkeit halber auf 3 Dateien aufgeteilt:
  Main.hs - enthält nur die main-Funktion
  Output.hs - enthält 3 einfache Funktionen, um die Ausgabe zu gewährleisten
  Neuron.hs - enthält die (mathematische) Beschreibung der Problemstellung in Haskell

Zum kompillieren des Programmes ist nur HaskellPlatform nötig - http://www.haskell.org/platform/
Der befehl zum kompillieren lautet:
  Windows: ghc -O2 -threaded --make Main.hs -o main.exe
  Linux: ghc -O2 -threaded --make Main.hs -o main.out

Das Programm nimmt in der Befehlszeile/Shell 6 Parameter entgegen.
Die ersten 3 Parameter beschreiben den zu beschreibenden Frequenzbereich
  fmin -> die Startfrequenz
  fmax -> die Endfrequenz
  fproz -> die nächste Frequenz ist "freq*(1+fproz/100)" wobei "freq" die aktuelle frequenz ist (0<fproz)
Die anderen 3 Parameter geben die Refraktärzeit(-en) an
  NrRefrZeit -> Anzahl der verschiedenen Refraktärzeiten, über welche gemittelt wird (>=1)
  RefRefrZeit -> gibt die Referenz-Refraktärzeit an
  DeltaRefrZeit -> gibt die maximale Ablenkung von "RefRefrZeit" in Prozent an (0<=x<100)

Aufgerufen wird das Programm also in der Form
  Windows: "main.exe fmin fmax fproz NrRefrZeit RefRefrZeit DeltaRefrZeit"
  Linux: "./main.out fmin fmax fproz NrRefrZeit RefRefrZeit DeltaRefrZeit"

z.B.: 20Hz bis 20kHz in 1% Schritten, 15 verschiedene Refraktärzeiten im Bereich von 0.001s (+-10%):
  Windows: main.exe 20 20000 1 15 0.001 10
  Linux: ./main.out 20 20000 1 15 0.001 10

das Ergebniss der Berechnung wird als csv-Datei gespeichert. Zusätzlich wird eine gp-Datei erzeugt, welche die gnuplot-anweisungen enthält, um eine einfache Visualisierung zu ermöglichen. Außerdem wird, falls gnuplot installiert ist, gleich eine png-Datei aus der csv-Datei erstellt.
