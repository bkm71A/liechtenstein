package
{
	public interface IChart
	{
		function get rmsValue():Number

		function set rmsValue(value:Number):void

		function get warningValue():Number

		function set warningValue(value:Number):void

		function get alertValue():Number

		function set alertValue(value:Number):void

		function get percentWidth():Number

		function set percentWidth(value:Number):void

		function get percentHeight():Number

		function set percentHeight(value:Number):void

		function get title():String

		function set title(value:String):void
			
		function set displayedPrecision(value:Number):void
	}
}