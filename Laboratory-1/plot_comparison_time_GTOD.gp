# Archivo: resultsLab2/plot_comparable.gp

set terminal pngcairo size 1000,600 enhanced font 'Arial,14'
set output 'resultsLab2/comparable_times_stressed.png'

set title "time vs gettimeofday()"
set xlabel "Matrix size (N)"
set ylabel "Time (s)"
set grid

set key outside
set style line 1 lc rgb '#FF0000' pt 7 ps 1.5   # Normal Time
set style line 2 lc rgb '#0000FF' pt 7 ps 1.5   # Eigen Time
set style line 3 lc rgb '#00AA00' pt 7 ps 1.5   # Normal GTOD
set style line 4 lc rgb '#FF00FF' pt 7 ps 1.5   # Eigen GTOD
set style line 5 lc rgb '#000000' lt 2 lw 2 dashtype 2 # O(n^3)

# Definimos la función O(n^3), ajustando el factor de escala 'k'
k = 1e-9
f(x) = k * x**3

plot \
'resultsLab2/metrics_comparable_stressed.txt' using 1:2 with points ls 1 title 'Normal Time', \
'resultsLab2/metrics_comparable_stressed.txt' using 1:3 with points ls 2 title 'Eigen Time', \
'resultsLab2/metrics_comparable_stressed.txt' using 1:4 with points ls 3 title 'Normal GTOD', \
'resultsLab2/metrics_comparable_stressed.txt' using 1:5 with points ls 4 title 'Eigen GTOD', \
f(x) with lines ls 5 title 'O(n^3)'

