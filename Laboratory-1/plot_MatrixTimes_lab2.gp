# Archivo: resultsLab2/graphTimes.gp
reset
set terminal pngcairo size 1200,800 enhanced font 'Verdana,12'
set output 'resultsLab2/graphTimes.png'

set title "Multiplication and Everything Else times"
set xlabel "Matrix Size (N)"
set ylabel "Time (s)"
set grid
set key outside

# Escala logarítmica si los tiempos varían mucho
set logscale y

# Archivo de datos
datafile = "resultsLab2/metrics_avg_std_GTOD.txt"

# Columnas según tu archivo:
# 1: Size
# 2: AVG_Mult_Normal
# 3: STD_Mult_Normal
# 4: AVG_Rest_Normal
# 5: STD_Rest_Normal
# 6: AVG_Mult_Eigen
# 7: STD_Mult_Eigen
# 8: AVG_Rest_Eigen
# 9: STD_Rest_Eigen

# Estilo de puntos y colores
set style line 1 lc rgb "#1f77b4" pt 7 ps 1.5 lw 1   # Normal Multiplicación
set style line 2 lc rgb "#ff7f0e" pt 5 ps 1.5 lw 1   # Normal EverythingElse
set style line 3 lc rgb "#2ca02c" pt 9 ps 1.5 lw 1   # Eigen Multiplicación
set style line 4 lc rgb "#d62728" pt 11 ps 1.5 lw 1  # Eigen EverythingElse
set style line 5 lc rgb '#000000' lt 2 lw 2 dashtype 2 # O(n^3)

# Definimos la función O(n^3), ajustando el factor de escala 'k'
k = 1e-9
f(x) = k * x**3

# Ploteo solo puntos con barras de error
plot \
    datafile using 1:2:3 with yerrorbars ls 1 title "Normal Multiplicación", \
    datafile using 1:4:5 with yerrorbars ls 2 title "Normal EverythingElse", \
    datafile using 1:6:7 with yerrorbars ls 3 title "Eigen Multiplicación", \
    datafile using 1:8:9 with yerrorbars ls 4 title "Eigen EverythingElse", \
    f(x) with lines ls 5 title 'O(n^3)'
