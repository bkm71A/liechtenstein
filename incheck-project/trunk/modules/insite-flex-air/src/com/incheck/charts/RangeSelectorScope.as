package com.incheck.charts
{
	import com.incheck.InCheckLineSeries;
	import com.incheck.IncheckChart3;
	import com.incheck.IncheckChartScope;
	import com.incheck.IncheckModel;
	import com.incheck.common.DataViewCursorTypes;
	import com.incheck.common.DataViewScalingTypes;
	import com.incheck.components.events.AnalysisTabEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.*;
	import mx.collections.ArrayCollection;
	import mx.controls.*;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UITextField;
	import mx.formatters.NumberFormatter;
	import mx.managers.CursorManager;


	public class RangeSelectorScope extends ChartElement
	{
		private static const DEFAULT_STEP:int = 3;

		private static const PRECISION:int = 4;

		private static const SN_THRESHOLD:int = 3;

		/* the x/y coordinates of the start of the tracking region */
		private var tX:Number;

		private var tY:Number;

		/* the bounds of the selected region*/
		private var dLeft:Number = 20;

		private var dTop:Number = 20;

		private var dRight:Number = 80;

		private var dBottom:Number = 80;

		private var mouseIsDown:Boolean = false;

		private var numFormat:NumberFormatter = new NumberFormatter();

		private var _keyboardSpeedFactor:uint = 1;

		private var _crosshairs:Point;

		private var labelTextFields:Array = new Array();

		private var sideBandPoints:Array = new Array();

		private var xTit:String = "";

		private var yTit:String = "";

		private var _cursorOne:Point;

		private var _cursorTwo:Point;

		private var _cursorOneObj:Object;

		private var _cursorTwoObj:Object;

		private var _crosshairLabel:UITextField;

		private var areWeDragginAnything:Boolean = false;

		private var dragginCursorOne:Boolean = false;

		private var dragginCursorTwo:Boolean = false;

		private var nudgingCursorOne:Boolean = false;

		private var nudgingCursorTwo:Boolean = false;

		private var searchStep:int = 3;

		private var harmonicType:uint = 1;

		private var lastKnownGraph:String;

		private var lastKnownFunction:String;

		private var lastKnownCursor:uint;

		private var lastClickedCursor:uint;

		private var mouseMoveEventAdded:Boolean = false;

		private var KeyIsDown:Boolean = false;

		private var draggingSideBand:Boolean = true;

		private var draggedSideBandIndex:uint;

		private var dragStartPoint:Point;

		private var pseudoMouseCursor:Point;

		private var areWeZooming:Boolean = false;

		private var zoomType:String = "h";

		private var _startMin:Point;

		private var _startMax:Point;

		private var _startMouseData:Array;

		private var _start1PixelOffset:Array;

		private var _startOriginPixels:Point;

		private var _startMousePointInPixels:Point;

		// private var _dragTool:String;
		private var _isZoomOrPanEnabled:Boolean = false;

		private var _chartTypeNow:String;

		private var _lastRatio:Number = NaN;

		private var _unscaledHeightAtDragStart:Number;

		private var bSet:Boolean = false;

		private var SideBanddStepSize:Number = 30;

		private var dataGridProvider:ArrayCollection = new ArrayCollection();

		[Embed(source = "/assets/hand.png")]
		[Bindable]
		public var Cursor1:Class;


		public function RangeSelectorScope():void
		{
			numFormat.precision = 3;
			numFormat.rounding = "up";
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			//FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE,debugMove);
//            FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
//			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN, keyDePressed);
			addEventListener(MouseEvent.ROLL_OVER, mouseRollOver, false, 0, true);

			BindingUtils.bindSetter(cursorTypeChanged, IncheckModel.instance(), "cursorMenuSelectionScope");
			BindingUtils.bindSetter(functionTypeChanged, IncheckModel.instance(), "functionMenuSelectionScope");
			BindingUtils.bindSetter(chartTypeChanged, IncheckModel.instance(), "graphMenuSelectionScope");

			lastKnownGraph = IncheckModel.instance().graphMenuSelectionScope;
			lastKnownFunction = IncheckModel.instance().functionMenuSelectionScope;
			lastKnownCursor = IncheckModel.instance().cursorMenuSelectionScope;
		}


		public function keyDePressed(ev:KeyboardEvent):void
		{
			KeyIsDown = false;
			_keyboardSpeedFactor = 1;
			invalidateDisplayList();
		}


		/*
				public function keyPressed(ev:KeyboardEvent):void
				{
					///Alert.show(ev.keyCode+"\t")
					if (ev.keyCode == 8)  // Backspace key
					{
						IncheckModel.instance().right.dataViewChart.resetHorizontalZoom();
						IncheckModel.instance().setCursorSelection(DataViewCursorTypes.Zoom);
						IncheckModel.instance().right.dataViewMenuBar.nocurs.toggled = true;
						IncheckModel.instance().right.dataViewMenuBar.zreset.toggled = false;
						IncheckModel.instance().right.dataViewMenuBar.vzoom.toggled = false;
						IncheckModel.instance().right.dataViewMenuBar.hzoom.toggled = false;
						IncheckModel.instance().right.dataViewMenuBar.panzoom.toggled = false;
					}
					else if (_cursorOne != null)
					{
						KeyIsDown = true;
						if (ev.keyCode == 37) // Left Arrow key
						{
							// step back
							if (lastClickedCursor == 2 && _cursorTwo != null)
							{
								_cursorTwo.x--;
								nudgingCursorTwo = true;
								doCursors(_cursorTwo);
							}
							else
							{
								_cursorOne.x--;
								nudgingCursorOne = true;
								doCursors(_cursorOne);
							}
							_keyboardSpeedFactor++;
							resetSearchStep();
							invalidateDisplayList();
						}
						else if (ev.keyCode == 39) // Right Arrow key
						{
							//step forward
							if (lastClickedCursor == 2 && _cursorTwo != null)
							{
								_cursorTwo.x++;
								nudgingCursorTwo = true;
								doCursors(_cursorTwo);
							}
							else
							{
								_cursorOne.x = _cursorOne.x + (_keyboardSpeedFactor);
								nudgingCursorOne = true;
								doCursors(_cursorOne);
							}
							_keyboardSpeedFactor = _keyboardSpeedFactor + (_cursorOne.x * .05);
							resetSearchStep();
							invalidateDisplayList();
						}
						else if (ev.keyCode == 49 && ev.ctrlKey)  // 1 key and CTRL key
						{
							// one is pressed
							lastClickedCursor = 1;
						}
						else if (ev.keyCode == 50 && ev.ctrlKey) // 2 key and CTRL key
						{
							// one is pressed
							lastClickedCursor = 2;
						}
						else if (ev.keyCode == 38 && IncheckModel.instance().cursorMenuSelection == DataViewCursorTypes.Sideband)  // Up Arrow key
						{
							SideBanddStepSize++;
						}
						else if (ev.keyCode == 40 && IncheckModel.instance().cursorMenuSelection == DataViewCursorTypes.Sideband) // Down Arrow key
						{
							SideBanddStepSize--;
						}
						else if (ev.keyCode == Keyboard.PAGE_UP || ev.keyCode == Keyboard.PAGE_DOWN) // PgUp
						{
							// moving cursor to the nearest peak
							var x:Number = 0;
							if (lastClickedCursor == 2 && _cursorTwo != null){
								x = findNearestPeak(_cursorTwo.x);
								_cursorTwo.x = x;
								nudgingCursorTwo = true;
								doCursors(_cursorTwo);
							} else {
								x = findNearestPeak(_cursorOne.x);
								_cursorOne.x = x;
								nudgingCursorOne = true;
								doCursors(_cursorOne);
							}
							searchStep *= 2;
						}
					}
					invalidateDisplayList();
				}
		*/

		private function findNearestPeak(cursorPosition:Number):Number
		{
			var mySeries:InCheckLineSeries = getSeries();
			var myDP:ArrayCollection = mySeries.dataProvider as ArrayCollection;
			var colObj:Object;
			var newX:Object;
			var reval:Array = mySeries.localToData(new Point(cursorPosition, 0));
			// find x and object for this x;
			var l:int = myDP.length;
			var i:int = 0;
			while (i < l)
			{
				colObj = myDP.getItemAt(i);
				if (colObj.x >= reval[0])
				{
					break;
				}
				i++;
			}

			// find max data within the search range
			var jMax:int = i;
			var yMax:Number = colObj.y;
			for (var j:int = i - searchStep; j <= i + searchStep; j++)
			{
				if ((j >= 0) && (j < l))
				{
					if (myDP.getItemAt(j).y > yMax)
					{
						yMax = myDP.getItemAt(j).y;
						jMax = j;
					}
				}
			}

			// verify that this is a peak (not a side of the slope)
			if ((jMax > i - searchStep) && (jMax < i + searchStep))
			{
				newX = myDP.getItemAt(jMax);
				return mySeries.dataToLocal(newX.x, newX.y).x
			}

			// find nearest peak to the right from x;
			var dRight:Number = 0;
			var prev:Number; // = myDP.getItemAt(i - 1).y;
			var cur:Number = 0;
			if ((i - 1) >= 0)
			{
				cur = myDP.getItemAt(i - 1).y;
			}
			var next:Number = myDP.getItemAt(i).y;
			var foundRight:Boolean = false;
			while (!foundRight)
			{
				prev = cur;
				cur = next;
				if (i + 1 + dRight >= l)
				{
					if (prev < cur)
					{
						foundRight = true;
					}
					else
					{
						foundRight = false;
					}
					break;
				}
				next = myDP.getItemAt(i + 1 + dRight).y;
				if (cur > next && cur > prev)
				{
					foundRight = true;
				}
				else
				{
					dRight++;
				}
			}
			// find nearest peak to the left from x;
			// compare distance from x to left and right peaks and chose the nearest in any diraction 
			var dLeft:Number = 0;
			var foundLeft:Boolean = false;
			if ((i + 1) >= l)
			{
				cur = 0;
			}
			else
			{
				cur = myDP.getItemAt(i).y;
			}
			next = myDP.getItemAt(i - 1).y;
			while (!foundLeft && ((dLeft < dRight) && foundRight || !foundRight))
			{
				prev = cur;
				cur = next;
				if (i - 2 - dLeft < 0)
				{
					dLeft = dRight + 1;
				}
				else
				{
					next = myDP.getItemAt(i - 2 - dLeft).y;
					if (cur > next && cur > prev)
					{
						foundLeft = true;
					}
					else
					{
						dLeft++;
					}
				}
			}

			if (foundLeft)
			{
				newX = myDP.getItemAt(i - 1 - dLeft);
			}
			else
			{
				newX = myDP.getItemAt(i + dRight);
			}
			return mySeries.dataToLocal(newX.x, newX.y).x;
		}


		private function resetSearchStep():void
		{
			searchStep = DEFAULT_STEP;
		}


		private function chartTypeChanged(str:String):void
		{
			if ((lastKnownGraph == "accel" && str == "velo") || (lastKnownGraph == "velo" && str == "accel"))
			{
				//do nothing	
			}
			else
			{
				_cursorOne = null;
				_cursorOneObj = null;
				_cursorTwo = null;
				_cursorTwoObj = null;
				sideBandPoints = new Array();
			}
			lastKnownGraph = str;
			resetSearchStep();
			invalidateDisplayList();
		}


		private function functionTypeChanged(str:String):void
		{
			_cursorOne = null;
			_cursorOneObj = null;
			_cursorTwo = null;
			_cursorTwoObj = null;
			lastKnownFunction = str;
			resetSearchStep();
			invalidateDisplayList();
		}


		private function cursorTypeChanged(num:uint):void
		{
			SideBanddStepSize = 30;
			_cursorOne = null;
			_cursorOneObj = null;
			_cursorTwo = null;
			_cursorTwoObj = null;
			resetSearchStep();
			invalidateDisplayList();
		}


		private function mouseRollOut2(e:MouseEvent):void
		{
			FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);

		/*
		mouseUp(e)
		areWeDragginAnything=false;
		areWeZooming=false;
		bSet=false;
		*/
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


		private function startZoom(e:MouseEvent):void
		{
			var hAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
			var vAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.VERTICAL_AXIS));
			_startMin = new Point(hAxis.minimum, vAxis.minimum);
			_startMax = new Point(hAxis.maximum, vAxis.maximum);
			trace("_startMin " + vAxis.minimum);
			trace("_startMax " + vAxis.maximum);
			_startMousePointInPixels = new Point(mouseX, mouseY);
			_startMouseData = dataTransform.invertTransform(mouseX, mouseY);
			trace("mouseX, mouseY " + mouseX + " " + mouseY);
			_start1PixelOffset = dataTransform.invertTransform(mouseX + 1, mouseY + 1);
			trace("_startMouseData " + _startMouseData[0] + " " + _startMouseData[1]);
			_start1PixelOffset[0] -= _startMouseData[0];
			_start1PixelOffset[1] -= _startMouseData[1];
			trace("_start1PixelOffset " + _start1PixelOffset[0] + " " + _start1PixelOffset[1]);
			var cache:Array = [{xV:0, yV:0}];
			dataTransform.transformCache(cache, "xV", "x", "yV", "y");
			_startOriginPixels = new Point(cache[0].x, cache[0].y);
			trace("_startOriginPixels " + _startOriginPixels.x + " " + _startOriginPixels.y);
			cache[0].xV = 1;
			cache[0].yV = 1;
			_unscaledHeightAtDragStart = unscaledHeight;
			trace("_unscaledHeightAtDragStart " + _unscaledHeightAtDragStart);
			areWeZooming = true;
		}


		private function mouseDown(e:MouseEvent):void
		{
			// are we over anything thats draggable?
			mouseIsDown = true;
			var dataVals:Array;
			if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Single || IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Double || IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Harmonic || IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Sideband)
			{
				dragStartPoint = new Point(mouseX, mouseY);
				if (_cursorOne != null && Math.abs(_cursorOne.x - mouseX) < 4)
				{
					areWeDragginAnything = true;
					dragginCursorOne = true;
					lastClickedCursor = 1;
				}
				else if (_cursorTwo != null && Math.abs(_cursorTwo.x - mouseX) < 4)
				{
					areWeDragginAnything = true;
					dragginCursorTwo = true;
					lastClickedCursor = 2;
				}
				else if (sideBandPoints != null)
				{
					var cntr:uint = 0;
					for each (var sidePoint:Number in sideBandPoints)
					{
						if (Math.abs(sidePoint - mouseX) < 3)
						{
							areWeDragginAnything = true;
							draggingSideBand = true;
							draggedSideBandIndex = cntr;
						}
						if (cntr == 0)
						{
							break;
						}
						cntr++;
					}
				}
			}
			if (areWeDragginAnything)
			{
				return;
			}
			if (IncheckModel.instance().scalingMenuSelectionScope == DataViewScalingTypes.HZoom || e.ctrlKey)
			{
				dragStartPoint = new Point(mouseX, mouseY);
				dataVals = dataTransform.invertTransform(mouseX, mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				bSet = true;
				zoomType = "h";
				startZoom(e);
				updateTrackBounds(dataVals);
					//var mySeries:InCheckLineSeries=chart.series[0];    			
			}
			else if (IncheckModel.instance().scalingMenuSelectionScope == DataViewScalingTypes.VZoom || e.shiftKey)
			{
				dragStartPoint = new Point(mouseX, mouseY);
				dataVals = dataTransform.invertTransform(mouseX, mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				bSet = false;
				zoomType = "v";
				startZoom(e);
				updateTrackBounds(dataVals);
			}
			else if (IncheckModel.instance().scalingMenuSelectionScope == DataViewScalingTypes.Pan || e.altKey)
			{
				dragStartPoint = new Point(mouseX, mouseY);
				dataVals = dataTransform.invertTransform(mouseX, mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				bSet = true;
				zoomType = "p";
				startZoom(e);
				updateTrackBounds(dataVals);
			}
		}


		private function draggOff():void
		{
			areWeDragginAnything = false;
			dragginCursorOne = false;
			dragginCursorTwo = false;
			draggingSideBand = false;
			dragStartPoint = null;
		}


		private function doCursors(p:Point):void
		{
			if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Single || IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Sideband || (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Harmonic && IncheckModel.instance().functionMenuSelectionScope != "wave"))
			{
				nudgingCursorOne = true;
				_cursorOne = p;
			}
			else if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Double || (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Harmonic && IncheckModel.instance().functionMenuSelectionScope == "wave"))
			{
				if (_cursorOne == null)
				{
					_cursorOne = p;
				}
				else if (_cursorOne != null && _cursorTwo == null)
				{
					if (p.x > _cursorOne.x)
					{
						_cursorTwo = p;
					}
					else if (p.x < _cursorOne.x)
					{
						// left becomes right..
						_cursorTwo = _cursorOne;
						_cursorOne = p;
					}
					else
					{
						_cursorTwo = null;
					}
				}
				else if (_cursorOne != null && _cursorTwo != null)
				{
					if (_cursorOne.x > _cursorTwo.x)
					{
						var tempCursor:Point = _cursorOne;
						_cursorOne = _cursorTwo;
						_cursorTwo = tempCursor;
					}
				}
			}
		}


		private function endZoom(e:MouseEvent):void
		{
			_lastRatio = NaN;
		}


		private function updateTrackBounds(dataVals:Array):void
		{
			var hAxis:LinearAxis;
			var vAxis:LinearAxis;
			if (zoomType == "h")
			{
				dRight = Math.max(tX, dataVals[0]);
				dLeft = Math.min(tX, dataVals[0]);
				var mySeries:InCheckLineSeries = getSeries();
				var mydp:ArrayCollection = mySeries.dataProvider as ArrayCollection;
				var leftLimit:Number = mydp.getItemAt(0).x;
				var rightLimit:Number = mydp.getItemAt(mydp.length - 1).x;
				if (dLeft < leftLimit)
				{
					dLeft = leftLimit;
				}
				if (dRight > rightLimit)
				{
					dRight = rightLimit;
				}
				dBottom = Math.min(tY, dataVals[1]);
				dTop = Math.max(tY, dataVals[1]);
				if (areWeZooming == false)
				{
					//(IncheckModel.instance().right.dataViewChart.verticalAxis as LinearAxis).maximum=dTop;
					//(IncheckModel.instance().right.dataViewChart.verticalAxis as LinearAxis).minimum=dBottom;
					(IncheckModel.instance().right.scopeChart.horizontalAxis as LinearAxis).maximum = dRight;
					(IncheckModel.instance().right.scopeChart.horizontalAxis as LinearAxis).minimum = dLeft;
					dRight = 0;
					dLeft = 0;
					dBottom = 0;
					dTop = 0;
						//	ZoomTester.instance.ymax=dTop;
						//	ZoomTester.instance.ymin=dBottom;
						//	ZoomTester.instance.xmax=dLeft;
						//	ZoomTester.instance.ymin=dRight;
				}
			}
			else if (zoomType == "v")
			{
				hAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
				vAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.VERTICAL_AXIS));
