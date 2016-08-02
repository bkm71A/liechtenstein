package com.incheck.charts {
    import com.incheck.InCheckStockSeries;
    import com.incheck.IncheckModel;
    import com.incheck.common.DataViewScalingTypes;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import mx.charts.DateTimeAxis;
    import mx.charts.LinearAxis;
    import mx.charts.chartClasses.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.core.Application;
    import mx.graphics.Stroke;
    
    public class RangeSelectorHistory extends ChartElement {
    
        /* the bounds of the selected region*/
        private var dLeft:Number = 20;
        
        private var dRight:Number = 80;
        
        /* the x/y coordinates of the start of the tracking region */
        private var tX:Number;
        private var tY:Number;

		private var mouseStartX:Number;
        private var mouseStartY:Number;
		private var zoomType:String = "v";
		private var mouseMoveEventAdded:Boolean = false;
		private var mouseIsDown:Boolean = false;
        public static var areWeZooming:Boolean = false;
        public static var haveWeZoomed:Boolean = false;
		private var dragStartPoint:Point;
		
        /* whether or not we're currently tracking */        
        private var bTracking:Boolean = false;

        /* the current position of the crosshairs */
        private var _startMin:Number;
		private var _startMax:Number;
		private var _startMouseData:Array;
		private var _start1PixelOffset:Array;
		private var _startOriginPixels:Point;
		private var _startMousePointInPixels:Point;
		
		private var _unscaledHeightAtDragStart:Number;
		
        /* constructor */
        public function RangeSelectorHistory():void
        {
            super();
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, mouseRollOver, false, 0, true);
			FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
            areWeZooming = false;
        }

        /* draw the overlay */
        override protected function updateDisplayList(unscaledWidth:Number,
                                                   unscaledHeight:Number):void
        {

			var g:Graphics = graphics;
			g.clear();
			// draw a big transparent square so the flash player sees us for mouse events
			g.moveTo(0, 0);
			g.lineStyle(0, 0, 0);
			g.beginFill(0, 0);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
			
			var mySeries:Array = chart.series;
			var dp:ArrayCollection;
			var colObj:Object;
			measure();
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var drawCircles:Boolean = true;//(IncheckModel.instance().historyChartUnits == "seconds");
			
			for each (var series:InCheckStockSeries in mySeries) {
				dp = series.dataProvider as ArrayCollection;
				var stroke:Stroke = series.getStyle("stroke") as Stroke;
				g.lineStyle(2, stroke.color);
				var obj:Object;
				var point:Point;
				var n:int = dp.length;
				if (!n) continue;
				obj = dp.getItemAt(0);
				point = series.dataToLocal(obj.x, obj.avgValue);
				g.moveTo(point.x, point.y);
				for (var i:int = 0; i < n ; i++){
					obj = dp.getItemAt(i);
					point = series.dataToLocal(obj.x, obj.avgValue);
					g.lineTo(point.x, point.y);
					g.lineStyle(1, stroke.color);
					if (drawCircles) {
						g.drawCircle(point.x, point.y, 5);
						g.moveTo(point.x, point.y);
					}
					g.lineStyle(2, stroke.color);
				}
			}
        }
		
		private function startZoom(e:MouseEvent):void {
			var hAxis:DateTimeAxis = DateTimeAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
			var vAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.VERTICAL_AXIS));
			_startMin = vAxis.minimum;
			_startMax = vAxis.maximum;
			_startMousePointInPixels = new Point(mouseX, mouseY);
			_startMouseData = dataTransform.invertTransform(mouseX, mouseY);
			_start1PixelOffset = dataTransform.invertTransform(mouseX + 1, mouseY + 1);
			_start1PixelOffset[0] -= _startMouseData[0];
			_start1PixelOffset[1] -= _startMouseData[1];
			var cache:Array = [ {xV:0, yV:0} ];
			dataTransform.transformCache(cache, "xV", "x", "yV", "y");
			_startOriginPixels = new Point(cache[0].x, cache[0].y);
			cache[0].xV = 1;
			cache[0].yV = 1;
			_unscaledHeightAtDragStart = unscaledHeight;
			areWeZooming = true;
            haveWeZoomed = false;    
		}
		
		private function mouseDown(e:MouseEvent):void {
			// are we over anything thats draggable?
			trace("history: mouse down")
			mouseIsDown = true;
			var dataVals:Array;
			
			if (IncheckModel.instance().scalingHistoryMenuSelection == DataViewScalingTypes.VZoom) {// || e.shiftKey )
				dragStartPoint = new Point(mouseX, mouseY);
				dataVals = dataTransform.invertTransform(mouseX, mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				zoomType = "v";
				startZoom(e);
				updateTrackBounds(dataVals);
			} else if (IncheckModel.instance().scalingHistoryMenuSelection == DataViewScalingTypes.Pan) {// || e.altKey)
				dragStartPoint = new Point(mouseX, mouseY);
				dataVals = dataTransform.invertTransform(mouseX, mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				zoomType = "p";
				startZoom(e);
				updateTrackBounds(dataVals);
			}
		}
		
		private function updateTrackBounds(dataVals:Array):void {
			var vAxis:LinearAxis;
			if (zoomType == "v") {
				vAxis = LinearAxis(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS));
				var newMin:Number = _startMouseData[1] * (_unscaledHeightAtDragStart - _startOriginPixels.y) / (mouseY - _startOriginPixels.y);
				trace("mewMin " + newMin )
				trace(" _startMin " +  _startMin);
				trace(" _startOriginPixels " +  _startOriginPixels.y);
				var ratio:Number = (_unscaledHeightAtDragStart - _startMousePointInPixels.y) / (_unscaledHeightAtDragStart - mouseY); //newMin / _startMin;
				trace("ratio " + ratio )
				if (ratio > 0)
				{                  
					vAxis.maximum = ratio * (_startMax - _startMin) + _startMin;
					//vAxis.minimum = ratio * _startMin;
					trace ("vAxis.maximum " + vAxis.maximum)
					trace ("vAxis.minimum " + vAxis.minimum)
				}
				invalidateDisplayList();
			} else if (zoomType == "p") {
				vAxis = LinearAxis(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS));
				var dX:Number = mouseX - _startMousePointInPixels.x;
				var dY:Number = mouseY - _startMousePointInPixels.y;
				
				var proposedVMax:Number = _startMax - dY * _start1PixelOffset[1];
				var proposedVMin:Number = _startMin - dY * _start1PixelOffset[1];
				if (proposedVMax > IncheckModel.instance().right.historyChart.ymax || proposedVMin < IncheckModel.instance().right.historyChart.ymin) {
					//vAxis.maximum = IncheckModel.instance().right.dataViewChart.ymax
					//vAxis.minimum =IncheckModel.instance().right.dataViewChart.ymin
					return;
				} else {
					vAxis.maximum = proposedVMax;
					vAxis.minimum = proposedVMin;
				}
			}
			/* invalidate our data, and redraw */
			dataChanged();
			invalidateDisplayList();
			chart.invalidateDisplayList();
		}

		private function mouseUp(e:MouseEvent):void {
			trace("history: mouse up")
            if (!mouseIsDown) {
				return;
			}
			mouseIsDown = false;
			if (areWeZooming) {
				areWeZooming = false;
				e.stopPropagation();
				if (zoomType == "v") {
					if (Math.abs(dragStartPoint.y - mouseY) > 20) {
						updateTrackBounds(dataTransform.invertTransform(mouseX, mouseY));
                        haveWeZoomed = true;
					} else {
                        haveWeZoomed = false;
					}
				}
				areWeZooming = false;
			}
			invalidateDisplayList();
		}
		
		private function mouseRollOver(e:MouseEvent):void
		{
			//FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			if (chart != null && !mouseMoveEventAdded)
			{
				mouseMoveEventAdded = true;
				chart.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			}
		}
		
		private function mouseMove(e:MouseEvent):void {
			if (areWeZooming) {
				updateTrackBounds(dataTransform.invertTransform(mouseX, mouseY));
				e.stopPropagation();
			}
			invalidateDisplayList();
		}

