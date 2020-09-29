#include <iostream>

using namespace std;

template<int Num> struct Placeholder {};

void ff(int num) {
  cout << num;
}

int main() {
  cout << "Hello World " << endl;
  ff(Placeholder<3>());
}
