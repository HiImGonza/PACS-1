#include <iostream>
#include <Eigen/Dense>

#include "functions.hpp"

using namespace std;
 
using Eigen::MatrixXd;
 
int main(int argc, char *argv[]) {
    int N = stoi(argv[1]); 
    MatrixXd A = MatrixXd::Random(N, N);
    MatrixXd B = MatrixXd::Random(N, N);

    // cout << A << endl;
    // cout << B << endl;

    MatrixXd result = A * B;
    
    // cout << result << endl;
 
}
