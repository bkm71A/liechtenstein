using System;

namespace C_sharp
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class Test
	{

		public String formatIntSql(String number)
		{
			try 
			{
				if ( number == null || number.Length<1 ) 
				{
					return "NULL";
				} 
				else 
				{
					int ahha = Int32.Parse(number);
					return ahha.ToString();
				}

			} 
			catch (System.FormatException sfe)
			{

				return "0";
			}
		}




		static void Main()
		{
			//TimeSpan ts = (DateTime.Now- new DateTime(1999,4,15)).Days /365;
			int years = 0;//ts.Days;
			years = (DateTime.Now- new DateTime(1999,4,15)).Days /365;
			try 
			{
				DateTime dt= new DateTime(1999,2,31);
			} 
			catch (Exception ex)
			{
Console.WriteLine(ex);
			}

			Console.WriteLine("Hello World !");
			Test tst = new Test();
		/*	Console.WriteLine(tst.convertSQL("'dds'\"'''"));
			int a=12;
			Console.WriteLine(tst.formatIntSql("213"));
			Console.WriteLine(tst.formatIntSql(""));
			Console.WriteLine(tst.formatIntSql("dde"));
			Console.WriteLine(tst.getSingleSince("11","12"));
			Console.WriteLine(tst.formatIntSql(null));*/

		}
	}
}
