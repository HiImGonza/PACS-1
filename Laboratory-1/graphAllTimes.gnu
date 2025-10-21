# Script de gnuplot para graficar resultados
set terminal pngcairo size 900,650 enhanced font 'Verdana,12'
set output 'resultsLab2/graphTimes_avg.png'

set title "Execution Time vs Matrices Sizes"
set xlabel "Matrix Size (N)"
set ylabel "Time (s)"
set grid
set key outside right top box

# Estilos para Normal (azules)
set style line 1 lc rgb '#1f77b4' lt 1 lw 2 pt 7 ps 1.2   # Real Normal
set style line 2 lc rgb '#d62728' lt 1 lw 2 pt 7 ps 1.2   # User Normal (verde azulado)
set style line 3 lc rgb '#9467bd' lt 1 lw 2 pt 7 ps 1.2   # Sys Normal (cyan azulado)

# Estilos para Eigen (rojos)
set style line 4 lc rgb '#1f77b4' lt 1 lw 2 pt 5 ps 1.2   # Real Eigen
set style line 5 lc rgb '#d62728' lt 1 lw 2 pt 5 ps 1.2   # User Eigen (naranja rojizo)
set style line 6 lc rgb '#9467bd' lt 1 lw 2 pt 5 ps 1.2   # Sys Eigen (morado rojizo)

# Graficar todas las curvas en una sola instrucción
plot "resultsLab2/metrics_time_avg.txt" using 1:2 with points ls 1 title "RealTimeNormal", \
     "resultsLab2/metrics_time_avg.txt" using 1:3 with points ls 2 title "UserTimeNormal", \
     "resultsLab2/metrics_time_avg.txt" using 1:4 with points ls 3 title "SysTimeNormal", \
     "resultsLab2/metrics_time_avg.txt" using 1:5 with points ls 4 title "RealTimeEigen", \
     "resultsLab2/metrics_time_avg.txt" using 1:6 with points ls 5 title "UserTimeEigen", \
     "resultsLab2/metrics_time_avg.txt" using 1:7 with points ls 6 title "SysTimeEigen"


