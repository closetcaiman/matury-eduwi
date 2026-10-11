#include <iostream>
#include <vector>

std::pair<int, int> find_min_max(std::vector<int> A) {
    int min = A[0];
    int max = A[0];

    for (int x : A) {
        min = std::min(min, x);
        max = std::max(max, x);
    }

    return {min, max};
}

int main() {
    std::vector<int> v = {1, -1, 10, -10, 3};

    std::pair<int, int> t = find_min_max(v);

    std::cout << "min: " << std::get<0>(t) << "\n";
    std::cout << "max: " << std::get<1>(t) << "\n";
    return 0;
}
