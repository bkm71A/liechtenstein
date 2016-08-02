package com.incheck
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.incheck.common.DataViewCursorTypes;
	import com.incheck.common.DataViewScalingTypes;
	import com.incheck.common.DataViewZoom;
	import com.incheck.common.DeviceEvent;
	import com.incheck.common.DeviceEventsGroup;
	import com.incheck.common.ICNode;
	import com.incheck.common.Logger;
	import com.incheck.common.MenuItem;
	import com.incheck.common.User;
	import com.incheck.components.ChannelHistoryWidget;
	import com.incheck.components.ChannelWidget;
	import com.incheck.components.ChannelWidgetScope;
	import com.incheck.components.IChannelWidget;
	import com.incheck.components.LeftNavigator;
	import com.incheck.components.RightNavigator;
	import com.incheck.components.Settings1Widg;
	import com.incheck.components.model.ChartDataPointVO;
	import com.incheck.components.model.UserPreferencesModel;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.TabNavigator;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.config.ServerConfig;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;

	import org.alivepdf.layout.Mode;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Position;
	import org.alivepdf.layout.Resize;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;


	public class IncheckModel extends EventDispatcher
	{

		[Bindable]
		public var historyChartFunction:String = "MAX";

		[Bindable]
		public var historyChartUnits:String = "weeks";

		[Bindable]
		public var historyParameter:String = "RMS";

		[Bindable]
		public var historyBand:Object = {bandId:1, bandName:"All"};

		[Bindable]
		public var historyTrend:String = "Regression, linear";

		[Bindable]
		public var histAccEUnit:String = "g";

		[Bindable]
		public var histVelEUnit:String = "in/s";

		[Bindable]
		public var histTempEUnit:String = "C";

		[Bindable]
		public var histPressEUnit:String = "psi";

		[Bindable]
		public var AccEUnit:String = "AccG";

		[Bindable]
		public var VelEUnit:String = "VelInSec";

		[Bindable]
		public var DispEUnit:String = "DisplMil";

		[Bindable]
		public var FreqEUnit:String = "FreqHz";

		[Bindable]
		public var TimeEUnit:String = "TimeSec";

		[Bindable]
		public var TempEUnit:String = "TempC";

		[Bindable]
		public var frameMenuSelection:String = "frameOne";

		[Bindable]
		public var cursorMenuSelectionScope:uint = DataViewCursorTypes.Disabled;

		[Bindable]
		public var cursorMenuSelectionAnalysis:uint = DataViewCursorTypes.Disabled;

		[Bindable]
		public var systemStatusEvents:ArrayCollection;

		[Bindable]
		public var selectedNode:ICNode;

		[Bindable]
		public var channelNodes:ArrayCollection = new ArrayCollection();

		public var scalingHistoryMenuSelection:uint = DataViewScalingTypes.Disabled;

		public var scalingMenuSelectionScope:uint = DataViewScalingTypes.Disabled;

		public var scalingMenuSelectionAnalysis:uint = DataViewScalingTypes.Disabled;

		public var SpectrumConfigApplyToAllmodeOn:Boolean = false;

		[Bindable]
		public var right:RightNavigator;

		public var left:LeftNavigator;

		public var currentUser:User;

		[Bindable]
		public var autoRefresh:Boolean = false;

		public var requestEnabled:Boolean = true;

		[Bindable]
		public var defaultFileName:String = "analyzer_data";


		private static var INSTANCE:IncheckModel;


		[Bindable]
		private var _userPreferencesModel:UserPreferencesModel = new UserPreferencesModel();


		private var columns:Dictionary = new Dictionary();

		private var rightMachines:Dictionary = new Dictionary();

		private var DataViewZoomSelectedScope:Boolean = false;

		private var DataViewZoomSelectedAnalysis:Boolean = false;

		private var SpectrumAnalysisConfigByChannel:Dictionary = new Dictionary();

		private var dataZoom:DataViewZoom = new DataViewZoom();

		private var _graphMenuSelectionScope:String = "accel";

		private var _graphMenuSelectionAnalysis:String = "accel";

		private var _xeuScope:String = Constants.DEFAULT_FREQ_UNITS;

		private var _yeuScope:String = Constants.DEFAULT_ACCELERATION_UNITS;

		private var _xeuAnalysis:String = Constants.DEFAULT_FREQ_UNITS;

		private var _yeuAnalysis:String = Constants.DEFAULT_ACCELERATION_UNITS;

		private var _functionMenuSelectionScope:String = "spec";

		private var _functionMenuSelectionAnalysis:String = "spec";

		private var _lastMesTypeScope:String = "";

		private var _lastMesTypeAnalysis:String = "";

		private var _MesTypeScope:String = "Peak";

		private var _MesTypeAnalysis:String = "Peak";

		private var _selectedChannel:ChannelWidget = null;

		private var _selectedScopeChannel:ChannelWidgetScope = null;

		private var _averaging:String;

		private var file:FileReference;


		public function IncheckModel(creator:IncheckModelCreator)
		{
			if (!(creator is IncheckModelCreator))
			{
				throw new Error("IncheckModel class must be instantiated with static method IncheckModel.instance()");
			} // if
		}


		public static function instance():IncheckModel
		{
			if (!INSTANCE)
			{
				INSTANCE = new IncheckModel(new IncheckModelCreator());
			} // if
			return INSTANCE;
		}


		public function get userPreferencesModel():UserPreferencesModel
		{
			return _userPreferencesModel;
		}


		// we need to create a getter/setter pair so the event gets dispatched even if the new value is equal to the old value
		// when you just have a regular [Bindable] metadata tag, the event will not get dispatched if the new value is the same as the old
		// this was causing an issue where the bindings would not update in ChannelWidget.mxml when a user would click "Peak" in the menu
		// when "Peak" was already toggled on.  
		[Bindable(event = "MesTypeChangeScope")]
		public function get MesTypeScope():String
		{
			return _MesTypeScope;
		}


		public function set MesTypeScope(value:String):void
		{
			_MesTypeScope = value;
			dispatchEvent(new Event("MesTypeChangeScope"));
		}


		[Bindable(event = "MesTypeChangeAnalysis")]
		public function get MesTypeAnalysis():String
		{
			return _MesTypeAnalysis;
		}


		public function set MesTypeAnalysis(value:String):void
		{
			_MesTypeAnalysis = value;
			dispatchEvent(new Event("MesTypeChangeAnalysis"));
		}


		public function get lastMesTypeScope():String
		{
			return _lastMesTypeScope;
		}


		public function set lastMesTypeScope(value:String):void
		{
			_lastMesTypeScope = value;
		}


		public function get lastMesTypeAnalysis():String
		{
			return _lastMesTypeAnalysis;
		}


		public function set lastMesTypeAnalysis(value:String):void
		{
			_lastMesTypeAnalysis = value;
		}


		public function get averaging():String
		{
			return _averaging;
		}


		public function set averaging(value:String):void
		{
			_averaging = value;
			dispatchEvent(new Event("graphMenuSelectionChangeScope"));
		}


		public function get xeuScope():String
		{
			return _xeuScope;
		}


		public function set xeuScope(value:String):void
		{
			_xeuScope = value;
		}


		public function get yeuScope():String
		{
			return _yeuScope;
		}


		public function set yeuScope(value:String):void
		{
			_yeuScope = value;
		}


		public function get xeuAnalysis():String
		{
			return _xeuAnalysis;
		}


		public function set xeuAnalysis(value:String):void
		{
			_xeuAnalysis = value;
		}


		public function get yeuAnalysis():String
		{
			return _yeuAnalysis;
		}


		public function set yeuAnalysis(value:String):void
		{
			_yeuAnalysis = value;
		}


		public function get selectedChannel():ChannelWidget
		{
			return _selectedChannel;
		}


		public function set selectedChannel(value:ChannelWidget):void
		{
			_selectedChannel = value;
		}


		public function get selectedScopeChannel():ChannelWidgetScope
		{
			return _selectedScopeChannel;
		}


		public function set selectedScopeChannel(value:ChannelWidgetScope):void
		{
			_selectedScopeChannel = value;
		}


		[Bindable(event = "graphMenuSelectionChangeScope")]
		public function get graphMenuSelectionScope():String
		{
			return _graphMenuSelectionScope;
		}


		public function set graphMenuSelectionScope(value:String):void
		{
			_graphMenuSelectionScope = value;
			dispatchEvent(new Event("graphMenuSelectionChangeScope"));
		}


		[Bindable(event = "graphMenuSelectionChangeAnalysis")]
		public function get graphMenuSelectionAnalysis():String
		{
			return _graphMenuSelectionAnalysis;
		}


		public function set graphMenuSelectionAnalysis(value:String):void
		{
			_graphMenuSelectionAnalysis = value;
			dispatchEvent(new Event("graphMenuSelectionChangeAnalysis"));
		}


		[Bindable(event = "functionMenuSelectionChangeAnalysis")]
		public function get functionMenuSelectionAnalysis():String
		{
			return _functionMenuSelectionAnalysis;
		}


		public function set functionMenuSelectionAnalysis(value:String):void
		{
			_functionMenuSelectionAnalysis = value;
			dispatchEvent(new Event("functionMenuSelectionChangeAnalysis"));
		}


		[Bindable(event = "functionMenuSelectionChangeScope")]
		public function get functionMenuSelectionScope():String
		{
			return _functionMenuSelectionScope;
		}


		public function set functionMenuSelectionScope(value:String):void
		{
			_functionMenuSelectionScope = value;
			dispatchEvent(new Event("functionMenuSelectionChangeScope"));
		}


		/*
				public function isChannelPresent(node:ICNode):Boolean
				{
					return getMachine(node).exists(node);
				}
		*/

		public function enableRequest():void
		{
			requestEnabled = true;
		}


		public function registerRight(r:RightNavigator):void
		{
			this.right = r;
		}


		public function registerLeft(l:LeftNavigator):void
		{
			this.left = l;
		}


		public function getAnalysisWidgets():Array
		{
			var result:Array = new Array();
			var l:int = IncheckModel.instance().left.analysisWidgets.numChildren;
			for (var i:int = 0; i < l; i++)
			{
				result.push(IncheckModel.instance().left.analysisWidgets.getChildAt(i));
			}
			return result;
		}


		public function getScopeWidgets():Array
		{
			var result:Array = new Array();
			var l:int = IncheckModel.instance().left.scopeWidgets.numChildren;
			for (var i:int = 0; i < l; i++)
			{
				result.push(IncheckModel.instance().left.scopeWidgets.getChildAt(i));
			}
			return result;
		}


		public function getAlerts(chann:ICNode):void
		{
			// Alert.show("getAlerts for "+selectedNode.channelid);
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.addEventListener(ResultEvent.RESULT, popAlerts);
			ro.getAlertsByChannelId(chann.channelid);
			trace("ro.getAlertsByChannelId(" + chann.channelid + ")");
//			right.alertsGrid.dataProvider = new ArrayCollection();
		}


		public function getAllAlerts():void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.addEventListener(ResultEvent.RESULT, popAlerts, false, 0, true);
			ro.getAllAlerts();
			trace("ro.getAllAlerts()");
//			right.alertsGrid.dataProvider = new ArrayCollection();
		}


		public function getLastDeviceEvents():void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.addEventListener(ResultEvent.RESULT, popSystemStatus, false, 0, true);
			ro.getLastDeviceEvents();
