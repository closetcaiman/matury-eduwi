#include <iostream>
#include <vector>

int u1(int d, std::vector<int> bin) {
    bool isNegative = bin[0] == 1;
    if (isNegative) {
        int s = 1;
        while (s <= d - 1) {
            if (bin[s] == 1) {
                bin[s] = 0;
            } else {
                bin[s] = 1;
            }
            s++;
        }
    }
    int suma = 0;
    int dwojka = 1;
    for (int i = d - 1; i > 0; i--) {
        suma += bin[i] * dwojka;
        dwojka *= 2;
    }
    return isNegative ? -1 * suma : suma;
}

int main() {
    int d = 7;
    std::vector<int> bin{1, 0, 0, 1, 1, 0, 1};

    std::cout << "x: " << u1(d, bin) << "\n";
    return 0;
}
