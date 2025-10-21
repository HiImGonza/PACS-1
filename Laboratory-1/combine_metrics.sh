#!/bin/bash
export LC_ALL=C
set -euo pipefail

# Archivos de entrada
# time_file="./resultsLab2/metrics_avg_std_noStress.txt"         # salida del comando time
# gtod_file="./resultsLab2/metrics_avg_std_GTOD.txt"    # salida de gettimeofday
time_file="./resultsLab2/metrics_avg_std_stressed.txt"         # salida del comando time
gtod_file="./resultsLab2/metrics_avg_std_GTOD_stressed.txt"    # salida de gettimeofday
# Archivo de salida
outfile="./resultsLab2/metrics_comparable_stressed.txt"

# Inicializar archivo de salida
echo "# Size  AvgTime_Normal_Time  AvgTime_Eigen_Time  AvgTime_Normal_GTOD  AvgTime_Eigen_GTOD" > "$outfile"

# Leer los archivos línea por línea, ignorando el header
tail -n +2 "$time_file" | while read -r size avgTimeN stdTimeN avgTimeE stdTimeE; do
    # Obtener la línea correspondiente de gettimeofday
    gtod_line=$(awk -v s="$size" '$1==s {print}' "$gtod_file")
    
    # Leer los valores de GTOD
    read size_gtod avgMultN stdMultN avgRestN stdRestN avgMultE stdMultE avgRestE stdRestE <<< "$gtod_line"
    
    # Calcular tiempo total GTOD sumando multiplicación + everything else
    totalGTODN=$(echo "$avgMultN + $avgRestN" | bc -l)
    totalGTODE=$(echo "$avgMultE + $avgRestE" | bc -l)
    
    # Guardar en el archivo final
    printf "%d %.6f %.6f %.6f %.6f\n" "$size" "$avgTimeN" "$avgTimeE" "$totalGTODN" "$totalGTODE" >> "$outfile"
done

echo "Comparable metrics saved at $outfile"
