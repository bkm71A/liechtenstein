namespace Beshert {
  using System;
  class Test{

    public void formatIntSql(String number){
      if ( number == null || number..Length<1 ) {
        return "NULL";
      } else {
      int ahha = Int32.Parse(number);

      }
      Console.WriteLine("The number is :"+ahha);
    }

    static void Main(){
      Console.WriteLine("Hello World !");
      Test tst = new Test();
      tst.testInt("213");
      tst.testInt("");
    }
  }

}