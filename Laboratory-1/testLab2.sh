#!/bin/bash
export LC_ALL=C


# Stress CPU (background)
stress-ng --cpu $(nproc) --timeout 120s &

set -euo pipefail

echo "Compiling..."
make || { echo "Error en make"; exit 1; }

sizes=(2 10 100 250 500 750 1000 1250)
reps=5

# Archivos de salida
outfile_Normal_GTOD="./resultsLab2/metrics_Normal_GTOD.txt"
outfile_Eigen_GTOD="./resultsLab2/metrics_Eigen_GTOD.txt"
outfileStats="./resultsLab2/metrics_avg_std_GTOD_stressed.txt"

# Inicializar archivos
echo "# Size  MultiplicationTime  EverythingElseTime" > "$outfile_Normal_GTOD"
echo "# Size  MultiplicationTime  EverythingElseTime" > "$outfile_Eigen_GTOD"
echo "# Size  AVG_Mult_Normal  STD_Mult_Normal  AVG_Rest_Normal  STD_Rest_Normal  AVG_Mult_Eigen  STD_Mult_Eigen  AVG_Rest_Eigen  STD_Rest_Eigen" > "$outfileStats"

for N in "${sizes[@]}"; do
    echo "=== Executing matrix size: $N ==="

    # Ejecutar reps veces y recoger tiempos desde tus programas
    for ((i=1; i<=reps; i++)); do
        ./build/matrixMultiplication_O2 "$N" >> "$outfile_Normal_GTOD"
        ./build/eigenMultiplication_O2 "$N" >> "$outfile_Eigen_GTOD"
    done

    # --- Calcular medias y desviaciones ---
    read avgMultN stdMultN avgRestN stdRestN < <(
        awk -v n="$N" 'BEGIN{c=0;s1=s1sq=s2=s2sq=0}
            $1==n {
                v1=$2+0; v2=$3+0;
                s1+=v1; s1sq+=v1*v1;
                s2+=v2; s2sq+=v2*v2;
                c++
            }
            END{
                if(c==0){printf "NaN NaN NaN NaN\n"}
                else{
                    avg1=s1/c; std1=sqrt(s1sq/c - avg1*avg1);
                    avg2=s2/c; std2=sqrt(s2sq/c - avg2*avg2);
                    printf "%.6f %.6f %.6f %.6f\n", avg1,std1,avg2,std2;
                }
            }' "$outfile_Normal_GTOD"
    )

    read avgMultE stdMultE avgRestE stdRestE < <(
        awk -v n="$N" 'BEGIN{c=0;s1=s1sq=s2=s2sq=0}
            $1==n {
                v1=$2+0; v2=$3+0;
                s1+=v1; s1sq+=v1*v1;
                s2+=v2; s2sq+=v2*v2;
                c++
            }
            END{
                if(c==0){printf "NaN NaN NaN NaN\n"}
                else{
                    avg1=s1/c; std1=sqrt(s1sq/c - avg1*avg1);
                    avg2=s2/c; std2=sqrt(s2sq/c - avg2*avg2);
                    printf "%.6f %.6f %.6f %.6f\n", avg1,std1,avg2,std2;
                }
            }' "$outfile_Eigen_GTOD"
    )

    # Mostrar en pantalla
    echo "Size $N -> Normal [Mult: $avgMultN ± $stdMultN µs | Rest: $avgRestN ± $stdRestN µs]"
    echo "Size $N -> Eigen  [Mult: $avgMultE ± $stdMultE µs | Rest: $avgRestE ± $stdRestE µs]"

    # Guardar en archivo final
    printf "%d %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f\n" \
        "$N" \
        "$avgMultN" "$stdMultN" \
        "$avgRestN" "$stdRestN" \
        "$avgMultE" "$stdMultE" \
        "$avgRestE" "$stdRestE" \
        >> "$outfileStats"

done

echo "Metrics saved at $outfileStats"
