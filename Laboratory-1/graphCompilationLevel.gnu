set terminal pngcairo size 1000,700 enhanced font 'Verdana,12'
set output './results/OptimizationComparison.png'

set title "Comparison of Execution Times with Different Optimization Levels"
set xlabel "Matrix Size (N)"
set ylabel "Time (s)"
set grid
set key outside right top box

# Definir estilos (Normal = azules, Eigen = rojos/naranjas)
set style line 1 lc rgb '#1f77b4' lt 1 lw 2 pt 7 ps 1.2   # Normal O1
set style line 2 lc rgb '#d62728' lt 1 lw 2 pt 7 ps 1.2   # Normal O2
set style line 3 lc rgb '#9467bd' lt 1 lw 2 pt 7 ps 1.2   # Normal O3

set style line 4 lc rgb '#1f77b4' lt 1 lw 2 pt 5 ps 1.2   # Eigen O1
set style line 5 lc rgb '#d62728' lt 1 lw 2 pt 5 ps 1.2   # Eigen O2
set style line 6 lc rgb '#9467bd' lt 1 lw 2 pt 5 ps 1.2   # Eigen O3

# Graficar todas las curvas en una sola instrucción
plot "./results/metrics_normal.txt" using 1:2 with points ls 1 title "Normal O1", \
     "./results/metrics_normal.txt" using 1:3 with points ls 2 title "Normal O2", \
     "./results/metrics_normal.txt" using 1:4 with points ls 3 title "Normal O3", \
     "./results/metrics_eigen.txt" using 1:2 with points ls 4 title "Eigen O1", \
     "./results/metrics_eigen.txt" using 1:3 with points ls 5 title "Eigen O2", \
     "./results/metrics_eigen.txt" using 1:4 with points ls 6 title "Eigen O3"

