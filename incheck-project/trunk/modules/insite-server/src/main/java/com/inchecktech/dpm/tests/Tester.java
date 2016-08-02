package com.inchecktech.dpm.tests;




public class Tester {

	
	public static void main(String[] args) throws Exception {
		
		
		
		
		
		Double f=new Double(0.000000000000000000000000000000000000000000000000000000444);
		System.out.println(f.doubleValue());
		
		
		
		System.out.println(round(f,6));
		System.exit(2);
		byte mb=new Integer(128).byteValue();
		
		

		boolean bool[]=byteToBits(mb);
		for(boolean ebol:bool){
			System.out.println(ebol);
		}

		
		
		
		
	}
	
	public static double round(double val, int places) {
		long factor = (long)Math.pow(10,places);

		// Shift the decimal the correct number of places
		// to the right.
		val = val * factor;

		// Round to the nearest integer.
		long tmp = Math.round(val);

		// Shift the decimal the correct number of places
		// back to the left.
		return (double)tmp / factor;
	    }
	 public static boolean[] byteToBits(byte b) {
	        boolean[] bits = new boolean[8];
	        for (int i = 7; i !=0; i--) {
	            bits[i] = ((b & (1 << i)) != 0);
	        }
	        return bits;
	    }
	 
	 
    public static byte bitsToByte(boolean[] bits)
    {
		return bitsToByte(bits, 0);
    }
    
    
    public static byte bitsToByte(boolean[] bits, int offset)
    {
		int value = 0;
        for (int i = 0; i < 8; i++)
        {
			if(bits[i] == true)
			{
				value = value | (1 << i);
			}
        }
        return (byte)value;
	}

}
