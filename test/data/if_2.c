int a = 8;
int b = 13;

int main(){
  if(a < b){
    a = a + b;
    b = 1;
    if (b > a)
      return b;
    else
      return a;
  }
  else
    return a;
}
