
#include <iostream>
#include <vector>
#include <random>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

vector<vector<double>> generateMatrix(int N, float min, float max) {
    // initialice the generator of random numbers
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<float> dis {min, max};

    vector<vector<double>> matrix(N, vector<double>(N, 0));

    // fill the matrix with random values
    for (int i=0; i<N; ++i){
        for (int j=0; j<N; j++){
            matrix[i][j] = dis(gen);
        }
    }

    return matrix;
}

void saveMatrix(const vector<vector<double>>& matrix, const string& filename) {
    fstream f(filename, ios::out);  // abrir archivo en modo escritura

    if (f.is_open()) {
        for (const auto& fila : matrix) {
            for (size_t j = 0; j < fila.size(); j++) {
                f << fila[j];
                if (j < fila.size() - 1) {
                    f << "\t"; // separador entre columnas
                }
            }
            f << "\n"; // salto de línea entre filas
        }
        f.close();
        cout << "Matriz guardada en " << filename << endl;
    } else {
        cerr << "No se pudo abrir el archivo: " << filename << endl;
    }
}

vector<vector<double>> loadMatrix(const string& filename) {
    fstream f(filename, ios::in);
    vector<vector<double>> matrix;

    if (f.is_open()) {
        string line;
        double value;

        while (getline(f, line)) {  // leer una línea completa
            stringstream ss(line);
            vector<double> row;

            while (ss >> value) {   // extraer números de la línea
                row.push_back(value);
            }

            if (!row.empty()) {
                matrix.push_back(row);
            }
        }

        f.close();
    } else {
        cerr << "No se pudo abrir el archivo: " << filename << endl;
    }

    return matrix;
}

void printMatrix(const vector<vector<double>>& matrix) {
    for (const auto& fila : matrix) {
        for (const auto& val : fila) {
            cout << val << "\t"; // tabulación para alinear columnas
        }
        cout << "\n";
    }
}
