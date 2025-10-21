set terminal pngcairo size 1000,700 enhanced font 'Verdana,12'
set output './results/MeanStdComparisonNoStress.png'

set title "Executions Times Media and Standard Desviation"
set xlabel "Matrix Size (N)"
set ylabel "Time (s)"
set grid
set key outside right top box

# Estilos
set style line 1 lc rgb '#1f77b4' lw 2 pt 7 ps 1.5   # Normal
set style line 2 lc rgb '#d62728' lw 2 pt 5 ps 1.5   # Eigen

# Plot con barras de error (usamos columnas: x:media:desviación)
plot "./results/metrics_avg_std_noStress.txt" using 1:2:3 with yerrorbars ls 1 title "Normal (median ± σ)", \
     "" using 1:4:5 with yerrorbars ls 2 title "Eigen (median ± σ)"
