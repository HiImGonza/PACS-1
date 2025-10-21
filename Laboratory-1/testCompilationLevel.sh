#!/bin/bash

echo "Compiling..."
make || { echo "Error en make"; exit 1; }

sizes=(250 500 750 1000 1250)
reps=5
outfile_normal="./results/metrics_normal.txt"
outfile_eigen="./results/metrics_eigen.txt"

# Inicializar cabeceras
echo -n "N O1 O2 O3" > "$outfile_normal"
echo >> "$outfile_normal"
echo -n "N O1 O2 O3" > "$outfile_eigen"
echo >> "$outfile_eigen"

# Recorrer tamaños (cada fila será un N)
for N in "${sizes[@]}"; do
    # Inicializar arrays para cada opt
    values_normal=()
    values_eigen=()

    for opt in O1 O2 O3; do
        total_real_normal=0
        total_real_eigen=0

        for ((i=1; i<=reps; i++)); do
            real_normal=$( { /usr/bin/time -f "%e" ./build/matrixMultiplication_$opt "$N" > /dev/null; } 2>&1 )
            total_real_normal=$(echo "$total_real_normal + $real_normal" | bc -l)

            real_eigen=$( { /usr/bin/time -f "%e" ./build/eigenMultiplication_$opt "$N" > /dev/null; } 2>&1 )
            total_real_eigen=$(echo "$total_real_eigen + $real_eigen" | bc -l)
        done

        avg_real_normal=$(echo "scale=8; $total_real_normal / $reps" | bc -l)
        avg_real_eigen=$(echo "scale=8; $total_real_eigen / $reps" | bc -l)

        values_normal+=("$avg_real_normal")
        values_eigen+=("$avg_real_eigen")
    done

    # Escribir fila: N + tiempos O1 O2 O3
    echo "$N ${values_normal[*]}" >> "$outfile_normal"
    echo "$N ${values_eigen[*]}" >> "$outfile_eigen"
done

echo "Metrics saved at:"
echo " - $outfile_normal"
echo " - $outfile_eigen"

gnuplot graphCompilationLevel.gnu

echo "Graphic Generated"