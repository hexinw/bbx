#include <bits/stdc++.h>

using namespace std;

struct items {
  int value;
  int weight;
};

int main() {
  int n, w;
  int total_value = 0;
  cin>>n>>w;
  items a[n];
  for(int i=0; i<n; i++){
    scanf("%d %d", &a[i].weight, &a[i].value);
    total_value += a[i].value;
  }

  // x[i][V] stands for Minimum weight for subarray of a[0...i-1] required to
  // get a value of V.
  int x[n][total_value+1];
  for(int k=0; k<=total_value; k++){
    if (k <= a[0].value) {
      x[0][k] = a[0].weight;
    } else {
      x[0][k] = w + 1;
    }
  }

  for(int i=1; i<n; i++){
    for(int j=0; j<=total_value; j++){
      if (j >= a[i].value) {
        x[i][j] = min(x[i-1][j], a[i].weight + x[i-1][j-a[i].value]);
      } else {
        x[i][j] = x[i-1][j];
      }
    }
  }

  for (int j = total_value; j >= 0; j--) {
    if (x[n-1][j] <= w) {
      cout << j;
      break;
    }
  }
}
