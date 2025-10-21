# Laboratory-1

## Overview
This project provides a program for matrix operations and benchmarking. It includes functionality to run tests, generate execution metrics, and visualize results in a graph.

## Requirements
- C++ compiler (e.g., g++)
- `make` build system
- Bash shell (for running scripts)

## File Structure
The strucutre of the project is the following:

    Laboratory-1/
    ├── build/                  # Compiled executables
    ├── matrixes/               # Saved matrixes 
    ├── results/                # Metrics and graphs
    ├── src/                    # Source code
    ├── graphAlltimes.gnu       # File to create the graph comparing diffent types of times (real, user, sys)
    ├── graphCompilationLevels.gnu  # File to create the graph comparing diffent times from compilation levels
    ├── makefile                # File to compile code 
    ├── testCompilationLevel.sh # Script to run tests for real time in differente levels of compilers -O1, -O2, -O3
    └── testAllTimes.sh         # Script to run tests for general times -O2

## Instalation Instruction
1. Install the stress package:
    ```bash
      sudo apt-get install stress-ng
   ```

## Execution Instructions
1. Open a terminal and navigate to the project directory:  
   ```bash
   cd Laboratory-1
   ```
2. To compile code:
    ```bash
   make
   ```
3. To execute a program individually:
   ```bash
   ./build/<executable> <args>
   ```
4. To execute tests and get metrics (Uncomment and comment the commando to stress CPU):
   ```bash
   ./<test>.sh
   ```
    This will save a file called "metrics.txt" at "./results/", it will also do the step 5 automatically.

5. To create the graph of "./results/metrics.txt" file (it must have been created):
   ```bash
   ./gnuplot <graph>.gnu
   ```
6. For cleaning the executables:
   ```bash
   make clean
   ```