//			trace("ro.getLastDeviceEvents()");
		}


		public function popSystemStatus(results:ResultEvent):void
		{
			var events:ArrayCollection = results.result as ArrayCollection;
			organizeDeviceEvents(events);
			systemStatusEvents = organizeDeviceEvents(events);
		}


		public function organizeDeviceEvents(events:ArrayCollection):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			if (events)
			{
				var deviceIdToDeviceGroup:Dictionary = new Dictionary();
				for each (var event:DeviceEvent in events)
				{
					var deviceEventGroup:DeviceEventsGroup = deviceIdToDeviceGroup[event.deviceId];
					if (!deviceEventGroup)
					{
						deviceEventGroup = new DeviceEventsGroup(event.deviceMac);
						deviceIdToDeviceGroup[event.deviceId] = deviceEventGroup;
					}
					deviceEventGroup.registerEvent(event.operation, event.timestamp);
				}
				for each (var eventGroup:DeviceEventsGroup in deviceIdToDeviceGroup)
				{
					result.addItem(eventGroup);
				}
			}
			return result;
		}


		public function popAlerts(results:ResultEvent):void
		{
			// Alert.show("popAlerts");

			// Alert.show("popAlerts  right not null");
			var col1:ArrayCollection = results.result as ArrayCollection;
			right.events = col1;
		/*			right.eventsType.selectedIndex = 0;
					right.alertsGrid.dataProvider = col1;
					right.alertsGrid.visible = true;
					right.logviewProgBar.visible = false;
		*/
		}


		public static function changeSamplingRate(chId:Number, sampleRate:Number, NumofSampl:Number):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.changeSamplingRate(chId, sampleRate, NumofSampl);
			trace("ro.changeSamplingRate(" + chId + ", " + sampleRate + ", " + NumofSampl + ")");
		}


		public static function updateThresholdValue(chId:Number, sev:Number, type:String, newval:Number):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.updateThresholdValue(chId, sev, type, newval);
			trace("ro.updateThresholdValue(" + chId + ", " + sev + ", " + type + ", " + newval + ")");
			// Alert.show("updateThresholdValue called");					
		}


		private function fillRecord(record:GridRow, display:DisplayObject):void
		{
			var item:GridItem = new GridItem();
			item.addChild(display);
			record.addChild(item);
		}


		private function hasChannel(id:int):Boolean
		{
			for each (var col:OverallColumn in columns)
			{
				if (col.id() == id)
				{
					return true;
				}
			}
			return false;
		}


		/*
				private function getMachine(node:ICNode):Machine
				{
					var parent:ICNode = getMachineLevelNode(node);
					var machine:Machine = rightMachines[parent.name];
					if (machine == null)
					{
						machine = new Machine(parent);
						//machine.maxWidth = right.dashboard.machines.width;
						rightMachines[parent.name] = machine;
					}
					return machine;
				}
		*/

		// this method is passed an ICNode and returns the first ICNode of type "machine" as it travels up its hierarchy.  If the ICNode itself is of type "machine" it will return itself. If none is found, it returns null
		private function getMachineLevelNode(node:ICNode):ICNode
		{
			if (node.type == TreeDataDescriptor.NODE_TYPE_MACHINE)
			{
				return node;
			}
			var pnode:ICNode = node.parent;
			while (pnode != null)
			{
				if (pnode.type == TreeDataDescriptor.NODE_TYPE_MACHINE)
				{
					return pnode;
				}
				else
				{
					pnode = pnode.parent;
				}
			}
			return null;
		}


		private function createChannelList(parent:ICNode, list:Array):void
		{
			for each (var node:ICNode in parent.children)
			{
				if (node.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
				{
					list.push(node);
				}
				else
				{
					createChannelList(node, list);
				}
			}
		}


		public function getAvailableCharts(node:ICNode):ArrayCollection
		{
			var types:ArrayCollection = node.processedDataKeysString;
			if (types == null || types.length == 0)
			{
				// -- data doesn't exist
				// Alert.show("Chart types " + ((types == null) ? "are null" : "length = **" + types.length));
				return null;
			}
			return types;
		}


		/*
				private function getChart(node:ICNode):IncheckChart
				{
					var types:ArrayCollection = getAvailableCharts(node);
					if (types == null || types.length == 0)
					{
						// -- data doesn't exist
						// Alert.show("Chart types " + ((types == null) ? "are null" : "length = **" + types.length));
						return null;
						;
					}
					var chart:IncheckChart = createChart(types[0]);
					chart.register();
					return chart;
				}
		*/

		public function addChart(node:ICNode, dt:Date):void
		{
			if (((dt != null) && node.processedDataKeysString.contains("Recent Trend")) || (node.channelType == Constants.STATIC_CHANNEL))
			{
				Alert.show("Cannot add this type of channel to the Analysis window")
				return;
			}

			var isFromHistory:Boolean = (dt ? true : false);
			var w:ChannelWidget = new ChannelWidget();
			w.setNode(node, isFromHistory ? ChannelWidget.HIST_DATA : ChannelWidget.LATEST_DATA, dt);
			w.fromHistory = isFromHistory;
			left.analysisWidgets.addElement(w);
			left.updateSelection(w);
			w.showGraphOption.selected = true;
		}


		public function addHistoryChart(node:ICNode):void
		{
		/*
		//			var chart:IncheckChart = getChart(node);
		//			if(chart != null){
		//
		//				var box:ChartBox = new ChartBox();
		//				box.label = chart.chartName;
		//				box.addChild(chart);
		//				right.dataView.addChild(box);
		//			}


					//right.dataViewChart.addNodeToChart(node);

					if (left.quickViewTab == null)
					{
						return;
					}
					var w:ChannelHistoryWidget = new ChannelHistoryWidget();
					w.setNode(node);
					var alreadyIn:Boolean = false;
		//			for each (var nodesin:ChannelHistoryWidget in left.selectedHistoryBox.getChildren())
					for each (var nodesin:ChannelHistoryWidget in left.widgets.getChildren())
					{
						if (nodesin.node.channelid == node.channelid)
						{
							alreadyIn = true;
							break;
						}
					}
					if (!alreadyIn)
					{
		//				left.selectedHistoryBox.addChild(w);
						left.widgets.addChild(w);
						w.chBox.selected = true;
		//				right.historyChart.regenStockSeriesWithZoomReset();
					}
		*/
		}


		public function removeWidget(w:ChannelWidget):void
		{
			w.releaseBindings();
			left.removeWidget(w);
			right.analysisChart.regenLineSeriesWithZoomReset();
		}


		public function removeWidgetScope(w:ChannelWidgetScope):void
		{
			w.releaseBindings();
			left.removeWidgetScope(w);
			right.scopeChart.regenLineSeriesWithZoomReset();
		}


		public function removeHistoryWidget(w:ChannelHistoryWidget):void
		{
//			left.widgets.removeChild(w);
//			left.selectedHistoryBox.removeChild(w);
//			right.historyChart.regenStockSeriesWithZoomReset();
			//getOverallsLastMonth
		}


		public function getAvailDatesForProcDynData(channel:Number):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
			{
				//right.datePicker.dataProvider=event.result as ArrayCollection;
			}, false, 0, true);
			ro.addEventListener(FaultEvent.FAULT, function():void
			{
				Alert.show("ERROR")
			}, false, 0, true);
			var start:Date = new Date();
			start.setMonth(0);
			ro.getAvailDatesForProcDynData(new Number(channel), start, new Date());
			trace("ro.getAvailDatesForProcDynData(" + channel + ", " + start + ", new Date())");
		}


		public function getProcessedDynamicDataByDate(node:ICNode, dt:Date, callBack:Function, type:String, xeu:String, yeu:String):void
		{
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.addEventListener(ResultEvent.RESULT, callBack, false, 0, true);
			// ro.addEventListener(FaultEvent.FAULT, function():void{Alert.show("it DIDNT WORK?")}, false, 0, true );
//            ro.retrieveProcessedDynamicData(node.channelid, dt, type, xeu, yeu);
			ro.getHistoryData(node.channelid, dt);
			Logger.log(this, "ro.retrieveProcessedDynamicData(" + node.channelid + ", " + dt + ", " + type + ", " + xeu + ", " + yeu + ")");
		}


		public function getLatestProcessedDynamicDataByType(node:ICNode, type:String, callBack:Function, sampleId:String, xeu:String, yeu:String):void
		{
//			var ro:RemoteObject = new RemoteObject("usbDevice");
			var ro:RemoteObject = new RemoteObject("icNodes");

			var cs:ChannelSet = new ChannelSet();
			var customChannel:Channel = ServerConfig.getChannel(Constants.SERVICE_ID);
			cs.addChannel(customChannel);
			ro.channelSet = cs;

			ro.addEventListener(ResultEvent.RESULT, callBack, false, 0, true);
			ro.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void
			{
//				Alert.show("it DIDNT WORK?")
			}, false, 0, true);
			if (node.processedDataKeysString == null /* || node.processedDataKeysString.length == 0*/)
			{
//                Alert.show("Processed Data " + type + " is not aviliable for " + node.name);
			}
			else
			{
				ro.getAllData(node.channelid, sampleId);
			}
		}


		/*
		public function retrieveProcessedDynamicData(channel:Number,sdate:Date):void{

				var ro:RemoteObject = new RemoteObject("icNodes");
				ro.addEventListener(ResultEvent.RESULT,
					function(event:ResultEvent):void{
						var pd:ProcessedDataInterface=event.result as ProcessedDataInterface;
						if(pd.data==null){
							Alert.show("pd.data is null");
						}else{
//							right.dataViewChart.showHistData(pd.data);
						}
					}, false, 0, true);
				ro.addEventListener(FaultEvent.FAULT, function():void{Alert.show("it DIDNT WORK?")}, false, 0, true);
				var start:Date=new Date();
				start.setMonth(0);
				ro.retrieveProcessedDynamicData(channel,sdate);


		}
		*/

		/*
				public function clearDataView():void
				{
					right.dataViewChart.clearData();
				}
		*/
		/*
				public function expandToThisNode(name:String):void
				{

				}
		*/
		/*
				public function makeAnalysisChartVisible():void
				{
					right.AnalysisChartProgBar.visible = false;
					right.analysisChart.visible = true;
				}
		*/

		public function pollForChangesInAnalysisChart(trigTime:Number):void
		{
//			if (right.dataViewChart.visible == true)
//			{
//				return;
//			}
//			var allWidg:Array = IncheckModel.instance().left.selectedChannelsBox.getChildren();
//			var numberChecked:uint = 0;
//			for each (var oneWZ:ChannelWidget in allWidg)
//			{
//				if ((!oneWZ.chBox.selected ) || oneWZ.processedData == null)
//				{
//					continue;
//				}
//				numberChecked++;
//				if (oneWZ.lastUpdate < trigTime)
//				{
//					setTimeout(pollForChangesInAnalysisChart, 500, trigTime);
//					return;
//				}
//			}
//			makeAnalysisChartVisible();	
		}


		public function setGraphSelectionScope(sel:String):void
		{
//			setTimeout(pollForChangesInAnalysisChart, 500, new Date().time);
//			right.dataViewChart.visible = false;
//			right.AnalysisChartProgBar.visible = true;
//			setTimeout(makeAnalysisChartVisible, 10000);
//			right.dataViewChart.clearData();	
			this.scalingMenuSelectionScope = DataViewScalingTypes.Disabled;
			for each (var eachItem:MenuItem in this.right.scopeMenuBar.Scaling.children)
			{
				eachItem.toggled = false;
			}
			this.right.scopeMenuBar.Scaling.children[0].toggled = true;
			this.graphMenuSelectionScope = sel;
		}


		public function setGraphSelectionAnalysis(sel:String):void
		{
//			setTimeout(pollForChangesInAnalysisChart, 500, new Date().time);
//			right.dataViewChart.visible = false;
//			right.AnalysisChartProgBar.visible = true;
//			setTimeout(makeAnalysisChartVisible, 10000);
//			right.dataViewChart.clearData();	
			this.scalingMenuSelectionAnalysis = DataViewScalingTypes.Disabled;
			for each (var eachItem:MenuItem in this.right.analysisMenuBar.Scaling.children)
			{
				eachItem.toggled = false;
			}
			this.right.analysisMenuBar.Scaling.children[0].toggled = true;
			this.graphMenuSelectionAnalysis = sel;
		}


		public function setFunctionSelectionAnalysis(sel:String):void
		{
			right.analysisChart.clearData();
			this.scalingMenuSelectionAnalysis = DataViewScalingTypes.Disabled;
			if (sel == "wave")
			{
				//right.brndem.enabled=false;
			}
			else
			{
				//right.brndem.enabled=true;
			}
			this.functionMenuSelectionAnalysis = sel;
		}


		public function setFunctionSelectionScope(sel:String):void
		{
			right.scopeChart.clearData();
			this.scalingMenuSelectionScope = DataViewScalingTypes.Disabled;
			if (sel == "wave")
			{
				//right.brndem.enabled=false;
			}
			else
			{
				//right.brndem.enabled=true;
			}
			this.functionMenuSelectionScope = sel;
		}


		public function setFrameSelection(sel:String):void
		{
			//right.dataViewChart.clearData();	
			this.frameMenuSelection = sel;
		}


		public function setCursorSelectionScope(sel:uint):void
		{
			//right.dataViewChart.clearData();		
			this.cursorMenuSelectionScope = sel;
			if (sel == DataViewCursorTypes.Harmonic || sel == DataViewCursorTypes.Sideband || sel == DataViewCursorTypes.PeakFinder)
			{
				right.scopeMenuBar.extraCursors.visible = true;
				if (sel == DataViewCursorTypes.PeakFinder)
				{
					right.scopeMenuBar.extraCursLabel.text = "Number of Peaks:";
				}
				else
				{
					right.scopeMenuBar.extraCursLabel.text = "Number of Cursors:";
				}
			}
			else
			{
				right.scopeMenuBar.extraCursors.visible = false;
			}
			scalingMenuSelectionScope = DataViewScalingTypes.Disabled;
			for each (var eachItem:MenuItem in this.right.scopeMenuBar.Scaling.children)
			{
				eachItem.toggled = false;
			}
			right.scopeMenuBar.Scaling.children[0].toggled = true;
			right.scopeChart.invalidateDisplayList();
		}


		public function setCursorSelectionAnalysis(sel:uint):void
		{
			//right.dataViewChart.clearData();		
			this.cursorMenuSelectionAnalysis = sel;
			if (sel == DataViewCursorTypes.Harmonic || sel == DataViewCursorTypes.Sideband || sel == DataViewCursorTypes.PeakFinder)
			{
				right.analysisMenuBar.extraCursors.visible = true;
				if (sel == DataViewCursorTypes.PeakFinder)
				{
					right.analysisMenuBar.extraCursLabel.text = "Number of Peaks:";
				}
				else
				{
					right.analysisMenuBar.extraCursLabel.text = "Number of Cursors:";
				}
			}
			else
			{
				right.analysisMenuBar.extraCursors.visible = false;
			}
			this.scalingMenuSelectionAnalysis = DataViewScalingTypes.Disabled;
			for each (var eachItem:MenuItem in this.right.analysisMenuBar.Scaling.children)
			{
				eachItem.toggled = false;
			}
			this.right.analysisMenuBar.Scaling.children[0].toggled = true;
			right.analysisChart.invalidateDisplayList();
		}


		public function setHistoryScalingSelection(sel:uint):void
		{
			this.scalingHistoryMenuSelection = sel;
		}


		public function setScalingSelectionScope(sel:uint):void
		{
			//right.dataViewChart.clearData();			
			this.scalingMenuSelectionScope = sel;
		/* commented out by Jamie to test
		this.cursorMenuSelection = DataViewCursorTypes.Disabled;
		for each (var eachItem:MenuItem in this.right.cursorMenu.children)
		{
			eachItem.toggled = false;
		}
		this.right.cursorMenu.children[0].toggled = true;
		*/
		}


		public function setScalingSelectionAnalysis(sel:uint):void
		{
			//right.dataViewChart.clearData();			
			this.scalingMenuSelectionAnalysis = sel;
		/* commented out by Jamie to test
		this.cursorMenuSelection = DataViewCursorTypes.Disabled;
		for each (var eachItem:MenuItem in this.right.cursorMenu.children)
		{
			eachItem.toggled = false;
		}
		this.right.cursorMenu.children[0].toggled = true;
		*/
		}


		public function changeLeftTabLabel(s:String):void
		{
//			left.selectedChannelsTab.label = left.widgetViewAccordion.selectedChild.label;
		}


		public function changeLeftTabSelectedIndex(ind:int):void
		{
			(left as TabNavigator).selectedIndex = ind;
		}


		public function changeLeftAccordionSelectedIndex(ind:int):void
		{
//			left.widgetViewAccordion.selectedIndex = ind;
		}


		public function dataViewZoomIn():void
		{

		}


		public function dataViewZoomOut():void
		{

		}


		public function getDataViewZoom():DataViewZoom
		{
			return this.dataZoom;
		}


		public function isDataViewZoomSelectedScope():Boolean
		{
			return DataViewZoomSelectedScope;
		}


		public function isDataViewZoomSelectedAnalysis():Boolean
		{
			return DataViewZoomSelectedScope;
		}


		public function setDataViewZoomEnableScope(tog:Boolean):void
		{
			DataViewZoomSelectedScope = tog;
			right.scopeChart.invalidateSeriesStyles();
			right.scopeChart.validateNow();
		}


		public function setDataViewZoomEnableAnalysis(tog:Boolean):void
		{
			DataViewZoomSelectedAnalysis = tog;
			right.analysisChart.invalidateSeriesStyles();
			right.analysisChart.validateNow();
		}


		public function turnOnApplyAllModeSpectrumConfig(caller:Settings1Widg):void
		{
		/*			SpectrumConfigApplyToAllmodeOn = true;
					for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
					{
						if (eachOne.myNode.id != caller.myNode.id)
						{
							eachOne.disableMe();
						}
					}
		*/
		}


		public function turnOffApplyAllModeSpectrumConfig(caller:Settings1Widg):void
		{
			SpectrumConfigApplyToAllmodeOn = false;
		/*			for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
					{
						eachOne.enableMe();
					}
		*/
		}


		public function getAllOtherSpectrumConfigBoxes(caller:Settings1Widg):ArrayCollection
		{
			var retVal:ArrayCollection = new ArrayCollection();
			/*			for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
						{
							if (eachOne.myNode.id != caller.myNode.id)
							{
								retVal.addItem(eachOne)
							}
						}
			*/
			return retVal;
		}


		public function applySameSettingsToTheRestOfSpectrumConfigWIdgets():ArrayCollection
		{
			var retVal:ArrayCollection = new ArrayCollection();
			var caller:Settings1Widg;
			var eachOne:Settings1Widg;
			/*			for each (eachOne in right.specConfig.getChildren())
						{
							if (eachOne.ApplyAllCheckBox.selected)
							{
								caller = eachOne;
								break;
							}
						}
						for each (eachOne in right.specConfig.getChildren())
						{
							if (eachOne.myNode.id != caller.myNode.id)
							{
								eachOne.SepctrumBandList.selectedIndex = caller.SepctrumBandList.selectedIndex;
								eachOne.SpectrumLinesList.selectedIndex = caller.SpectrumLinesList.selectedIndex;
							}
						}
			*/
			return retVal;
		}


		public function submitUpdateForAllSpectrumConfigBoxes(caller:Settings1Widg):ArrayCollection
		{
			var retVal:ArrayCollection = new ArrayCollection();
			/*			for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
						{
							if (eachOne.myNode.id != caller.myNode.id)
							{
								eachOne.updateClicked();
							}
						}
			*/
			return retVal;
		}


		// these function provide a way for other objects to access the user's prefered units, which are located in the userPreferencesModel
		public function getUserAccelerationUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.accelerationUnits != null)
			{
				value = String(_userPreferencesModel.accelerationUnits.getItemAt(_userPreferencesModel.accelerationUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserVelocityUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.velocityUnits)
			{
				value = String(_userPreferencesModel.velocityUnits.getItemAt(_userPreferencesModel.velocityUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserDisplacementUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.displacementUnits)
			{
				value = String(_userPreferencesModel.displacementUnits.getItemAt(_userPreferencesModel.displacementUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserFrequencyUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.frequencyUnits)
			{
				value = String(_userPreferencesModel.frequencyUnits.getItemAt(_userPreferencesModel.frequencyUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserTimeUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.timeUnits)
			{
				value = String(_userPreferencesModel.timeUnits.getItemAt(_userPreferencesModel.timeUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserTemperatureUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.temperatureUnits)
			{
				value = String(_userPreferencesModel.temperatureUnits.getItemAt(_userPreferencesModel.temperatureUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserPressureUnits():String
		{
			var value:String = "";
			if (_userPreferencesModel.pressureUnits)
			{
				value = String(_userPreferencesModel.pressureUnits.getItemAt(_userPreferencesModel.pressureUnitsSelectedIndex));
			}
			return value;
		}


		public function getUserVibrationType():String
		{
			var value:String = "";
			if (_userPreferencesModel.vibrationType)
			{
				value = String(_userPreferencesModel.vibrationType.getItemAt(_userPreferencesModel.vibrationTypeSelectedIndex));
			}
			return value;
		}


		public function getUserMeasurementType():String
		{
			var value:String = "";
			if (_userPreferencesModel.measurementType)
			{
				value = String(_userPreferencesModel.measurementType.getItemAt(_userPreferencesModel.measurementTypeSelectedIndex));
			}
			return value;
		}


		public function getUserOverallType():String
		{
			var value:String = "";
			if (_userPreferencesModel.overallType)
			{
				value = String(_userPreferencesModel.overallType.getItemAt(_userPreferencesModel.overallTypeSelectedIndex));
			}
			return value;
		}


		public function getDisplayedPrecision():int
		{
			return _userPreferencesModel.displayedPrecision;
		}


		public function getSNThreshold():int
		{
			return _userPreferencesModel.scientificNotationThreshold;
		}


		// these functions return a conversion function that will convert from the default units to the specified unitsToConvertTo (if not specified, it is the user's preferred units)
		// the default units from the server are: 
		//     Acceleration: g
		//     Velocity: in/s
		//     Displacement: mils
		//     Frequency: Hz
		//     Time: s
		//     Temperature: °C
		//     Pressure: psi
		public function getAccelerationUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserAccelerationUnits();
			switch (unitsToConvertTo)
			{
				case "in/s²":
				{
					return function(value:Number):Number
					{
						return value * 386.089
					};
					break;
				}

				case "mm/s²":
				{
					return function(value:Number):Number
					{
						return value * 9806.65;
					}
					break;
				}

				case "dB":
				{
					return function(value:Number):Number
					{
						if (value == 0)
						{
							return 0;
						}
						return 20 * Math.log(value / (_userPreferencesModel.accelerationRefLevelNumber * 1e-6));
					};
					break;
				}

				case "m/s²":
				{
					return function(value:Number):Number
					{
						return value * 9.80665;
					}
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value;
					}
					break;
				}
			}
		}


		public function getVelocityUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserVelocityUnits();
			switch (unitsToConvertTo)
			{
				case "mm/s":
				{
					return function(value:Number):Number
					{
						return value * 25.4
					};
					break;
				}

				case "m/s":
				{
					return function(value:Number):Number
					{
						return value * 0.0254
					};
					break;
				}

				case "dB":
				{
					return function(value:Number):Number
					{
						if (value == 0)
						{
							return 0;
						}
						return 20 * Math.log(value / (_userPreferencesModel.velocityRefLevelNumber * 1e-9));
					};
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value
					};
					break;
				}
			}
		}


		public function getDisplacementUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserDisplacementUnits();
			switch (unitsToConvertTo)
			{
				case "mm":
				{
					return function(value:Number):Number
					{
						return value * 0.0254
					};
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value
					};
					break;
				}
			}
		}


		public function getFrequencyUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserFrequencyUnits();
			switch (unitsToConvertTo)
			{
				case "CPM":
				{
					return function(value:Number):Number
					{
						return value * 60
					};
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value
					};
					break;
				}
			}
		}


		public function getTimeUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserTimeUnits();
			switch (unitsToConvertTo)
			{
				case "ms":
				{
					return function(value:Number):Number
					{
						return value * 1000
					};
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value
					};
					break;
				}
			}
		}


		public function getTemperatureUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserTemperatureUnits();
			switch (unitsToConvertTo)
			{
				case "°F":
				{
					return function(value:Number):Number
					{
						return value * 1.8 + 32
					};
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value
					};
					break;
				}
			}
		}


		public function getPressureUnitsConversionFunction(unitsToConvertTo:String = ""):Function
		{
			if (unitsToConvertTo == "")
				unitsToConvertTo = getUserPressureUnits();
			switch (unitsToConvertTo)
			{
				case "Pa":
				{
					return function(value:Number):Number
					{
						return value * 6894.75
					};
					break;
				}

				case "bar":
				{
					return function(value:Number):Number
					{
						return value * 0.0689475
					};
					break;
				}

				case "kgf/cm²":
				{
					return function(value:Number):Number
					{
						return value * 0.070307
					};
					break;
				}

				default:
				{
					return function(value:Number):Number
					{
						return value
					};
					break;
				}
			}
		}


		public function getSelectedChannelWidget():IChannelWidget
		{
			var channelWidget:IChannelWidget;
			switch (FlexGlobals.topLevelApplication.mainContent.currentState)
			{
				case "acquireState":
				{
					channelWidget = selectedScopeChannel as IChannelWidget;
					break;
				}
				case "analyseState":
				{

					channelWidget = selectedChannel as IChannelWidget;
					break;
				}
			}
			return channelWidget;
		}


		public function saveCsv():void
		{
			var channelWidget:IChannelWidget = getSelectedChannelWidget();
			var overalls:Object = channelWidget.processData.velocityData.spectrumData.overalls;
			var s:String = '';
			var a:Array = channelWidget.processData.velocityData.spectrumData.chartData.source;
			var l:int = a.length;
			var point:ChartDataPointVO;
			s += String(channelWidget.processData.channelId) + ';\r';
			s += channelWidget.processData.dateTimeStamp.toString() + ';\r';
			s += overalls != null ? overalls.overalls["Vel Peak"].toString() : '' + ';';
			s += overalls != null ? overalls.overalls["Vel_Rms"].toString() : '' + ';\r';
			for (var i:int = 0; i < l; i++)
			{
				point = new ChartDataPointVO(a[i]);
				s += point.x + ';';
				s += point.y + ';';
			}
			var file:FileReference = new FileReference();
			file.save(s, IncheckModel.instance().defaultFileName + ".csv");
		}


		public function savePdf():void
		{
			var p:PDF = new PDF(Orientation.LANDSCAPE, Unit.MM, Size.A4);
			p.addPage();
			var bitmapData:BitmapData = new BitmapData(left.width + right.width, Math.max(left.height, right.height));
			right.getGraphImage(bitmapData, left.width);
			left.getChannelImages(bitmapData, right.tabs.selectedIndex - 1, right.width);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			p.addImage(bitmap, new Resize(Mode.RESIZE_PAGE, Position.CENTERED));
			saveImage(p);
		}


		private function saveImage(p:PDF):void
		{
			var file:FileReference = new FileReference();
			var bytes:ByteArray = p.save(Method.LOCAL);
			file.save(bytes, IncheckModel.instance().defaultFileName + ".pdf");
		}

		/**
		 * Encode the data from selected channel to JSON and save it to local file. 
		 * 
		 */
		public function saveLocalData():void
		{
			file = new FileReference();
			file.save(encodeChannelDataToJSON(getSelectedChannelWidget()), "json.txt");
		}


		/**
		 * Load JSON from external file. 
		 * 
		 */
		public function loadLocalData():void
		{
			file = new FileReference();
			file.browse([new FileFilter("JSON files", "*.json;*.txt")]);
			file.addEventListener(Event.SELECT, onFileSelect);
		}

		
		/**
		 * File select (Event.SELECT) handler.
		 * 
		 * @param event
		 * 
		 */
		private function onFileSelect(event:Event):void
		{
			file.addEventListener(Event.COMPLETE, onFileComplete);
			file.load();
		}

		
		/**
		 * Encode the channel widget into JSON string.
		 * 
		 * @param channelWidget
		 * @return 
		 * 
		 */
		public function encodeChannelDataToJSON(channelWidget:IChannelWidget):String
		{
			var objectToEncode:Object = new Object();
			objectToEncode.PROTOCOL_VERSION = "1.0";
			objectToEncode.MESSAGE_TYPE = "DATA";
			objectToEncode.DEVICE_ID = channelWidget.node.deviceId;
			objectToEncode.TIMESTAMP = channelWidget.node.latestTimeStamp;
			objectToEncode.DEVICE_CHANNEL_ID = channelWidget.node.channelid;
			objectToEncode.SAMPLING_RATE = channelWidget.node.samplingRate;
			objectToEncode.RPM = isNaN(channelWidget.node.rpm) ? 0 : channelWidget.node.rpm;
			objectToEncode.SAMPLE_SIZE = channelWidget.node.numberOfSamples;
			objectToEncode.DATA = channelWidget.graphData.chartData.source;
			objectToEncode.UNIT = channelWidget.node.dataUnits;
			return JSON.encode(objectToEncode);
		}

		
		/**
		 * Decode the JSON string and put decoded data into channel widget.
		 * 
		 * @param jsonString The string with JSON to decode.
		 * @param channelWidget The channel widget to put decoded JSON data.
		 * 
		 */
		public function decodeChannelDataFromJSON(jsonString:String, channelWidget:IChannelWidget):void
		{
			var objectToEncode:Object = JSON.decode(jsonString);
//			objectToEncode.PROTOCOL_VERSION = "";
//			objectToEncode.MESSAGE_TYPE = "";
//			channelWidget.node.deviceId = objectToEncode.DEVICE_ID;
			channelWidget.node.latestTimeStamp = objectToEncode.TIMESTAMP;
//			channelWidget.node.channelid = objectToEncode.DEVICE_CHANNEL_ID;
			channelWidget.node.samplingRate = objectToEncode.SAMPLING_RATE;
			channelWidget.node.rpm = objectToEncode.RPM;
			channelWidget.node.numberOfSamples = objectToEncode.SAMPLE_SIZE;
			channelWidget.node.dataUnits = objectToEncode.UNIT;
			/*			
			// Get values from objectToEncode.DATA;
			channelWidget.graphData.min = objectToEncode.DATA.min;
			channelWidget.graphData.max = objectToEncode.DATA.max;	
			channelWidget.graphData.measurementType = objectToEncode.DATA.measurementType;	
			channelWidget.graphData.measurementUnit = objectToEncode.DATA.measurementUnit;	
			channelWidget.graphData.samplingRate = objectToEncode.DATA.samplingRate;
			channelWidget.graphData.XEUnit = objectToEncode.DATA.XEUnit;
			channelWidget.graphData.XPhysDomain = objectToEncode.DATA.XPhysDomain;
			channelWidget.graphData.XSymbol = objectToEncode.DATA.XSymbol;
			channelWidget.graphData.YEUnit = objectToEncode.DATA.YEUnit;
			channelWidget.graphData.YPhysDomain	= objectToEncode.DATA.YPhysDomain;
			channelWidget.graphData.YSymbol	= objectToEncode.DATA.YSymbol;
			// Get values from objectToEncode.DATA.overalls;
			channelWidget.graphData.overalls.channelId = objectToEncode.DATA.overalls.channelId;
			channelWidget.graphData.overalls.dateTimeStamp = objectToEncode.DATA.overalls.dateTimeStamp;
			channelWidget.graphData.overalls.dateTimeStampMillis = objectToEncode.DATA.overalls.dateTimeStampMillis;
			channelWidget.graphData.overalls.overalls = objectToEncode.DATA.overalls.overalls;
			channelWidget.graphData.chartData = new ArrayCollection(objectToEncode.DATA.chartData.source);
			*/
			channelWidget.graphData.chartData = new ArrayCollection(objectToEncode.DATA);
		}

		
		/**
		 * File loaded (Event.COMPLETE) handler. 
		 * 
		 * @param event Event.COMPLETE
		 * 
		 */
		private function onFileComplete(event:Event):void
		{
			// Decode the JSON data and put it to selected channel widget
			decodeChannelDataFromJSON(event.target.data, getSelectedChannelWidget());
			// Update chart
			right.scopeChart.regenLineSeries();
		}
	}
}


internal class IncheckModelCreator
{
}


