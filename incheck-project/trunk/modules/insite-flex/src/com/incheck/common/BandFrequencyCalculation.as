package com.incheck.common
{
	public class BandFrequencyCalculation
	{
		public static function calculateFrequency(id : uint, speed : Number, constant : Number) : Array {
			var result : Array = [calculateStartFrequency(id, speed / 60, constant), calculateEndFrequency(id, speed / 60, constant)];
			return result;
		}
		
		private static function calculateStartFrequency (id : uint, speed : Number, constant : Number) : Number {
			var result : Number = 0;
			if (id == 1) {
				result = 0;
			} else if (id == 2) {
				result = speed - speed * constant / 2;
			} else if (id == 3) {
				result = 2 * (speed - speed * constant / 2);
			} else if (id == 4) {
				result = 3 * (speed - speed * constant / 2);
			} else if (id == 5) {
				result = 0;
			} else if (id == 6) {
				result = 4 * speed - speed / 2;
			} else if (id == 7) {
				result = 10 * speed - speed / 2;
			} else if (id == 8) {
				result = 30 * speed - speed / 2;
			}
			return result;
		} 

	
		private static function calculateEndFrequency (id : uint, speed : Number, constant : Number) : Number {
			var result : Number = 0;
			if (id == 1) {
				result = 0; 
			} else if (id == 2) {
				result = speed + speed * constant / 2;
			} else if (id == 3) {
				result = 2 * (speed + speed * constant / 2);
			} else if (id == 4) {
				result = 3 * (speed + speed * constant / 2);
			} else if (id == 5) {
				result = speed - speed * constant / 2;
			} else if (id == 6) {
				result = 9 * speed + speed / 2;
			} else if (id == 7) {
				result = 30 * speed + speed / 2;
			} else if (id == 8) {
				result = 60 * speed + speed / 2;
			}
			return result;
		} 
	}
}