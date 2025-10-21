#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <iostream>
#include <vector>
#include <random>
#include <string>
#include <fstream>
#include <sstream>
using namespace std;

vector<vector<double>> generateMatrix(int size, float min, float max);
void saveMatrix(const vector<vector<double>>& matrix, const string& filename);
vector<vector<double>> loadMatrix(const string& filename);
void printMatrix(const vector<vector<double>>& matrix);

#endif