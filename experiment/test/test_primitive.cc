#include <iostream>
#include <memory>
#include <type_traits>

using namespace std;

class TT {
 public:
  TT(int val = 100) : val_(val) { 
    cout << "Constructor." << endl;
  }

  ~TT() {
    cout << "Destructor." << endl;
  }

  int val() const  { return val_; }
  void set_val(int val) { val_ = val; }

 private:
  TT(const TT&) = delete;
  void operator=(const TT&) = delete;

  int val_;
};

void ff(shared_ptr<TT>& dst, shared_ptr<TT>&& src) {
  dst = src;
  //new (dst) shared_ptr<TT>(src);
}

int main() {
  shared_ptr<TT> aa = make_shared<TT>(10);

  shared_ptr<TT> bb;
  ff(bb, std::move(aa));

  bb->set_val(100);
  cout << "bb " << bb->val() << endl;
  cout << "aa " << aa->val() << *((int*)0) << endl;

  return 0;
}
