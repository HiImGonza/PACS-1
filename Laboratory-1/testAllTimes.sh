#!/bin/bash

# Compilar con make
echo "Compiling..."
make || { echo "Error en make"; exit 1; }

# Stress CPU (background)
stress-ng --cpu $(nproc) --timeout 120s &

# Tamaños de matrices
sizes=(2 10 100 250 500 750 1000 1250)

# Número de repeticiones
reps=5

# Archivo de salida
outfile="./resultsLab2/metrics_stressed.txt"
outfileStats="./resultsLab2/metrics_avg_std_stressed.txt"
# outfile="./results/metrics_Stress.txt"
# outfileStats="./results/metrics_avg_std_Stress.txt"


# Encabezado con todas las métricas
echo "# Size  Avg Real Normal  Avg User Normal  Avg Sys Normal  Avg Real Eigen  Avg User Eigen  Avg Sys Eigen" > "$outfile"
echo "# Size  AVG Real Normal  STD Real Normal  AVG Real Eigen  STD Real Eigen" > "$outfileStats"

# Ejecutar pruebas
for N in "${sizes[@]}"; do
    echo "Executing matrixes size: $N"

    real_normal_list=()
    real_eigen_list=()

    # Inicializar acumuladores
    total_real_normal=0
    total_user_normal=0
    total_sys_normal=0

    total_real_eigen=0
    total_user_eigen=0
    total_sys_eigen=0

    for ((i=1; i<=reps; i++)); do
        # Normal
        read real user sys <<< $( { /usr/bin/time -f "%e %U %S" ./build/matrixMultiplication_O2 "$N" > /dev/null; } 2>&1 )
        total_real_normal=$(echo "$total_real_normal + $real" | bc -l)
        total_user_normal=$(echo "$total_user_normal + $user" | bc -l)
        total_sys_normal=$(echo "$total_sys_normal + $sys" | bc -l)
        real_normal_list+=("$real")

        # Eigen
        read real user sys <<< $( { /usr/bin/time -f "%e %U %S" ./build/eigenMultiplication_O2 "$N" > /dev/null; } 2>&1 )
        total_real_eigen=$(echo "$total_real_eigen + $real" | bc -l)
        total_user_eigen=$(echo "$total_user_eigen + $user" | bc -l)
        total_sys_eigen=$(echo "$total_sys_eigen + $sys" | bc -l)
        real_eigen_list+=("$real")
    done



    # Calcular promedios
    avg_real_normal=$(echo "scale=8; $total_real_normal / $reps" | bc -l)
    avg_user_normal=$(echo "scale=8; $total_user_normal / $reps" | bc -l)
    avg_sys_normal=$(echo "scale=8; $total_sys_normal / $reps" | bc -l)

    avg_real_eigen=$(echo "scale=8; $total_real_eigen / $reps" | bc -l)
    avg_user_eigen=$(echo "scale=8; $total_user_eigen / $reps" | bc -l)
    avg_sys_eigen=$(echo "scale=8; $total_sys_eigen / $reps" | bc -l)

    # Standard Desviations
    sq_sum=0
    for v in "${real_normal_list[@]}"; do
        diff=$(echo "$v - $avg_real_normal" | bc -l)
        sq_sum=$(echo "$sq_sum + ($diff * $diff)" | bc -l)
    done
    std_normal=$(echo "scale=8; sqrt($sq_sum / $reps)" | bc -l)

    sq_sum=0
    for v in "${real_eigen_list[@]}"; do
        diff=$(echo "$v - $avg_real_eigen" | bc -l)
        sq_sum=$(echo "$sq_sum + ($diff * $diff)" | bc -l)
    done
    std_eigen=$(echo "scale=8; sqrt($sq_sum / $reps)" | bc -l)

    # Mostrar resultados en pantalla
    echo "Size $N -> Normal [Real: $avg_real_normal, User: $avg_user_normal, Sys: $avg_sys_normal]"
    echo "Size $N -> Eigen  [Real: $avg_real_eigen, User: $avg_user_eigen, Sys: $avg_sys_eigen]"

    # Guardar en archivo
    echo "$N $avg_real_normal $avg_user_normal $avg_sys_normal $avg_real_eigen $avg_user_eigen $avg_sys_eigen" >> "$outfile"
    echo "$N $avg_real_normal $std_normal $avg_real_eigen $std_eigen" >> "$outfileStats"

done

echo "Metrics saved at $outfile"
echo "Metrics saved at $outfileStats"

