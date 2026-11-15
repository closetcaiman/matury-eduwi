#include <cmath>
#include <iostream>
#include <vector>

bool isPrime(int n) {
    if (n == 2) {
        return true;
    }
    if (n % 2 == 0) {
        return false;
    }
    for (int dzielnik = 3; dzielnik <= sqrt(n); dzielnik += 2) {
        if (n % dzielnik == 0) {
            return false;
        }
    }
    return true;
}

std::vector<int> primes(int n) {
    int i = 2;
    std::vector<int> v;
    while (v.size() < n) {
        if (isPrime(i)) {
            v.push_back(i);
        }
        i++;
    }
    return v;
}

int main() {
    int n{10};

    std::cout << "Pierwsze " << n << " liczb pierwszych to: ";
    auto v = primes(n);
    for (int e : v) {
        std::cout << e << " ";
    }
    return 0;
}
