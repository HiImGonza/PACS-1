#include <iomanip>
#include <iostream>
#include <limits>
#include <chrono>
#include <string>

// Allow to change the floating point type
using my_float = long double;

my_float pi_taylor(size_t steps) {
    my_float result = 0.0f;
    int sign = 1;
    for (size_t i = 0; i < steps; i++){
        result += (float) sign / (2*i + 1);
        sign = -sign;
    }

    return result * 4.0f;
}

int main(int argc, const char *argv[]) {

    // read the number of steps from the command line
    if (argc != 2) {
        std::cerr << "Invalid syntax: pi_taylor <steps>" << std::endl;
        exit(1);

    }

    size_t steps = std::stoll(argv[1]);

    auto start = std::chrono::high_resolution_clock::now();

    auto pi = pi_taylor(steps);
    
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;
    
    std::cout << "Duration: " << elapsed.count() << std::endl;

    std::cout << "For " << steps << ", pi value: "
        << std::setprecision(std::numeric_limits<my_float>::digits10 + 1)
        << pi << std::endl;
        
}
