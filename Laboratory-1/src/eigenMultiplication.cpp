#include <iostream>
#include <Eigen/Dense>
#include <fstream>
#include <sys/time.h>

using namespace std;
using Eigen::MatrixXd;

// --- Función auxiliar para diferencia de tiempos ---
double computeDifference(timeval tStart, timeval tEnd) {
    return (tEnd.tv_sec - tStart.tv_sec) * 1000000 + (tEnd.tv_usec - tStart.tv_usec);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        cerr << "One parameter N is required (Matrix Size)" << endl;
        return 1;
    }

    int N = stoi(argv[1]);

    struct timeval timestampEverythingStart, timestampEverythingEnd;
    gettimeofday(&timestampEverythingStart, NULL);

    // --- Generación de matrices aleatorias ---
    MatrixXd A = MatrixXd::Random(N, N);
    MatrixXd B = MatrixXd::Random(N, N);

    gettimeofday(&timestampEverythingEnd, NULL);

    struct timeval timestampMultiplicationStart, timestampMultiplicationEnd;

    // --- Multiplicación Eigen ---
    gettimeofday(&timestampMultiplicationStart, NULL);
    MatrixXd result = A * B;
    gettimeofday(&timestampMultiplicationEnd, NULL);

    // --- Convertir diferencias a segundos ---
    double secEverything = computeDifference(timestampEverythingStart, timestampEverythingEnd) / 1e6;
    double secMult = computeDifference(timestampMultiplicationStart, timestampMultiplicationEnd) / 1e6;

    // --- Guardar resultados ---
    fstream f("./resultsLab2/metrics_Eigen_GTOD.txt", ios::app);
    if (f.is_open()) {
        f << N << "\t" << secMult << "\t" << secEverything << "\n";
        f.close();
    } else {
        cerr << "No se pudo abrir el archivo: ./resultsLab2/metrics_Eigen_GTOD.txt" << endl;
    }

    return 0;
}
