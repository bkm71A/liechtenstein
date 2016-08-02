
package com.incheck
{
	import com.incheck.common.ICNode;
	
	import flash.display.DisplayObject;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	
	public class OverallColumn
	{
		public static var TITLE_INDEX:int = 0;
		public static var DATE_INDEX:int  = 1;
		public static var TIME_INDEX:int  = 2;
		public static var RPM_INDEX:int   = 3;
		public static var TEMP_INDEX:int  = 4;
		public static var ROW_COUNT:int   = 5;
		
		private static var TOGGLE:String = "toggle";
		
		private var _container:HBox = new HBox();
		private var titleButton:Button = new Button();
		private var _closeButton:Button = new Button();
		private var _date:Label = new Label();
		private var _time:Label = new Label();
		private var rpm:Label = new Label();
		private var temperature:Label = new Label();
		private var channelId:int = -1;
		private var _index:int = -1;
		
		public function OverallColumn(node:ICNode, index:int){
			this.channelId = node.channelid;
			this._index = index;
			title(node);
			overall(node);
		}
		
		private function title(node:ICNode):void{
			titleButton.name = TOGGLE;
			titleButton.label = node.name;
			titleButton.toggle = true;
			titleButton.selected = true;
			_container.addChild(titleButton);
			
			_closeButton.id = node.channelid.toString();
			_closeButton.label="X";
			_closeButton.setStyle("paddingLeft", 0);
			_closeButton.setStyle("paddingRight", 0);
			_closeButton.setStyle("textIndent", 0);
			
			_container.addChild(_closeButton);			
		}
		
		private function overall(node:ICNode):void{
			_date.text = "Date";
			_time.text = "Time";
			rpm.text = node.rpm.toString();
			temperature.text = "Temperature";
		}
		
		public function titleDisplay():DisplayObject{
			return _container;
		}
		
		public function dateDisplay():DisplayObject{
			return _date;
		}
		
		public function timeDisplay():DisplayObject{
			return _time;
		}
		
		public function rpmDisplay():DisplayObject{
			return rpm;
		}
		
		public function tempDisplay():DisplayObject{
			return temperature;
		}	
		
		public function id():int{
			return channelId;
		}	
		
		public function closeButton():Button{
			return _closeButton;
		}
		
		public function index():int{
			return _index;
		}
	}
}