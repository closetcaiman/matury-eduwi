
#include <iostream>
#include <string>

using namespace std;

string convert(int n, int p) {
    string wynik = "";
    string Z = "0123456789ABCDEF";
    while (n > 0) {
        wynik = Z[n % p] + wynik;
        n = n / p;
    }
    return wynik;
}

int main() {
    int x{90};

    cout << convert(x, 16) << "\n";

    return 0;
}