//        override public function mappingChanged():void
//        {
//            /* since we store our selection in data coordinates, we need to redraw when the mapping between data coordinates and screen coordinates changes
//            */
//            invalidateDisplayList();
//        }
//
//        private function startTracking(e:MouseEvent) :void
//        {
//            /* the user clicked the mouse down. First, we need to add listeners for the mouse dragging */
////            Alert.show(pare);
//            bTracking = true;
//
//            FlexGlobals.topLevelApplication.addEventListener("mouseUp",endTracking,true);
//
//            FlexGlobals.topLevelApplication.addEventListener("mouseMove",track,true);
//            
//            mouseStartX=mouseX;
//            mouseStartY=mouseY;
//
//            /* now store off the data values where the user clicked the mouse */
//            var dataVals:Array = dataTransform.invertTransform(mouseX,mouseY);
//            tX = dataVals[0];
//            tY = dataVals[1];
//            bSet = false;
//
//            updateTrackBounds(dataVals);
//        }
//
//        private function track(e:MouseEvent):void {
//            if(bTracking == false){
//                return;
//            }
//            bSet = true;
//            updateTrackBounds(dataTransform.invertTransform(mouseX,mouseY));
//            e.stopPropagation();
//        }
//
//        private function endTracking(e:MouseEvent):void
//        {
//        	
//        	var g:Graphics = graphics;
//            g.clear();
//        	
//            /* the selection is complete, so remove our listeners and update one last time to match the final position of the mouse */
//		   bTracking = false;
//            FlexGlobals.topLevelApplication.removeEventListener("mouseUp",endTracking,true);
//            FlexGlobals.topLevelApplication.removeEventListener("mouseMove",track,true);
//
//            e.stopPropagation();
//            //if(Math.abs(mouseStartX-mouseX) > 20){
//            
//			 if(Math.abs(mouseStartX-mouseX) > 20){
//               updateTrackBounds(dataTransform.invertTransform(mouseX,mouseY));
//            }else{
//            	bSet=false;
//            }
//        }
//
//		private function updateTrackBounds(dataVals:Array):void
//        {
//            /* store the bounding rectangle of the selection, in a normalized data-based rectangle */
//            dRight = Math.max(tX, dataVals[0]);
//            dLeft = Math.min(tX, dataVals[0]);
//            
//            var dMax:Date = new Date();
//            var dMin:Date = new Date();
//            if (bTracking==false){
//            	dMax=new Date();
//            	dMin=new Date();
//            	if(tX>dataVals[0]){
//            		dMax.setTime(tX);
//            		dMin.setTime(dataVals[0]);
//            	}else{
//            		dMax.setTime(dataVals[0]);
//            		dMin.setTime(tX);
//            	}
//            	(IncheckModel.instance().right.historyChart.horizontalAxis as DateTimeAxis).maximum=dMax;
//	            (IncheckModel.instance().right.historyChart.horizontalAxis as DateTimeAxis).minimum=dMin;
//
//				dRight=0
//				dLeft=0;
//            }
//            dataChanged();
//            invalidateProperties();
//            invalidateDisplayList();
//        }
//        
    }
}