//              var newMin:Number = _startMouseData[1] * (_unscaledHeightAtDragStart - _startOriginPixels.y) / (mouseY - _startOriginPixels.y);
//				trace ("_startMouseData[1] " + _startMouseData[1]);
//              var newMin:Number = _startMouseData[1] * (_unscaledHeightAtDragStart - _startMouseData[1]) / (mouseY - _startMouseData[1]);
//				trace ("_unscaledHeightAtDragStart " + _unscaledHeightAtDragStart);
//				trace(" _startMin.y " +  _startMin.y);
//              var ratio:Number = newMin / _startMin.y;
				var ratio:Number = (_startMousePointInPixels.y - _startOriginPixels.y) / (mouseY - _startOriginPixels.y);
				trace("_startMousePointInPixels.y " + _startMousePointInPixels.y);
				trace("_startOriginPixels.y " + _startOriginPixels.y);
				trace("mouseY " + mouseY);
				trace("ratio " + ratio)
				if (ratio > 0)
				{
					vAxis.maximum = ratio * _startMax.y;
					vAxis.minimum = ratio * _startMin.y;
					trace("vAxis.maximum " + vAxis.maximum)
					trace("vAxis.minimum " + vAxis.minimum)
				}
				invalidateDisplayList();

				/*
					var curTop:Number=(IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).maximum;
					var curBot:Number=(IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).minimum;
					var distanceMoved:Number=unscaledHeight/(pseudoMouseCursor.y-dragStartPoint.y);
					var currRangeShown:Number=curTop-curBot;
					var magnOfMovetoData:Number=unscaledHeight/curTop/currRangeShown;
					if(distanceMoved>0){

						// zooming in
						trace("in "+currRangeShown+"\t"+distanceMoved+"\t"+magnOfMovetoData+"\t"+unscaledHeight);
						(IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).maximum=curTop+(currRangeShown/distanceMoved);

					}else{
						// zooming out
						trace("in "+currRangeShown+"\t"+distanceMoved+"\t"+magnOfMovetoData"\t"+unscaledHeight);
						(IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).maximum=curTop+(currRangeShown/distanceMoved);

					} */
				invalidateDisplayList();

				/*  dBottom = Math.min(tY,dataVals[1]);
				 dTop = Math.max(tY,dataVals[1]);

				 var topLimit:Number=(chart as IncheckChart3).ymax
				 var botLimit:Number=(chart as IncheckChart3).ymin
				 if(dTop>topLimit){
					 dTop=topLimit;
				 }

				 if(dBottom<botLimit){
					 dBottom=botLimit;
				 }


				 if(areWeZooming==false){
					 (IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).maximum=dTop;
					 (IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).minimum=dBottom;

					 dRight=0
					 dLeft=0;
					 dBottom=0;
					 dTop=0


				 } */

			}
			else if (zoomType == "p")
			{
				bSet = false;
				hAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
				vAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.VERTICAL_AXIS));
				var dX:Number = mouseX - _startMousePointInPixels.x;
				var dY:Number = mouseY - _startMousePointInPixels.y;
				var proposedHMax:Number = _startMax.x - dX * _start1PixelOffset[0];
				var proposedHMin:Number = _startMin.x - dX * _start1PixelOffset[0];

				if (proposedHMax > IncheckModel.instance().right.scopeChart.xmax || proposedHMin < IncheckModel.instance().right.scopeChart.xmin)
				{
					return;
				}
				else
				{
					hAxis.maximum = proposedHMax;
					hAxis.minimum = proposedHMin
				}
				var proposedVMax:Number = _startMax.y - dY * _start1PixelOffset[1];
				var proposedVMin:Number = _startMin.y - dY * _start1PixelOffset[1];
				if (proposedVMax > IncheckModel.instance().right.scopeChart.ymax || proposedVMin < IncheckModel.instance().right.scopeChart.ymin)
				{
					//vAxis.maximum = IncheckModel.instance().right.scopeChart.ymax
					//vAxis.minimum =IncheckModel.instance().right.scopeChart.ymin
					return;
				}
				else
				{
					vAxis.maximum = proposedVMax;
					vAxis.minimum = proposedVMin;
				}
			}
			/* invalidate our data, and redraw */
			dataChanged();
			invalidateDisplayList();
			chart.invalidateDisplayList();
		}


		private function mouseUp(e:MouseEvent):void
		{
			if (!mouseIsDown)
			{
				return;
			}
			mouseIsDown = false;
			if (areWeDragginAnything)
			{
				draggOff();
				areWeDragginAnything = false;
				resetSearchStep();
			}
			else if (areWeZooming)
			{
				endZoom(e);
				areWeZooming = false;
				bSet = false;
				e.stopPropagation();
				if (zoomType == "v")
				{
					if (Math.abs(dragStartPoint.y - mouseY) > 20)
					{
						updateTrackBounds(dataTransform.invertTransform(mouseX, mouseY));
					}
					else
					{
						bSet = false;
					}
				}
				else if (zoomType == "h")
				{
					if (Math.abs(dragStartPoint.x - mouseX) > 20)
					{
						updateTrackBounds(dataTransform.invertTransform(mouseX, mouseY));
					}
					else
					{
						bSet = false;
					}
				}
				areWeZooming = false;
			}
			else
			{
				if ((IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Double || IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Harmonic && IncheckModel.instance().functionMenuSelectionScope == "wave") && _cursorOne != null && _cursorTwo != null)
				{
					var rightDis:Number = Math.abs(mouseX - _cursorTwo.x);
					var leftDis:Number = Math.abs(mouseX - _cursorOne.x);
					if (rightDis > leftDis)
					{
						_cursorOne = new Point(mouseX, mouseY);
						lastClickedCursor = 1;
						nudgingCursorOne = true;
					}
					else
					{
						_cursorTwo = new Point(mouseX, mouseY);
						lastClickedCursor = 2;
						nudgingCursorTwo = true;
					}
				}
				doCursors(new Point(mouseX, mouseY));
			}
			invalidateDisplayList();
		}


		private function mouseMove(e:MouseEvent):void
		{
			pseudoMouseCursor = new Point(mouseX, mouseY);
			if (areWeZooming)
			{
				updateTrackBounds(dataTransform.invertTransform(mouseX, mouseY));
				e.stopPropagation();
				invalidateDisplayList();
			}
			if (areWeDragginAnything)
			{
				_crosshairs = null;
				if (dragginCursorOne)
				{
					_cursorOne = pseudoMouseCursor;
				}
				else if (dragginCursorTwo)
				{
					_cursorTwo = pseudoMouseCursor;
				}
			}
			else
			{
				updateCrosshair(e);
			}
			invalidateDisplayList();
		}


		private function updateCrosshair(e:MouseEvent):void
		{
			_crosshairs = new Point(mouseX, mouseY);
			invalidateDisplayList();
		}


		private function removeCrosshair(e:MouseEvent):void
		{
			_crosshairs = null;
			invalidateDisplayList();
		}


		private function getSeries():InCheckLineSeries
		{
			if (IncheckModel.instance().selectedChannel)
			{
				return chart.series[chart.series.length - 1];
			}
			else
			{
				return chart.series[0];
			}
		}


		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var mySeries:InCheckLineSeries = getSeries();

			dataGridProvider.removeAll();
			xTit = ((chart as IncheckChartScope).horizontalAxis as LinearAxis).title
			yTit = ((chart as IncheckChartScope).verticalAxis as LinearAxis).title
			if (mySeries == null || mySeries.node == null)
			{
				return;
			}
			var g:Graphics = graphics;
			g.clear();
			// draw a big transparent square so the flash player sees us for mouse events
			g.moveTo(0, 0);
			g.lineStyle(0, 0, 0);
			g.beginFill(0, 0);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
			measure();
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var labs:UITextField = labelTextFields.pop();
			while (labs != null && parent.contains(labs))
			{
				try
				{
					parent.removeChild(labs);
				}
				catch (err:ArgumentError)
				{
				}
				labs = labelTextFields.pop();
			}
			if (bSet)
			{
				/* the selection is a data selection, so we want to make sure the region stays correct as the chart changes size and/or ranges.
				*  so we store it in data coordaintes. So before we draw it, we need to transform it back into screen coordaintes
				*/
				if (zoomType == "h")
				{
					var c:Array = [{dx:dLeft, dy:dTop}, {dx:dRight, dy:dBottom}];
					dataTransform.transformCache(c, "dx", "x", "dy", "y");

					/* now draw the region on screen */
					g.moveTo(c[0].x, c[0].y);
					g.beginFill(0xEEEE22, 0.3);
					g.lineStyle(1, 0xBBBB22);
					g.drawRect(c[0].x, 0, c[1].x - c[0].x, unscaledHeight);
					g.endFill();
				}
				/* else{
					 var c:Array = [{dx: dLeft, dy: dTop}, {dx:dRight, dy: dBottom}];
					dataTransform.transformCache(c,"dx","x","dy","y");


					g.moveTo(c[0].x,c[0].y);
					g.beginFill(0xEEEE22,0.3);

					g.lineStyle(1,0xBBBB22);

					g.drawRect(0,c[0].y,unscaledWidth, c[1].y - c[0].y);
					g.endFill();
				} */
			}

			var usingHandCursor:Boolean = false;
			var hAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
			var shouldBold:Boolean;

			if (_cursorOne != null && _cursorOne.x < 0)
			{
				_cursorOne.x = 0;
			}
			else if (_cursorOne != null && _cursorOne.x > unscaledWidth)
			{
				_cursorOne.x = unscaledWidth;
			}
			if (_cursorTwo != null && _cursorTwo.x < 0)
			{
				_cursorTwo.x = 0;
			}
			else if (_cursorTwo != null && _cursorTwo.x > unscaledWidth)
			{
				_cursorTwo.x = unscaledWidth;
			}
			if (_cursorOne != null)
			{
				shouldBold = false;
				if (Math.abs(_cursorOne.x - mouseX) < 4)
				{
					shouldBold = true;
					_crosshairs = null;
					usingHandCursor = true;
				}
				updateCursorOne(unscaledWidth, unscaledHeight, mySeries, shouldBold);
			}
			var mydp:ArrayCollection;
			var hStepCntr:Number;
			var lab2:UITextField;
			var reval:Array;
			var mydp1:ArrayCollection;
			var hitObj:Object;
			var colObj:Object;
			var exactPoint:Point;
			var movingCursorPosition:Number;

			if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Harmonic && _cursorOne != null)
			{
				if (IncheckModel.instance().functionMenuSelectionScope == "wave")
				{
					var prevIndex:int;
					if (_cursorTwo != null)
					{
						var stepSize:Number = _cursorTwo.x - _cursorOne.x;
						mydp = mySeries.dataProvider as ArrayCollection;
						hStepCntr = 3;
						movingCursorPosition = _cursorTwo.x + stepSize;
						//Alert.show("HERE" + movingCursorPosition+ " "+ stepSize +" "+unscaledWidth +" "+_cursorTwo.x +" "+_cursorOne.x);

						prevIndex = 0;

						while (movingCursorPosition < unscaledWidth && hStepCntr < IncheckModel.instance().right.scopeMenuBar.numOfExtraCursors.value + 1)
						{
							g.lineStyle(2, 0x005364, .5);
							g.moveTo(movingCursorPosition, 0);
							g.lineTo(movingCursorPosition, unscaledHeight);
							lab2 = new UITextField();
							lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
							lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
							lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
							lab2.x = movingCursorPosition;
							lab2.y = 0;
							reval = mySeries.localToData(new Point(movingCursorPosition, 0));
							mydp1 = mySeries.dataProvider as ArrayCollection;
							hitObj = null;
							while (prevIndex < mydp1.length)
								//for each (colObj in mydp1)
							{
								colObj = mydp1.getItemAt(prevIndex);
								if (colObj.x >= reval[0])
								{
									hitObj = colObj;
									break;
								}
								prevIndex++;
							}
							if (hitObj != null)
							{
								exactPoint = mySeries.dataToLocal(reval[0], reval[1]);
//								if (IncheckModel.instance().cursorMenuSelection == DataViewCursorTypes.Harmonic)
//								{
//									lab2.text = "\n" + hStepCntr + "\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
//								}
//								else
//								{
								lab2.text = "\n" + hStepCntr;
//								}
								dataGridProvider.addItem({num:hStepCntr, y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
							}
							parent.addChild(lab2);
							labelTextFields.push(lab2);
							movingCursorPosition += stepSize;
							hStepCntr++;
						}
					}
				}
				else
				{
					_cursorTwo = null;
					mydp1 = mySeries.dataProvider as ArrayCollection;
					var firstObj:Object = mydp1.getItemAt(0);
					var p:Point = mySeries.dataToLocal(firstObj.x);
					var harmonicStepSize:Number = _cursorOne.x - p.x;
					var currentPos:Number = _cursorOne.x + harmonicStepSize;

					hStepCntr = 2;
					prevIndex = 0;
					while (currentPos < unscaledWidth && hStepCntr < IncheckModel.instance().right.scopeMenuBar.numOfExtraCursors.value + 1)
					{
						g.lineStyle(2, 0x005364, .5);
						g.moveTo(currentPos, 0);
						g.lineTo(currentPos, unscaledHeight);
						lab2 = new UITextField();
						lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
						lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
						lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
						lab2.x = currentPos;
						lab2.y = 0;
						reval = mySeries.localToData(new Point(currentPos, 0));
						mydp1 = mySeries.dataProvider as ArrayCollection;
						hitObj = null;
						//for each (colObj in mydp1)
						while (prevIndex < mydp1.length)
						{
							colObj = mydp1.getItemAt(prevIndex);
							if (colObj.x >= reval[0])
							{
								hitObj = colObj;
								break;
							}
							prevIndex++;
						}
						if (hitObj != null)
						{
							exactPoint = mySeries.dataToLocal(reval[0], reval[1]);
//							if (IncheckModel.instance().cursorMenuSelection == DataViewCursorTypes.Harmonic)
//							{
//								lab2.text= "\n" + hStepCntr + "\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
//							}
//							else
//							{
							lab2.text = "\n" + hStepCntr;
//							}
							dataGridProvider.addItem({num:hStepCntr, y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
						}
						parent.addChild(lab2);
						labelTextFields.push(lab2);
						currentPos += harmonicStepSize;
						hStepCntr++;
					}
				}
			}
			else if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Sideband && _cursorOne != null)
			{
				if (areWeDragginAnything && draggingSideBand)
				{
					SideBanddStepSize = Math.abs(pseudoMouseCursor.x - _cursorOne.x);
						//trace(_cursorOne.x+"\t"+dragStartPoint.x+"\t"+SideBanddStepSize)
				}
				sideBandPoints = new Array();
				mydp = mySeries.dataProvider as ArrayCollection;
				hStepCntr = 1;
				movingCursorPosition = Math.abs(SideBanddStepSize);
				//Alert.show("HERE" + movingCursorPosition+ " "+ stepSize +" "+unscaledWidth +" "+_cursorTwo.x +" "+_cursorOne.x);
				while (hStepCntr * 2 < IncheckModel.instance().right.scopeMenuBar.numOfExtraCursors.value + 1)
				{
					g.lineStyle(2, 0x005364, .4);
					g.moveTo(_cursorOne.x + movingCursorPosition, 0);
					g.lineTo(_cursorOne.x + movingCursorPosition, unscaledHeight);
					sideBandPoints.push(_cursorOne.x + movingCursorPosition);
					lab2 = new UITextField();
					lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
					lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
					lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
					lab2.x = _cursorOne.x + movingCursorPosition;
					lab2.y = 0;
					reval = mySeries.localToData(new Point(_cursorOne.x + movingCursorPosition, 0));
					mydp1 = mySeries.dataProvider as ArrayCollection;
					hitObj = null;
					for each (colObj in mydp1)
					{
						if (colObj.x >= reval[0])
						{
							hitObj = colObj;
							break;
						}
					}
					if (hitObj != null)
					{
						exactPoint = mySeries.dataToLocal(reval[0], reval[1]);
//						lab2.text = "\n" + hStepCntr + "\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
						lab2.text = "\n" + hStepCntr;
						dataGridProvider.addItem({num:hStepCntr, y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
					}
					parent.addChild(lab2);
					labelTextFields.push(lab2);
					g.lineStyle(2, 0x005364, .4);
					g.moveTo(_cursorOne.x - movingCursorPosition, 0);
					g.lineTo(_cursorOne.x - movingCursorPosition, unscaledHeight);
					sideBandPoints.push(_cursorOne.x - movingCursorPosition);
					lab2 = new UITextField();
					lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
					lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
					lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
					lab2.x = _cursorOne.x - movingCursorPosition;
					lab2.y = 0;
					reval = mySeries.localToData(new Point(_cursorOne.x - movingCursorPosition, 0));
					mydp1 = mySeries.dataProvider as ArrayCollection;
					hitObj = null;
					for each (colObj in mydp1)
					{
						if (colObj.x >= reval[0])
						{
							hitObj = colObj;
							break;
						}
					}
					if (hitObj != null)
					{
						exactPoint = mySeries.dataToLocal(reval[0], reval[1]);
//						lab2.text = "\n" + hStepCntr + "\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
						lab2.text = "\n" + hStepCntr;
						dataGridProvider.addItem({num:hStepCntr, y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
					}
					parent.addChild(lab2);
					labelTextFields.push(lab2);
					movingCursorPosition += SideBanddStepSize;
					hStepCntr = hStepCntr + 1;
				}
				var sidePointCntr:uint = 0;
				for each (var sidePoint:Number in sideBandPoints)
				{
					if (Math.abs(sidePoint - mouseX) < 3)
					{
						_crosshairs = null;
						usingHandCursor = true;
					}
					if (sidePointCntr == 0)
					{
						break;
					}
					sidePointCntr++;
				}
			}
			else if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.PeakFinder)
			{
				mydp = mySeries.dataProvider as ArrayCollection;
				//var myCopy:Array=mydp.source.sortOn("y",Array.RETURNINDEXEDARRAY);
				//myCopy.sortOn("y",Array.NUMERIC );
				//myCopy.reverse();
				var sortedOnY:Array = mydp.source.sortOn("y", Array.RETURNINDEXEDARRAY | Array.NUMERIC | Array.DESCENDING);
				var peaksFound:uint = 0;
				var peakIndex:Number = 0;
				var peakList:Array = new Array();
				while (peaksFound < IncheckModel.instance().right.scopeMenuBar.numOfExtraCursors.value)
				{
					var myTuple:Array = new Array();
					myTuple[0] = mydp[sortedOnY[peakIndex]].x
					myTuple[1] = 0;
					trace("my tuple=" + myTuple.toString());
					var myPoint:Point = mySeries.dataToLocal(myTuple);
					trace("myPoint=" + myPoint.toString());
					peakIndex++;
					var shouldSkipPeak:Boolean = false;
					for each (var alreadyfoundPeaks:Number in peakList)
					{
						if (Math.abs(alreadyfoundPeaks - myPoint.x) < 5)
						{
							shouldSkipPeak = true;
							break;
						}
					}
					if (shouldSkipPeak)
					{
						continue;
					}
					peakList.push(myPoint.x);
					peaksFound++;
					g.lineStyle(2, 0x005364, .5);
					g.moveTo(myPoint.x, 0);
					g.lineTo(myPoint.x, unscaledHeight);
					lab2 = new UITextField();
					lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
					lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
					lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
					lab2.text = "\n" + peaksFound;
					lab2.x = myPoint.x;
					lab2.y = 0;
					parent.addChild(lab2);
					labelTextFields.push(lab2);
					dataGridProvider.addItem({num:peaksFound, y:toScientific(mydp[sortedOnY[peakIndex - 1]].y), x:toScientific(mydp[sortedOnY[peakIndex - 1]].x)});
				}
			}
			if (_cursorTwo != null)
			{
				shouldBold = false;
				if (Math.abs(_cursorTwo.x - mouseX) < 4)
				{
					shouldBold = true;
					_crosshairs = null;
					usingHandCursor = true;
				}
				updateCursorTwo(unscaledWidth, unscaledHeight, mySeries, shouldBold);
			}
			if (usingHandCursor)
			{
				CursorManager.setCursor(Cursor1);
			}
			else
			{
				CursorManager.removeAllCursors();
			}
			if (_crosshairs != null)
			{
				updateMovingCursor(unscaledWidth, unscaledHeight, mySeries);
			}
			invalidateDisplayList();
			//IncheckModel.instance().right.updateCursorValues(dataGridProvider, xTit, yTit);
			var ev:AnalysisTabEvent = new AnalysisTabEvent(AnalysisTabEvent.CURSOR_VALUES_UPDATED);
			ev.cursorValues = dataGridProvider;
			ev.xTitle = xTit;
			ev.yTitle = yTit;
			dispatchEvent(ev);
		}


		private function updateMovingCursor(unscaledWidth:Number, unscaledHeight:Number, mySeries:InCheckLineSeries):void
		{
			var g:Graphics = graphics;
			g.lineStyle(1, 0x005364, .5);
			g.moveTo(_crosshairs.x, 0);
			g.lineTo(_crosshairs.x, unscaledHeight);
			g.lineStyle(2, 0x005364, .5);
			var lab2:UITextField = new UITextField();
			lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			lab2.width = 400;
			var reval:Array = mySeries.localToData(_crosshairs);
			var mydp:ArrayCollection = mySeries.dataProvider as ArrayCollection;
			var hitObj:Object = null;
			for each (var colObj:Object in mydp)
			{
				if (colObj.x >= reval[0])
				{
					hitObj = colObj;
					break;
				}
			}
			if (hitObj != null)
			{
				lab2.text = toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
			}
			else
			{
				lab2.text = mySeries.node.channelid + " " + _crosshairs.x + " " + _crosshairs.y + " " + unscaledWidth;
			}
			lab2.x = _crosshairs.x;
			lab2.y = 0;
			parent.addChild(lab2);
			labelTextFields.push(lab2);
			invalidateDisplayList();
		}


		private function updateCursorOne(unscaledWidth:Number, unscaledHeight:Number, mySeries:InCheckLineSeries, shouldBold:Boolean):void
		{
			var g:Graphics = graphics;
			var lab2:UITextField = new UITextField();
			lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			lab2.width = 600;
			//var myobj2:Array=mySeries.findDataPoints(_cursorOne.x,_cursorOne.y,unscaledHeight);
			if (_cursorOneObj != null && (zoomType == "p" || zoomType == "h" || zoomType == "v") && !dragginCursorOne && !nudgingCursorOne)
			{
				// cursorOne is already defined and we are changing the graph by panning or zooming, so cursorOne needs to be redrawn with the same data coordinates, but new screen coordinates
				_cursorOne = mySeries.dataToLocal(_cursorOneObj.exactDataX, _cursorOneObj.exactDataY);
			}
			if (nudgingCursorOne)
			{
				nudgingCursorOne = false;
			}
			var reval:Array = mySeries.localToData(_cursorOne);
			var mydp:ArrayCollection = mySeries.dataProvider as ArrayCollection;
			var hitObj:Object = null;
			for each (var colObj:Object in mydp)
			{
				if (colObj.x >= reval[0])
				{
					hitObj = colObj;
					break;
				}
			}
			if (hitObj != null)
			{
				_cursorOneObj = hitObj;
				_cursorOneObj.exactDataX = reval[0]; // we need to save the localToData point for later when panning or zooming
				_cursorOneObj.exactDataY = reval[1];
				if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Harmonic || IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Double)
				{
//					lab2.text = "\n1\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
					dataGridProvider.addItem({num:"1", y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
					lab2.text = "\n1";
				}
				else if (IncheckModel.instance().cursorMenuSelectionScope == DataViewCursorTypes.Single)
				{
					lab2.text = "\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
				}
				else
				{
					dataGridProvider.addItem({num:"", y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
				}
			}
			lab2.x = _cursorOne.x;
			lab2.y = 0;
			if (shouldBold)
			{
				g.lineStyle(4, 0x005364, .7);
			}
			else
			{
				g.lineStyle(2, 0x005364, .5);
			}
			g.moveTo(_cursorOne.x, 0);
			g.lineTo(_cursorOne.x, unscaledHeight);
			parent.addChild(lab2);
			labelTextFields.push(lab2);
			if (_cursorOne.x + lab2.textWidth > unscaledWidth)
			{
				// move label to lefthand side if necessary
				lab2.x = _cursorOne.x - (lab2.textWidth + 5);
			}
		}


		private function updateCursorTwo(unscaledWidth:Number, unscaledHeight:Number, mySeries:InCheckLineSeries, shouldBold:Boolean):void
		{
			var g:Graphics = graphics;
			var lab2:UITextField = new UITextField();
			lab2.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			lab2.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			lab2.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			lab2.width = 600;
			//var myobj2:Array=mySeries.findDataPoints(_cursorOne.x,_cursorOne.y,unscaledHeight);
			if (_cursorTwoObj != null && (zoomType == "p" || zoomType == "h" || zoomType == "v") && !dragginCursorTwo && !nudgingCursorTwo)
			{
				// cursorTwo is already defined and we are changing the graph by panning or zooming, so cursorTwo needs to be redrawn with the same data coordinates, but new screen coordinates
				_cursorTwo = mySeries.dataToLocal(_cursorTwoObj.exactDataX, _cursorTwoObj.exactDataY);
			}
			if (nudgingCursorTwo)
			{
				nudgingCursorTwo = false;
			}
			var reval:Array = mySeries.localToData(_cursorTwo);
			var mydp:ArrayCollection = mySeries.dataProvider as ArrayCollection;
			var hitObj:Object = null;
			for each (var colObj:Object in mydp)
			{
				if (colObj.x >= reval[0])
				{
					hitObj = colObj;
					break;
				}
			}
			if (hitObj != null)
			{
				var exactPoint:Point = mySeries.dataToLocal(reval[0], reval[1]);
				_cursorTwoObj = hitObj;
				_cursorTwoObj.exactDataX = reval[0]; // we need to save the localToData point for later when panning or zooming
				_cursorTwoObj.exactDataY = reval[1];
				_cursorTwo = exactPoint;
				if (_cursorOneObj != null)
				{
					//lab2.text=hitObj.x+"\nΔ"+(hitObj.x-_cursorOneObj.x)+" "+exactPoint.x+" by "+exactPoint.y +" for "+hitObj.x+" "+hitObj.y;
//            		lab2.text= "\nΔ" + toScientific((_cursorTwoObj.x - _cursorOneObj.x)) + " " + yTit + "\n" + toScientific(_cursorTwoObj.x) + " " + xTit;
					lab2.text = "\n2"
					dataGridProvider.addItem({num:"2", y:toScientific(_cursorTwoObj.y), x:toScientific(_cursorTwoObj.x)});
					dataGridProvider.addItem({num:"Δ", x:toScientific(_cursorTwoObj.x - _cursorOneObj.x), y:""});
				}
				else
				{
					//lab2.text= "\n" + numFormat.format(hitObj.y) + " " + yTit + "\n" + numFormat.format(hitObj.x) + " " + xTit;
//					lab2.text= "\n" + toScientific(hitObj.y) + " " + yTit + "\n" + toScientific(hitObj.x) + " " + xTit;
					dataGridProvider.addItem({num:"2", y:toScientific(hitObj.y), x:toScientific(hitObj.x)});
				}
			}
			lab2.x = _cursorTwo.x;
			lab2.y = 0;
			if (shouldBold)
			{
				g.lineStyle(4, 0x005364, .7);
			}
			else
			{
				g.lineStyle(2, 0x005364, .5);
			}
			g.moveTo(_cursorTwo.x, 0);
			g.lineTo(_cursorTwo.x, unscaledHeight);
			parent.addChild(lab2);
			labelTextFields.push(lab2);
			if (_cursorTwo.x + lab2.textWidth > unscaledWidth)
			{
				// move label to lefthand side if necessary
				lab2.x = _cursorTwo.x - (lab2.textWidth + 5);
			}
		}


		public function sortOnY(a:Object, b:Object):int
		{
			if (a.y as Number < b.y as Number)
			{
				trace("" + (a.y as Number) + " >  " + (b.y as Number) + " a.y as Number > b.y as Number");
				return -1;
			}
			else if (a.y as Number > b.y as Number)
			{
				trace("" + (a.y as Number) + " <  " + (b.y as Number) + " a.y as Number > b.y as Number");
				return 1;
			}
			else
			{
				trace(a.y + " == " + b.y)
				return 0;
			}
		}


		public static function toScientific(num:Number):String
		{

			//return this.numFormat.format(num);

			if (isNaN(num))
				return String(num);

			if (num >= 1000)
			{
				return String(Math.round(num));
			}

			var exponent:Number = Math.floor(Math.log(Math.abs(num)) / Math.LN10);
			if (num == 0)
				exponent = 0;

			if (exponent >= 0)
			{
				if (exponent < IncheckModel.instance().getSNThreshold())
				{
					exponent = 0;
				}
			}
			else
			{
				if (-exponent < IncheckModel.instance().getSNThreshold())
				{
					exponent = 0;
				}
			}

			var tenToPower:Number = Math.pow(10, exponent);
			var mantissa:Number = num / tenToPower;

			var output:String = formatDecimals(mantissa, IncheckModel.instance().getDisplayedPrecision());

			if (exponent != 0)
			{
				output += " e" + exponent;
			}
			return (output);
		}


		private static function formatDecimals(num:Number, digits:int):String
		{
			if (digits <= 0)
			{
				return String(Math.round(num));
			}
			var tenToPower:Number = Math.pow(10, digits);
			var cropped:String = String(Math.round(num * tenToPower) / tenToPower);

//			if (cropped.indexOf(".") == -1) {
//				cropped += ".0";
//			}

			//				var halves = cropped.split("."); 
			//				
			//				var zerosNeeded = digits - halves[1].length; 
			//				for (var i=1; i <= zerosNeeded; i++) {
			//					cropped += "0";
			//				}
			return (cropped);
		}


	/*

		 private var _startMin:Point;
			private var _startMax:Point;
			private var _startMouseData:Array;
			private var _start1PixelOffset:Array;
			private var _startOriginPixels:Point;
			private var _startMousePointInPixels:Point;
			private var _dragTool:String;
			private var _isZoomOrPanEnabled:Boolean=false;
			private var _chartTypeNow:String;
			private var _lastRatio:Number=NaN;
			private var _unscaledHeightAtDragStart:Number;
		 ;


		private var labelTextFields:Array=new Array();
		private var numFormat:NumberFormatter =new NumberFormatter();
			the bounds of the selected region
			private var dLeft:Number = 20;
			private var dTop:Number = 20;
			private var dRight:Number = 80;
			private var dBottom:Number = 80;

			the x/y coordinates of the start of the tracking region
			private var tX:Number;
			private var tY:Number;


			private var mouseStartX:Number;
			private var mouseStartY:Number;
			 whether or not a region is selected
			private var bSet:Boolean = false;

			 whether or not we're currently tracking
			private var bTracking:Boolean = false;

			the current position of the crosshairs
			private var _crosshairs:Point;
			private var _cursorOne:Point;
			private var _cursorTwo:Point;

			private var _cursorOneObj:Object;
			private var _cursorTwoObj:Object;
			private var _crosshairLabel:UITextField;
			private var _cursorsOneNeedRedrawing:Boolean=false;
			private var _cursorsTwoNeedRedrawing:Boolean=false;
			private var KeyIsDown:Boolean=false;

			 the four labels for the data bounds of the selected region
	//        private var _labelLeft:Label;
	//       private var _labelRight:Label;
	//        private var _labelTop:Label;
	//        private var _labelBottom:Label;

			 constructor
			public function RangeSelector():void
			{
				super();


				setStyle("color",0);
				   numFormat.precision=2;
				numFormat.rounding="up"

				BindingUtils.bindSetter(functionTypeChanged,IncheckModel.instance(),"functionMenuSelection");
				BindingUtils.bindSetter(chartTypeChanged,IncheckModel.instance(),"graphMenuSelection");
				BindingUtils.bindSetter(cursorTypeChanged,IncheckModel.instance(),"cursorMenuSelection");
				FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
				FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN,keyDePressed);

				 _chartTypeNow=IncheckModel.instance().graphMenuSelection;
				addEventListener("mouseMove",updateCrosshairs);
				addEventListener("rollOut",removeCrosshairs);
				addEventListener(MouseEvent.CLICK,chartClicked);


				 create our labels
				_labelLeft = new Label();
				_labelTop = new Label();
				_labelRight = new Label();
				_labelBottom = new Label();


				addChild(_labelLeft);
				addChild(_labelTop);
				addChild(_labelRight);
				addChild(_labelBottom);




			}


			private function chartTypeChanged(str:String):void{
				if((_chartTypeNow=="accel" && str=="velo") || (_chartTypeNow=="velo" && str=="accel")){
					//do nothing

				}else{

					_cursorOne=null;
					_cursorOneObj=null;
					_cursorTwo=null;
					_cursorTwoObj=null;


				}
				_chartTypeNow=str;
				invalidateDisplayList();
			}

		   private function functionTypeChanged(str:String):void{
					_cursorOne=null;
					_cursorOneObj=null;
					_cursorTwo=null;
					_cursorTwoObj=null;


				invalidateDisplayList();
			}


		   private function cursorTypeChanged(str:String):void{
					_cursorOne=null;
					_cursorOneObj=null;
					_cursorTwo=null;
					_cursorTwoObj=null;

				invalidateDisplayList();
			}

			private function updateCrosshairs(e:MouseEvent):void
			{
				 the mouse moved over the chart, so grab the mouse coordaintes and redraw
				_crosshairs = new Point(mouseX,mouseY);
				invalidateDisplayList();
			}
			private function removeCrosshairs(e:MouseEvent):void
			{
				 the mouse left the chart area, so throw away any stored coordinates and redraw
				_crosshairs = null;
				invalidateDisplayList();
			}

		   public function keyDePressed(ev:KeyboardEvent):void{

				KeyIsDown=false;


			}

			public function moveCursorBy(step:Number,speed:Number):void{
				if(KeyIsDown){

					if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Harmonic ){
					if(_cursorOne.x>unscaledWidth*.025 ){
						_cursorOne=new Point(_cursorOne.x+step+(speed*(step/1)),_cursorOne.y)
							setTimeout(moveCursorBy,300,step+speed*(step/1),(speed+5));
							invalidateDisplayList();
					}else{
						if(step>0){
							_cursorOne=new Point(_cursorOne.x+step+(speed*(step/1)),_cursorOne.y)
								setTimeout(moveCursorBy,300,step+speed*(step/1),(speed+5));
								invalidateDisplayList();
						}

					}
				}else{
					_cursorOne=new Point(_cursorOne.x+step+(speed*(step/1)),_cursorOne.y)
						setTimeout(moveCursorBy,300,step+speed*(step/1),(speed+5));
						invalidateDisplayList();
				}

				}

			}
			public function keyPressed(ev:KeyboardEvent):void{



				if(_cursorOne!=null){
					KeyIsDown=true;

						if(ev.keyCode==37){

							moveCursorBy(-1,1);

						}else if(ev.keyCode==39){
							moveCursorBy(1,1)

						}


				}
			}

			 private function chartClicked(e:MouseEvent):void{



			  if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Disabled){
				return;
			  }else if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Single || IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Harmonic){
				if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Harmonic ){
					if(mouseX>unscaledWidth*.025){
						_cursorOne=new Point(mouseX,mouseY);
						_cursorsOneNeedRedrawing=true;
					}
				}else{
					_cursorOne=new Point(mouseX,mouseY);
					_cursorsOneNeedRedrawing=true;
				}

			  }else if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Double){
				if(_cursorOne==null){
					_cursorOne=new Point(mouseX,mouseY);
					_cursorsOneNeedRedrawing=true;
				}else if(_cursorOne!=null && _cursorTwo==null){

					if(mouseX>_cursorOne.x){

							_cursorTwo=new Point(mouseX,mouseY);
							_cursorsTwoNeedRedrawing=true;
						}else if(mouseX<_cursorOne.x){
							// left becomes right..
							_cursorTwo=_cursorOne;
							_cursorsTwoNeedRedrawing=true;
							_cursorOne=new Point(mouseX,mouseY);
							_cursorsOneNeedRedrawing=true;


						}else{
							_cursorTwo=new Point(mouseX+1,mouseY);
							_cursorsTwoNeedRedrawing=true;
						}



				}else{




					// which is closer?

					var rightDis:Number=Math.abs(mouseX-_cursorTwo.x);
						var leftDis:Number=Math.abs(mouseX-_cursorOne.x);
						if(rightDis>leftDis){
							_cursorOne=new Point(mouseX,mouseY);
							_cursorsOneNeedRedrawing=true;

						}else{
							_cursorTwo=new Point(mouseX,mouseY);
							_cursorsTwoNeedRedrawing=true;
						}
				}
			  }


			  invalidateDisplayList();

			 }




			private function updateMovingCursor(unscaledWidth:Number,
													   unscaledHeight:Number,mySeries:InCheckLineSeries):void{

					var g:Graphics = graphics;
				   g.lineStyle(1,0x005364,.5);

					g.moveTo(_crosshairs.x,0);
					g.lineTo(_crosshairs.x,unscaledHeight);
					g.lineStyle(2,0x005364,.5);


					var lab2:UITextField=new UITextField();
					lab2.width=400
					var reval:Array=mySeries.localToData(_crosshairs);
					var mydp:ArrayCollection=mySeries.dataProvider as ArrayCollection;
					var hitObj:Object=null;
					for each(var colObj:Object in mydp){
						if(colObj.x>reval[0]){
							hitObj=colObj;
							break;
						}

					}
					 if(hitObj!=null ){

						lab2.text=hitObj.x

					}else{
						lab2.text=mySeries.node.channelid +" "+_crosshairs.x +" "+_crosshairs.y+" "+unscaledWidth;
					}
					lab2.x=_crosshairs.x;
					lab2.y=0;
					parent.addChild(lab2);
					labelTextFields.push(lab2);
					invalidateDisplayList();

			}


			private function updateLeftCursor(unscaledWidth:Number,
													   unscaledHeight:Number,mySeries:InCheckLineSeries):void{

				   var g:Graphics = graphics;
					var lab2:UITextField=new UITextField();
					lab2.width=600
					//var myobj2:Array=mySeries.findDataPoints(_cursorOne.x,_cursorOne.y,unscaledHeight);
					var reval:Array=mySeries.localToData(_cursorOne);
					var mydp:ArrayCollection=mySeries.dataProvider as ArrayCollection;
					var hitObj:Object=null;
					for each(var colObj:Object in mydp){
						if(colObj.x>reval[0]){
							hitObj=colObj;
							break;
						}

					}
					 if(hitObj!=null ){
					  var exactPoint:Point=mySeries.dataToLocal(reval[0],reval[1]);
					  if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Harmonic){
							lab2.text="\n1\n"+hitObj.x
						}else{
							lab2.text="\n"+hitObj.x
						}
						_cursorOne=exactPoint;
						_cursorOneObj=hitObj;
					}else{
						lab2.text="\n"+mySeries.node.channelid +" "+_cursorOne.x +" "+_cursorOne.y+" "+unscaledWidth;
					}
					lab2.x=_cursorOne.x;
					lab2.y=0;
					g.lineStyle(2,0x005364,.5);
					g.moveTo(_cursorOne.x,0);
					g.lineTo(_cursorOne.x,unscaledHeight);
					g.lineStyle(2,0x005364,.5);
					parent.addChild(lab2);
					labelTextFields.push(lab2);
			}





			private function updateRightCursor(unscaledWidth:Number,
													   unscaledHeight:Number,mySeries:InCheckLineSeries):void{

				   var g:Graphics = graphics;
					var lab2:UITextField=new UITextField();
					lab2.width=600


					if(_cursorsTwoNeedRedrawing){
						var reval:Array=mySeries.localToData(_cursorTwo);
						var mydp:ArrayCollection=mySeries.dataProvider as ArrayCollection;
						var hitObj:Object=null;
						for each(var colObj:Object in mydp){
							if(colObj.x>reval[0]){
								hitObj=colObj;
								break;
							}

						}
						 if(hitObj!=null ){
						  var exactPoint:Point=mySeries.dataToLocal(hitObj.x,hitObj.y);
							_cursorTwo=exactPoint;
							_cursorTwoObj=hitObj;
							if(_cursorOneObj!=null){
								//lab2.text=hitObj.x+"\nΔ"+(hitObj.x-_cursorOneObj.x)+" "+exactPoint.x+" by "+exactPoint.y +" for "+hitObj.x+" "+hitObj.y;
								lab2.text="\n"+_cursorTwoObj.x+"\nΔ"+(_cursorTwoObj.x-_cursorOneObj.x);
							}else{
								lab2.text="\n"+hitObj.x
							}

						}else{
							lab2.text="\n"+mySeries.node.channelid +" "+_cursorTwo.x +" "+_cursorTwo.y+" "+unscaledWidth;
						}
						_cursorsTwoNeedRedrawing=false;
					}else{
						lab2.text="\n"+_cursorTwoObj.x+"\nΔ"+(_cursorTwoObj.x-_cursorOneObj.x);
					}
					lab2.x=_cursorTwo.x;
					lab2.y=0;
					g.lineStyle(2,0x005364,.5);
					g.moveTo(_cursorTwo.x,0);
					g.lineTo(_cursorTwo.x,unscaledHeight);
					g.lineStyle(2,0x005364,.5);
					parent.addChild(lab2);
					labelTextFields.push(lab2);
			}


			private function startZoom(e:MouseEvent):void{
				if(e.ctrlKey){
					_dragTool="zoom"
					startPanAndZoom(e);
				}else if(e.shiftKey)
				{
					_dragTool="pan";
					startPanAndZoom(e);

				}else{
					startTracking(e);
				}

			}

			override protected function updateDisplayList(unscaledWidth:Number,
													   unscaledHeight:Number):void
			{

	measure();
				super.updateDisplayList(unscaledWidth, unscaledHeight);



				var g:Graphics = graphics;
				g.clear();
	 draw the selected region, if there is one
				if(bSet)
				{

					var c:Array = [{dx: dLeft, dy: dTop}, {dx:dRight, dy: dBottom}];
					dataTransform.transformCache(c,"dx","x","dy","y");

					 now draw the region on screen
					g.moveTo(c[0].x,c[0].y);
					g.beginFill(0xEEEE22,0.3);

					g.lineStyle(1,0xBBBB22);

					g.drawRect(c[0].x,0,c[1].x - c[0].x, unscaledHeight);
					g.endFill();

				}
				var mySeries:InCheckLineSeries=chart.series[0];

				if(mySeries==null || mySeries.node==null){
					return;
				}

				var labs:UITextField=labelTextFields.pop();
				while(labs!=null && parent.contains(labs)){
					try{
						parent.removeChild(labs);
				  }catch(err:ArgumentError){}
					labs=labelTextFields.pop();
				}

				// draw a big transparent square so the flash player sees us for mouse events
				g.moveTo(0,0);
				g.lineStyle(0,0,0);
				g.beginFill(0,0);
				g.drawRect(0,0,unscaledWidth,unscaledHeight);
				g.endFill();


				if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Zoom ||IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Pan ){
					if(_isZoomOrPanEnabled==false){
						removeEventListener("mouseMove",updateCrosshairs);
						removeEventListener("rollOut",removeCrosshairs);
						removeEventListener(MouseEvent.CLICK,chartClicked);



						addEventListener(MouseEvent.MOUSE_DOWN,startZoom);

						//addEventListener("mouseDown",startTracking);

						_isZoomOrPanEnabled=true;
						return;
					}
				}else{
					if(_isZoomOrPanEnabled==true){
						addEventListener("mouseMove",updateCrosshairs);
						addEventListener("rollOut",removeCrosshairs);
						addEventListener(MouseEvent.CLICK,chartClicked);



						removeEventListener(MouseEvent.MOUSE_DOWN,startZoom);

						_isZoomOrPanEnabled=false;
						return;
					}
				}

				if(_cursorOne!=null){

					updateLeftCursor(unscaledWidth,unscaledHeight,mySeries);


				}


				if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Harmonic && _cursorOne!=null ){

					_cursorTwo=null;

					var currentPos:Number=_cursorOne.x*2;

				   var mydp:ArrayCollection=mySeries.dataProvider as ArrayCollection;


				   var hStepCntr:Number=2;




					while(currentPos<unscaledWidth){


						g.lineStyle(2,0x005364,.5);
						g.moveTo(currentPos,0);
						g.lineTo(currentPos,unscaledHeight);

						var lab2:UITextField=new UITextField();
						lab2.x=currentPos
						lab2.y=0;



						var reval:Array=mySeries.localToData(new Point(currentPos,0));
						var mydp1:ArrayCollection=mySeries.dataProvider as ArrayCollection;
					  var hitObj:Object=null;
						for each(var colObj:Object in mydp1){
							if(colObj.x>reval[0]){
								hitObj=colObj;
								break;
							}

						}
						 if(hitObj!=null ){
						  var exactPoint:Point=mySeries.dataToLocal(reval[0],reval[1]);
						  if(IncheckModel.instance().cursorMenuSelection==DataViewCursorTypes.Harmonic ){
								lab2.text="\n"+hStepCntr+"\n"+hitObj.x
							}else{
								lab2.text="\n"+hStepCntr;
							}
						}




						parent.addChild(lab2);
						labelTextFields.push(lab2);
						currentPos+=_cursorOne.x;
						hStepCntr++;

					}

				}


				if(_cursorTwo!=null){

					updateRightCursor(unscaledWidth,unscaledHeight,mySeries);


				}



				if(_crosshairs != null)
				{


					updateMovingCursor(unscaledWidth,unscaledHeight,mySeries);
				}

			}


				private function startPanAndZoom(e:MouseEvent):void
			{
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE,panAndZoom,true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP,endPanAndZoom,true);
				systemManager.addEventListener("rollOut",endPanAndZoom);

				var hAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
				var vAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.VERTICAL_AXIS));
				_startMin = new Point(hAxis.minimum,vAxis.minimum);
				_startMax = new Point(hAxis.maximum,vAxis.maximum);

				_startMousePointInPixels = new Point(mouseX,mouseY);
				_startMouseData = dataTransform.invertTransform(mouseX,mouseY);
				_start1PixelOffset = dataTransform.invertTransform(mouseX+1,mouseY+1);
				_start1PixelOffset[0] -= _startMouseData[0];
				_start1PixelOffset[1] -= _startMouseData[1];

				var cache:Array = [ {xV:0,yV:0} ];
				dataTransform.transformCache(cache,"xV","x","yV","y");
				_startOriginPixels = new Point(cache[0].x,cache[0].y);
				cache[0].xV = 1;
				cache[0].yV = 1;

				_unscaledHeightAtDragStart=unscaledHeight;



			}

			private function panAndZoom(e:MouseEvent):void
			{
				var hAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.HORIZONTAL_AXIS));
				var vAxis:LinearAxis = LinearAxis(CartesianTransform(dataTransform).getAxis(CartesianTransform.VERTICAL_AXIS));

				if(_dragTool == "pan")
				{
					var dX:Number = mouseX - _startMousePointInPixels.x;
					var dY:Number = mouseY - _startMousePointInPixels.y;

					vAxis.maximum = _startMax.y - dY * _start1PixelOffset[1];
					if(IncheckModel.instance().functionMenuSelection=="spec"){
						 vAxis.minimum =0;
					}else{
						vAxis.minimum = _startMin.y - dY * _start1PixelOffset[1];
					}


					var proposedHMax:Number=_startMax.x - dX * _start1PixelOffset[0];
					var proposedHMin:Number=_startMin.x - dX * _start1PixelOffset[0];
					if(proposedHMax>IncheckModel.instance().right.scopeChart.xmax){
						hAxis.maximum =IncheckModel.instance().right.scopeChart.xmax
						return;
					}

					if(proposedHMin<IncheckModel.instance().right.scopeChart.xmin){
						proposedHMin=IncheckModel.instance().right.scopeChart.xmin
						hAxis.minimum = proposedHMin
						return;
					}
					hAxis.maximum = proposedHMax;
					hAxis.minimum = proposedHMin



				}
				else
				{
					//var newMax:Number = _startMouseData[0] * (unscaledWidth - _startOriginPixels.x) / (mouseX - _startOriginPixels.x);
					//var ratio:Number = newMax/_startMax.x;


					var newMin:Number = _startMouseData[1] * (_unscaledHeightAtDragStart - _startOriginPixels.y) / (mouseY - _startOriginPixels.y);
					var ratio:Number = newMin/_startMin.y;

					trace("ratio="+ratio+"\t"+
					"newMin="+newMin+"\t"+
					"_startMouseData[1]="+_startMouseData[1]+"\t"+
					"_startOriginPixels.y="+_startOriginPixels.y+"\t"+
					"mouseY="+mouseY+"\t"+
					"_unscaledHeightAtDragStart="+_unscaledHeightAtDragStart+"\t"+
					"_startMax.y="+_startMax.y+"\t"+
					"_startMin.y="+_startMin.y+"\t"



					);

					if(ratio > 0)
					{

						vAxis.maximum = ratio * _startMax.y;
						vAxis.minimum = ratio * _startMin.y;
					}
				}

	//            e.stopPropagation();
			}
			private function endPanAndZoom(e:MouseEvent):void
			{
	//            e.stopPropagation();

				systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,panAndZoom,true);
				systemManager.removeEventListener(MouseEvent.MOUSE_UP,endPanAndZoom,true);
				systemManager.removeEventListener("rollOut",endPanAndZoom);
				_dragTool= null;
				_lastRatio=NaN;
			}



			private function startTracking(e:MouseEvent) :void
			{
				 the user clicked the mouse down. First, we need to add listeners for the mouse dragging
	//            Alert.show(pare);
				bTracking = true;

				FlexGlobals.topLevelApplication.addEventListener("mouseUp",endTracking,true);

				FlexGlobals.topLevelApplication.addEventListener("mouseMove",track,true);

				mouseStartX=mouseX;
				mouseStartY=mouseY;

				now store off the data values where the user clicked the mouse
				var dataVals:Array = dataTransform.invertTransform(mouseX,mouseY);
				tX = dataVals[0];
				tY = dataVals[1];
				bSet = false;

				updateTrackBounds(dataVals);
			}

			private function track(e:MouseEvent):void {
				if(bTracking == false){
					return;
				}
				bSet = true;
				updateTrackBounds(dataTransform.invertTransform(mouseX,mouseY));
				e.stopPropagation();
			}

			private function endTracking(e:MouseEvent):void
			{

				var g:Graphics = graphics;
				g.clear();


			   bTracking = false;
				FlexGlobals.topLevelApplication.removeEventListener("mouseUp",endTracking,true);
				FlexGlobals.topLevelApplication.removeEventListener("mouseMove",track,true);

				e.stopPropagation();
				//if(Math.abs(mouseStartX-mouseX) > 20){

				 if(Math.abs(mouseStartX-mouseX) > 20){
				   updateTrackBounds(dataTransform.invertTransform(mouseX,mouseY));
				}else{
					bSet=false;
				}
				invalidateDisplayList();




			}
			private function updateTrackBounds(dataVals:Array):void
			{
				 store the bounding rectangle of the selection, in a normalized data-based rectangle
				dRight = Math.max(tX,dataVals[0]);
				dLeft = Math.min(tX,dataVals[0]);
				dBottom = Math.min(tY,dataVals[1]);
				dTop = Math.max(tY,dataVals[1]);
				if(bTracking==false){
					//(IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).maximum=dTop;
					//(IncheckModel.instance().right.scopeChart.verticalAxis as LinearAxis).minimum=dBottom;
					(IncheckModel.instance().right.scopeChart.horizontalAxis as LinearAxis).maximum=dRight;
					(IncheckModel.instance().right.scopeChart.horizontalAxis as LinearAxis).minimum=dLeft;
					dRight=0
					dLeft=0;
					dBottom=0;
					dTop=0

	//				ZoomTester.instance.ymax=dTop;
	//				ZoomTester.instance.ymin=dBottom;
	//				ZoomTester.instance.xmax=dLeft;
	//				ZoomTester.instance.ymin=dRight;

				}
				 invalidate our data, and redraw
				dataChanged();
				invalidateProperties();
				invalidateDisplayList();

			}
	*/

	}
}

