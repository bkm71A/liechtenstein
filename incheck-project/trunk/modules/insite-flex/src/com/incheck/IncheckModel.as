package com.incheck
{
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
    import com.incheck.components.IChannelWidget;
    import com.incheck.components.LeftNavigator;
    import com.incheck.components.RightNavigator;
    import com.incheck.components.Settings1Widg;
    import com.incheck.components.Settings2Widg;
    import com.incheck.model.ChartDataPointVO;
    import com.incheck.model.UserPreferencesModel;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.containers.GridItem;
    import mx.containers.GridRow;
    import mx.controls.Alert;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.remoting.RemoteObject;
    
    import org.alivepdf.layout.*;
    import org.alivepdf.pdf.PDF;
    import org.alivepdf.saving.Method;

    public class IncheckModel
    {
		
        [Bindable]
        public var historyChartFunction:String = "MAX";

        [Bindable]
        public var historyChartUnits:String = "weeks";
		
        [Bindable]
        public var historyParameter:String = "RMS";
		
        [Bindable]
        public var historyBand:Object = {bandId: 1, bandName: "All"};
		
        [Bindable]
        public var historyBands:ArrayCollection;

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
		public var cursorMenuSelection:uint = DataViewCursorTypes.Disabled;
		
		[Bindable]
		public var systemStatusEvents:ArrayCollection;
		
		[Bindable]
		public var selectedNode:ICNode;
		
		[Bindable]
		public var channelNodes:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var defaultFileName:String = "analyzer_data";
		
        public var scalingHistoryMenuSelection:uint = DataViewScalingTypes.Disabled;
		public var scalingMenuSelection:uint = DataViewScalingTypes.Disabled;
		public var SpectrumConfigApplyToAllmodeOn:Boolean = false;
		
		[Bindable]
		public var right:RightNavigator;
		public var left:LeftNavigator;
		public var currentUser:User;
        
		private static var INSTANCE:IncheckModel = new IncheckModel();

		[Bindable]
		private var _userPreferencesModel:UserPreferencesModel = new UserPreferencesModel();

		private var columns:Dictionary = new Dictionary();
		private var rightMachines:Dictionary = new Dictionary();
		private var DataViewZoomSelected:Boolean = false;
		private var SpectrumAnalysisConfigByChannel:Dictionary = new Dictionary();
		private var dataZoom:DataViewZoom = new DataViewZoom();
		private var _graphMenuSelection:String = "accel";
		private var _historyGraphMenuSelection:String = "Accel";
		private var _xeu:String = Constants.DEFAULT_FREQ_UNITS;
		private var _yeu:String = Constants.DEFAULT_ACCELERATION_UNITS;
        private var _functionMenuSelection:String = "spec";
        private var _lastMesType:Object = {};
		private var _MesType:String = "Peak";
		private var _selectedChannel:ChannelWidget = null;


		public static function instance():IncheckModel
		{
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
        [Bindable(event="MesTypeChange")]
        public function get MesType():String
        {
            return _MesType;
        }

		
        public function set MesType(value:String):void
        {
            _MesType = value;
            dispatchEvent(new Event("MesTypeChange"));
        }

		
        public function get lastMesType():Object
        {
            return _lastMesType;
        }

		
		public function get xeu():String
		{
			return _xeu;
		}
		
		
		public function set xeu(value:String):void
		{
			_xeu = value;
		}
		
		
		public function get yeu():String
		{
			return _yeu;
		}
		
		
		public function set yeu(value:String):void
		{
			_yeu = value;
		}
		
		
		public function get selectedChannel():ChannelWidget
		{
			return _selectedChannel;
		}
		
		
		public function set selectedChannel(value:ChannelWidget):void
		{
			_selectedChannel = value;
		}
		
		
        [Bindable(event="graphMenuSelectionChange")]
        public function get graphMenuSelection():String
        {
            return _graphMenuSelection;
        }

		
        public function set graphMenuSelection(value:String):void
        {
            _graphMenuSelection = value;
			dispatchEvent(new Event("graphMenuSelectionChange"));
        }


        [Bindable(event="historyGraphMenuSelectionChange")]
        public function get historyGraphMenuSelection():String
        {
            return _historyGraphMenuSelection;
        }

		
        public function set historyGraphMenuSelection(value:String):void
        {
            _historyGraphMenuSelection = value;
			dispatchEvent(new Event("historyGraphMenuSelectionChange"));
        }


        [Bindable(event="functionMenuSelectionChange")]
        public function get functionMenuSelection():String
        {
            return _functionMenuSelection;
        }

		
        public function set functionMenuSelection(value:String):void
        {
            _functionMenuSelection = value;
            dispatchEvent(new Event("functionMenuSelectionChange"));
        }

		
        public function channelClicked(node:ICNode):void
        {
            selectedNode = node;
            if (right.dataViewTab.visible == true && node.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
            {
                if (node.state == -1)
                {
                    return;
                }
                addChart(node, null);
                changeLeftTabSelectedIndex(1);
                changeLeftAccordionSelectedIndex(0);
            }
            else if (right.dashboardTab.visible == true)
            {
                if (node.state == -1)
                {
                    return;
                }
                var parentMachine:Machine = getMachine(node);
                if (!right.dashboard.contains(parentMachine))
                {
//                    right.dashboard.addChild(parentMachine);
                    right.dashboard.addElement(parentMachine);
                }
                else
                {
                    // --- machine exists
                }
                if (node.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
                {
                    parentMachine.add(node);
                }
                else if (node.type == TreeDataDescriptor.NODE_TYPE_MACHINE)
                {
                    var list:Array = new Array();
                    createChannelList(parentMachine.getMachine(), list);
                    parentMachine.addAll(list);
                }
            }
            else if (right.logview.visible == true && node.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
            {
                right.alertsGrid.visible = false;
                right.logviewProgBar.visible = true;
                IncheckModel.instance().getAlerts(node);
            }
            else if (right.tabHistory.visible == true && node.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
            {
                addHistoryChart(node);
                changeLeftTabSelectedIndex(1);
                changeLeftAccordionSelectedIndex(1);
            }
            else if (right.settingsView.visible == true && node.type == TreeDataDescriptor.NODE_TYPE_CHANNEL)
            {
                if (right.settingsNav.selectedIndex == 0)
                {
                    for each (var eachOne:Object in right.specConfig.getChildren())
                    {
                        if (eachOne is Settings1Widg)
                        {
                            if ((eachOne as Settings1Widg).myNode.id == node.id)
                            {
                                return;
                            }
                        }
                        if (eachOne is Settings2Widg)
                        {
                            if ((eachOne as Settings2Widg).myNode.id == node.id)
                            {
                                return;
                            }
                        }
                    }
                    // spectrum config widget for dynamic sensors
                    if (node.channelType == 1)
                    {
                        var setw:Settings1Widg = new Settings1Widg();
                        setw.initialize();
                        setw.setNode(node);
                        setw.channelName.text = node.name;
                        right.specConfig.addChild(setw);
                        if (SpectrumConfigApplyToAllmodeOn)
                        {
                            applySameSettingsToTheRestOfSpectrumConfigWIdgets();
                            setw.disableMe();
                        }
						right.settingsSelectMessage.visible = false;
						right.settingsSelectMessage.includeInLayout = false;
                        right.specConfig.validateNow();
                    }
                    // settings widget for static sensors
                    if (node.channelType == 2)
                    {
                        var setw2:Settings2Widg = new Settings2Widg();
                        right.specConfig.addChild(setw2);
                        setw2.setNode(node);
                        setw2.channelName.text = node.name;
                        right.specConfig.validateNow();
                    }
                }
            }
        }

		
        public function registerRight(r:RightNavigator):void
        {
            this.right = r;
        }

		
        public function registerLeft(l:LeftNavigator):void
        {
            this.left = l;
        }

		
        public function changeChartType(type:String):void
        {
        /*
	        if(right.dataView.numChildren > 0)
			{
	            var chart:IncheckChart = createChart(type);
	            chart.width = right.dataView.width / 2;
	            var box:ChartBox = new ChartBox();
	            box.label = chart.chartName;
	            box.addChild(chart);
	        }
        */
        }

		
        private function createChart(type:String):IncheckChart
        {
            var channel:int = (type == IncheckConstants.CHART_TYPE_TREND) ? 4 : 1;
            var chart:IncheckChart = new IncheckChart();
            chart.initChart(channel, type);
            return chart;
        }

		
        public function getAlerts(chann:ICNode):void
        {
            // Alert.show("getAlerts for "+selectedNode.channelid);
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.addEventListener(ResultEvent.RESULT, popAlerts);
            ro.getAlertsByChannelId(chann.channelid);
            trace("ro.getAlertsByChannelId(" + chann.channelid + ")");
            right.alertsGrid.dataProvider = new ArrayCollection();
        }

		
        public function getAllAlerts():void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.addEventListener(ResultEvent.RESULT, popAlerts);
            ro.getAllAlerts();
            trace("ro.getAllAlerts()");
            right.alertsGrid.dataProvider = new ArrayCollection();
        }

		
        public function getLastDeviceEvents():void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.addEventListener(ResultEvent.RESULT, popSystemStatus);
            ro.getLastDeviceEvents();
            trace("ro.getLastDeviceEvents()");
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
            right.eventsType.selectedIndex = 0;
            right.alertsGrid.dataProvider = col1;
            right.alertsGrid.visible = true;
            right.logviewProgBar.visible = false;
        }

		
        public static function changeSamplingRate(chId:Number, sampleRate:Number, NumofSampl:Number):void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.changeSamplingRate(chId, sampleRate, NumofSampl);
            trace("ro.changeSamplingRate(" + chId + ", " + sampleRate + ", " + NumofSampl + ")");
        }

        /*
        private function getColumn(node:ICNode):OverallColumn{
            var column:OverallColumn = columns[node.channelid];
            if(column == null){
                var index:int = 0;
                if(right.overallGrid.numChildren != 0){
                    // table has records
                    var row:GridRow = getRecord(0);
                    index = row.numChildren;
                }
                column = new OverallColumn(node, index);
                columns[node.channelid] = column;
            }

            return column;
        }*/

		
        public static function updateThresholdValue(chId:Number, sev:Number, type:String, newval:Number):void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
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

		
        private function getMachine(node:ICNode):Machine
        {
            var parent:ICNode = getMachineLevelNode(node);
            var machine:Machine = rightMachines[parent.name];
            if (machine == null)
            {
                machine = new Machine(parent);
                //machine.maxWidth = right.dashboard.width;
                rightMachines[parent.name] = machine;
            }
            return machine;
        }

		
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

		
        public function addChart(node:ICNode, dt:Date):void
        {
            if (((dt != null) && node.processedDataKeysString.contains("Recent Trend")) || (node.channelType == Constants.STATIC_CHANNEL))
            {
                Alert.show("Cannot add this type of channel to the Analysis window")
                return;
            }

            left.selectedIndex = 1;
            left.widgetViewAccordion.selectedIndex = 0;
            right.selectedIndex = 1;

            var isFromHistory:Boolean = (dt ? true : false);
            var w:ChannelWidget = new ChannelWidget();
            w.setNode(node, isFromHistory ? ChannelWidget.HIST_DATA : ChannelWidget.LATEST_DATA, dt);
            w.fromHistory = isFromHistory;
            left.selectedChannelsBox.addChild(w);
            left.updateSelection(w);
            w.chBox.selected = true;
        }

		
        public function addHistoryChart(node:ICNode):void
        {
            /*
            var chart:IncheckChart = getChart(node);
            if(chart != null){

                var box:ChartBox = new ChartBox();
                box.label = chart.chartName;
                box.addChild(chart);
                right.dataView.addChild(box);
            }
            */

            //right.dataViewChart.addNodeToChart(node);

            if (left.selectedHistoryBox == null)
            {
                return;
            }
            var w:ChannelHistoryWidget = new ChannelHistoryWidget();
            w.setNode(node);
            var alreadyIn:Boolean = false;
            for each (var nodesin:ChannelHistoryWidget in left.selectedHistoryBox.getChildren())
            {
                if (nodesin.node.channelid == node.channelid)
                {
                    alreadyIn = true;
                    break;
                }
            }
            if (!alreadyIn)
            {
                left.selectedHistoryBox.addChild(w);
                w.chBox.selected = true;
                right.historyChart.regenLineSeriesWithZoomReset();
            }
        }

		
        public function removeWidget(w:ChannelWidget):void
        {
            w.releaseBindings();
            left.removeWidget(w);
            right.dataViewChart.regenLineSeriesWithZoomReset();
        }

		
        public function removeHistoryWidget(w:ChannelHistoryWidget):void
        {
            left.selectedHistoryBox.removeChild(w);
            right.historyChart.regenLineSeriesWithZoomReset();
            //getOverallsLastMonth
        }

		
        public function getAvailDatesForProcDynData(channel:Number):void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void
            {
                //right.datePicker.dataProvider=event.result as ArrayCollection;
            });
            ro.addEventListener(FaultEvent.FAULT, function():void
            {
                Alert.show("ERROR")
            });
            var start:Date = new Date();
            start.setMonth(0);
            ro.getAvailDatesForProcDynData(new Number(channel), start, new Date());
            trace("ro.getAvailDatesForProcDynData(" + channel + ", " + start + ", new Date())");
        }

		
//		public function getLatestProcessedDynamicData(node:ICNode, callBack:Function, sampleId:String):void
//		{
//			var ro:RemoteObject = new RemoteObject("icNodes");
//			ro.addEventListener(ResultEvent.RESULT, callBack);
//			// ro.addEventListener(FaultEvent.FAULT, function():void{Alert.show("it DIDNT WORK?")} );
//			if (node.processedDataKeysString == null || node.processedDataKeysString.length == 0)
//			{
//				Alert.show("Processed Data is not aviliable for " + node.name);
//			}
//			else
//			{
//				ro.getProcessedDataObj(node.channelid, node.processedDataKeysString[0], sampleId);
//				trace("ro.getProcessedDataObj(" + node.channelid + ", " + node.processedDataKeysString[0] + ", " + sampleId + ")");
//			}
//		}

		
        public function getProcessedDynamicDataByDate(node:ICNode, dt:Date, callBack:Function, type:String, xeu:String, yeu:String):void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.addEventListener(ResultEvent.RESULT, callBack);
            // ro.addEventListener(FaultEvent.FAULT, function():void{Alert.show("it DIDNT WORK?")} );
//            ro.retrieveProcessedDynamicData(node.channelid, dt, type, xeu, yeu);
            ro.getHistoryData(node.channelid, dt);
            Logger.log(this, "ro.retrieveProcessedDynamicData(" + node.channelid + ", " + dt + ", " + type + ", " + xeu + ", " + yeu + ")");
        }

		
        public function getLatestProcessedDynamicDataByType(node:ICNode, type:String, resultHandler:Function, faultHandler:Function, sampleId:String, xeu:String, yeu:String):void
        {
            var ro:RemoteObject = new RemoteObject("icNodes");
            ro.addEventListener(ResultEvent.RESULT, resultHandler);
            ro.addEventListener(FaultEvent.FAULT, faultHandler);
            if (node.processedDataKeysString == null || node.processedDataKeysString.length == 0)
            {
                Alert.show("Processed Data " + type + " is not aviliable for " + node.name);
            }
            else
            {
                ro.getAllData(node.channelid, /*sampleId*/null);
                Logger.log(this, "ro.getUIProcessedData(" + node.channelid + ", " + type + ", " + sampleId + ", " + xeu + ", " + yeu + ")");
            }
        }

		
        public function clearDataView():void
        {
            right.dataViewChart.clearData();
        }

		
        public function expandToThisNode(name:String):void
        {

        }

		
        public function makeAnalysisChartVisible():void
        {
            right.AnalysisChartProgBar.visible = false;
            right.dataViewChart.visible = true;
        }

		
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

		
        public function setGraphSelection(sel:String):void
        {
//			setTimeout(pollForChangesInAnalysisChart, 500, new Date().time);
//			right.dataViewChart.visible = false;
//			right.AnalysisChartProgBar.visible = true;
//			setTimeout(makeAnalysisChartVisible, 10000);
//			right.dataViewChart.clearData();	
            this.scalingMenuSelection = DataViewScalingTypes.Disabled;
            for each (var eachItem:MenuItem in this.right.dataViewMenuBar.Scaling.children)
            {
                eachItem.toggled = false;
            }
            this.graphMenuSelection = sel;
        }

		
        public function setFunctionSelection(sel:String):void
        {
            right.dataViewChart.clearData();
            this.scalingMenuSelection = DataViewScalingTypes.Disabled;
            if (sel == "wave")
            {
                //right.brndem.enabled=false;
            }
            else
            {
                //right.brndem.enabled=true;
            }
            this.functionMenuSelection = sel;
        }

		
        public function setFrameSelection(sel:String):void
        {
            //right.dataViewChart.clearData();		
            this.frameMenuSelection = sel;
        }

		
        public function setCursorSelection(sel:uint):void
        {
            //right.dataViewChart.clearData();			
            this.cursorMenuSelection = sel;
            if (sel == DataViewCursorTypes.Harmonic || sel == DataViewCursorTypes.Sideband || sel == DataViewCursorTypes.PeakFinder)
            {
                right.dataViewMenuBar.extraCursors.visible = true;
                if (sel == DataViewCursorTypes.PeakFinder)
                {
                    right.dataViewMenuBar.extraCursLabel.text = "Number of Peaks:";
                }
                else
                {
                    right.dataViewMenuBar.extraCursLabel.text = "Number of Cursors:";
                }
            }
            else
            {
                right.dataViewMenuBar.extraCursors.visible = false;
            }
            this.scalingMenuSelection = DataViewScalingTypes.Disabled;
            for each (var eachItem:MenuItem in this.right.dataViewMenuBar.Scaling.children)
            {
                eachItem.toggled = false;
            }
            right.dataViewChart.invalidateDisplayList();
        }

		
        public function setHistoryScalingSelection(sel:uint):void
        {
            this.scalingHistoryMenuSelection = sel;
        }

		
        public function setScalingSelection(sel:uint):void
        {
            //right.dataViewChart.clearData();			
            this.scalingMenuSelection = sel;
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
            left.selectedChannelsTab.label = left.widgetViewAccordion.selectedChild.label;
        }

		
        public function changeLeftTabSelectedIndex(ind:int):void
        {
            left.selectedIndex = ind;
        }

		
        public function changeLeftAccordionSelectedIndex(ind:int):void
        {
            left.widgetViewAccordion.selectedIndex = ind;
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

		
        public function isDataViewZoomSelected():Boolean
        {
            return DataViewZoomSelected;
        }

		
        public function setDataViewZoomEnable(tog:Boolean):void
        {
            DataViewZoomSelected = tog;
            right.dataViewChart.invalidateSeriesStyles();
            right.dataViewChart.invalidateProperties();
            right.dataViewChart.invalidateDisplayList();
        }

		
        public function turnOnApplyAllModeSpectrumConfig(caller:Settings1Widg):void
        {
            SpectrumConfigApplyToAllmodeOn = true;
            for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
            {
                if (eachOne.myNode.id != caller.myNode.id)
                {
                    eachOne.disableMe();
                }
            }
        }

		
        public function turnOffApplyAllModeSpectrumConfig(caller:Settings1Widg):void
        {
            SpectrumConfigApplyToAllmodeOn = false;
            for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
            {
                eachOne.enableMe();
            }
        }

		
        public function getAllOtherSpectrumConfigBoxes(caller:Settings1Widg):ArrayCollection
        {
            var retVal:ArrayCollection = new ArrayCollection();
            for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
            {
                if (eachOne.myNode.id != caller.myNode.id)
                {
                    retVal.addItem(eachOne)
                }
            }
            return retVal;
        }

		
        public function applySameSettingsToTheRestOfSpectrumConfigWIdgets():ArrayCollection
        {
            var retVal:ArrayCollection = new ArrayCollection();
            var caller:Settings1Widg;
            var eachOne:Settings1Widg;
            for each (eachOne in right.specConfig.getChildren())
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
            return retVal;
        }

		
        public function submitUpdateForAllSpectrumConfigBoxes(caller:Settings1Widg):ArrayCollection
        {
            var retVal:ArrayCollection = new ArrayCollection();
            for each (var eachOne:Settings1Widg in right.specConfig.getChildren())
            {
                if (eachOne.myNode.id != caller.myNode.id)
                {
                    eachOne.updateClicked();
                }
            }
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
                        return value * 9806.65
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
                        return 20 * Math.log(value / (_userPreferencesModel.accelerationRefLevelNumber * 1e-6));
                    };
                    break;
                }
					
                case "m/s²":
                {
                    return function(value:Number):Number
                    {
                        return value * 9.80665
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
			channelWidget = _selectedChannel;
			return channelWidget;
		}
		
		
		public function saveCsv():void
		{
			var channelWidget:IChannelWidget = _selectedChannel as IChannelWidget;
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
			left.getChannelImages(bitmapData, right.selectedIndex - 1, right.width);
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
		
    }
}