int main(){
  int a = 8;
  int b = 13;
  int c;

  if(a < b){
    c = a;
  }else{
    c = b;
  }

  if(b > c){
    c = c + b;
  }
  else{
    c = c + a;
  }

  return c;
}
