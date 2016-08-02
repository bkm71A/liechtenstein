

package com.incheck
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.core.UIComponent;
	
	public class ChartBox extends VBox
	{
		
		public  function ChartBox(){
			super();
//			this.addEventListener(MouseEvent.MOUSE_OVER,containerMouseOver);
	//		this.addEventListener(MouseEvent.MOUSE_OUT,containerMouseOut);
		//	this.addEventListener(Event.ENTER_FRAME,addVcurs);



		}
		
		private var selLC:UIComponent;
		private var drawCursor:Boolean=false;
		

		
		

		private function containerMouseOver(event:MouseEvent):void{
//			setMouseUpOrDown(event);

			drawCursor=true;
			
		}
		private function containerMouseOut(event:MouseEvent):void{
//			setMouseUpOrDown(event);
			drawCursor=false;
			this.graphics.clear();
			
		}
		
		private function addVcurs(event:Event):void{

//			if(mouseIsDownNow){
				if(drawCursor){

					if(this.mouseFocusEnabled){

						var g:Graphics;
						var mousex:int=this.mouseX;
						var mousey:int=this.mouseY;
						var myH:int=this.height;
						var myW:int=this.width;
						
						g=this.graphics;
					
			   	      	g.clear(); 
			       	  	g.beginFill(0xFF0000);
			            g.drawRect(mousex,0,1,myH);
	
			   	        g.endFill();

			   	        
			   	   
			   	        
			   	        
					}
				}
//			}
		}
				
		
	}

}