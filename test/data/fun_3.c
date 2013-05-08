int fun_3(int a, int b) {
  int c = a*a;
  int d = 2*a*b;
  int e = b*b;
  int sum = c + d + e;
  return sum;
}

int main(){
  return fun_3(5,6);
}
