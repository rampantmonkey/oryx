int test_or(int a, int b, int c){
  if(a < b || b < c)
    return a;
  else
    return c;
}

int main(){
  return test_or(9, 5, 3);
}
