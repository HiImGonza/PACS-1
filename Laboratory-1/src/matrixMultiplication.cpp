// #include "functions.hpp"
#include <iostream>
#include <vector>
#include <random>
#include <string>
#include <fstream>
#include <sstream>
#include <sys/time.h>
#include <iomanip>
using namespace std;

const int AVG_NUMBER = 100;
const int LENGHT_TEST = 8;
const int MATRIX_TEST_SIZES[LENGHT_TEST] = {2, 10, 100, 250, 500, 750, 1000, 2000};

const int DEFAULT_MIN = 0;
const int DEFAULT_MAX = 10;


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
    fstream f(filename, ios::out);  

    if (f.is_open()) {
        for (const auto& fila : matrix) {
            for (size_t j = 0; j < fila.size(); j++) {
                f << fila[j];
                if (j < fila.size() - 1) {
                    f << "\t";
                }
            }
            f << "\n"; 
        }
        f.close();
        cout << "Matrix saved in " << filename << endl;
    } else {
        cerr << "file could not be opened: " << filename << endl;
    }
}

vector<vector<double>> loadMatrix(const string& filename) {
    fstream f(filename, ios::in);
    vector<vector<double>> matrix;

    if (f.is_open()) {
        string line;
        double value;

        while (getline(f, line)) {  
            stringstream ss(line);
            vector<double> row;

            while (ss >> value) {   
                row.push_back(value);
            }

            if (!row.empty()) {
                matrix.push_back(row);
            }
        }

        f.close();
    } else {
        cerr << "file could not be opened: " << filename << endl;
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


vector<vector<double>> multiplyMatrix(const int size, const vector<vector<double>>& matrix1, const vector<vector<double>>& matrix2) {
    vector<vector<double>> result(size, vector<double>(size, 0));
    for (int rows = 0; rows < size; rows++) {
        for (int cols = 0; cols < size; cols++) {
            for (int k = 0; k < size; k++) {
                result[rows][cols] += matrix1[rows][k] * matrix2[k][cols];
            }
        }
    }
    return result;
}

double computeDifference(timeval timestampEverythingStart, timeval timestampEverythingEnd) {
    return (timestampEverythingEnd.tv_sec - timestampEverythingStart.tv_sec) * 1000000 + (timestampEverythingEnd.tv_usec - timestampEverythingStart.tv_usec);
}


int main(int argc, char *argv[]) {

    if (argc != 2) cerr << "One parameter N is required (Matrix Size)" << endl;
    
    struct timeval timestampEverythingStart, timestampEverythingEnd;

    gettimeofday(&timestampEverythingStart, NULL);
    int N = 1;
    vector<vector<double>> matrix1;
    vector<vector<double>> matrix2;
    
    N = stoi(argv[1]);
    matrix1 = generateMatrix(N, DEFAULT_MIN, DEFAULT_MAX);
    matrix2 = generateMatrix(N, DEFAULT_MIN, DEFAULT_MAX);
    gettimeofday(&timestampEverythingEnd, NULL);

    struct timeval timestampMultiplicationStart, timestampMultiplicationEnd;

    gettimeofday(&timestampMultiplicationStart, NULL);
    vector<vector<double>> result = multiplyMatrix(N, matrix1, matrix2);
    gettimeofday(&timestampMultiplicationEnd, NULL);

    double secEverything = computeDifference(timestampEverythingStart, timestampEverythingEnd) / 1e6;
    double secMult = computeDifference(timestampMultiplicationStart, timestampMultiplicationEnd) / 1e6;

    fstream f("./resultsLab2/metrics_Normal_GTOD.txt", ios::app);
    if (f.is_open()) {
        f << N << "\t" << secMult << "\t" << secEverything << "\n";
        f.close();
    } else {
        cerr << "File could not be opened: ./resultsLab2/metrics_Normal_GTOD.txt" << endl;
    }


    
    return 0;
}