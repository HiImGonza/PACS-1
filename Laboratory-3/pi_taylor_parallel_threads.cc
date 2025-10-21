#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <string>
#include <thread>
#include <utility>
#include <vector>
#include <thread>

using my_float = long double;

void
pi_taylor_chunk(std::vector<std::pair<my_float, float>> &output,
        size_t thread_id, size_t start_step, size_t stop_step) {

    auto start = std::chrono::high_resolution_clock::now();
    
    my_float result = 0.0f;

    int sign = (start_step % 2 == 0) ? 1 : -1;

    for (size_t i = start_step; i < stop_step; i++){
        result += (float) sign / (2*i + 1);
        sign = -sign;
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;

    output[thread_id] = std::make_pair(result, elapsed.count());

}


std::pair<size_t, size_t>
usage(int argc, const char *argv[]) {
    // read the number of steps from the command line
    if (argc != 3) {
        std::cerr << "Invalid syntax: pi_taylor <steps> <threads>" << std::endl;
        exit(1);
    }

    size_t steps = std::stoll(argv[1]);
    size_t threads = std::stoll(argv[2]);

    if (steps < threads){
        std::cerr << "The number of steps should be larger than the number of threads" << std::endl;
        exit(1);

    }
    return std::make_pair(steps, threads);
}

typedef struct {
    size_t large_chunk;
    size_t small_chunk;
    size_t split_item;
} chunk_info;

// For a given number of iterations N and threads
// the iterations are divided:
// N % threads receive N / threads + 1 iterations
// the rest receive N / threads
constexpr chunk_info
split_evenly(size_t N, size_t threads)
{
    return {N / threads + 1, N / threads, N % threads};
}

std::pair<size_t, size_t>
get_chunk_begin_end(const chunk_info& ci, size_t index)
{
    size_t begin = 0, end = 0;
    if (index < ci.split_item ) {
        begin = index*ci.large_chunk;
        end = begin + ci.large_chunk; // (index + 1) * ci.large_chunk
    } else {
        begin = ci.split_item*ci.large_chunk + (index - ci.split_item) * ci.small_chunk;
        end = begin + ci.small_chunk;
    }
    return std::make_pair(begin, end);
}

int main(int argc, const char *argv[]) {


    auto ret_pair = usage(argc, argv);
    auto steps = ret_pair.first;
    auto threads = ret_pair.second;

    my_float pi = 0.0f;
    float totalTime = 0.0f;

    // please complete missing parts

    std::vector<std::thread> thread_vector;
    std::vector<std::pair<my_float, float>> result_vector(threads);

    auto chunks = split_evenly(steps, threads);

    for(size_t i = 0; i < threads; i++) {

        // ToDo : run several times and check median and deviation
        // launch the work
        // auto start = std::chrono::steady_clock::now();
        // for(size_t i = 0; i < current_threads; ++i) {
        auto begin_end = get_chunk_begin_end(chunks, i);
        thread_vector.push_back(
            std::thread(pi_taylor_chunk, ref(result_vector), i, begin_end.first, begin_end.second)
        );
        std::cout << i << ", " << begin_end.first << ", " << begin_end.second << std::endl;
        // }


        // auto stop = std::chrono::steady_clock::now();
        // extime_thread.push_back(
        //         std::chrono::duration_cast<std::chrono::milliseconds>
        //         (stop-start));


    }

    // wait for completion
    for(size_t i = 0; i < threads; ++i) {
        thread_vector[i].join();
    }

    // clean the vector array
    thread_vector.clear();
    
    for (size_t i = 0; i < threads; i++) {
        std::cout << i << ", Computado: " << result_vector[i].first << ", Tiempo: " << result_vector[i].second << std::endl;

        pi += result_vector[i].first;
        totalTime += result_vector[i].second;
    }

    pi =  pi * 4;

    std::cout << "For " << steps << ", pi value: "
        << std::setprecision(std::numeric_limits<long double>::digits10 + 1)
        << pi << std::endl;
}

