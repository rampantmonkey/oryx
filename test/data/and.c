int test_and(int a, int b, int c){
  if(a < b && b > c)
    return 5;
  else
    return 4;
}

int main(){
  int a = 7;
  int b = 8;
  int c = 1;

  return test_and(a, b, c);
}
