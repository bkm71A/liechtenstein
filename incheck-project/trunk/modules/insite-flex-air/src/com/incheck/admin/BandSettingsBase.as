package com.incheck.admin
{
	import com.incheck.IncheckModel;
	import com.incheck.admin.events.BandSettingsEvent;
	import com.incheck.common.Band;
	import com.incheck.common.BandFrequencyCalculation;
	import com.incheck.common.ICNode;
	import com.incheck.common.Unit;
	import com.incheck.components.RightNavigator;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.effects.easing.Back;
	import mx.formatters.NumberFormatter;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class BandSettingsBase extends Canvas
	{
		
		protected static const presetBands : Array = [
			{id : 1, name : "Overall"},
			{id : 2, name : "1x"},
			{id : 3, name : "2x"},
			{id : 4, name : "3x"},
			{id : 5, name : "Sub-1x"},
			{id : 6, name : "4x-9x"},
			{id : 7, name : "10x-30x"},
			{id : 8, name : "30x-60x"}
		];
		
		[Bindable]
		protected var enableSave : Boolean;
		
		[Bindable]
		protected var selectedNode:ICNode;
		
		[Bindable]
		protected var dsm:ArrayCollection;
		
		[Bindable]
		protected var bands:ArrayCollection;
		
		[Bindable]
		protected var startFr : String = "";
		
		[Bindable]
		protected var endFr : String = "";
		
		protected var overallEndFrequency : Number;
		
		[Bindable]
		protected var defaultBandConstant : String = "0.1";
		
		private var numberFormatter : NumberFormatter;
		
		public function BandSettingsBase() {
			super();
			numberFormatter = new NumberFormatter();
			numberFormatter.precision = 2;
		}
		
		protected function create():void {
			BindingUtils.bindSetter(selectedNodeChanged, IncheckModel.instance(), "selectedNode");
		}
		
		private function selectedNodeChanged(node:ICNode):void {
			if (IncheckModel.instance().right)
			{	
				if ((IncheckModel.instance().right as RightNavigator).settingsNav != null && IncheckModel.instance().right.settingsNav.selectedIndex == 1) {
					if (null != node) {
						if (node.type == "Channel") {
							dsm = new ArrayCollection();
							selectedNode = node;
							getDataSources(node.channelid);
						}
					}
				}
			}
		}
		
		protected function tryCalculateFrequencies(index : uint, speed : String, constant : String) : void {
			if (speed && constant) {
				calculateFrequencies(presetBands[index].id, Number(speed), Number(constant));
				enableSave = !bandIsUsed(presetBands[index].id) && startFr && endFr;
			} else {
				startFr = "";
				endFr = "";
				enableSave = false;
			}
		}
		
		private function bandIsUsed(presetBandId : uint) : Boolean {
			for each (var band : Band in bands) {
				if (band.band && band.band.id == presetBandId) {
					return true;
				}
			}
			return false;
		}
		
		private function calculateFrequencies(id : uint, speed : Number, constant : Number) : void {
			if (id == 1) {
				startFr = "0";
				endFr = overallEndFrequency.toString();
			} else {
				var result : Array = BandFrequencyCalculation.calculateFrequency(id, speed, constant);
				startFr = numberFormatter.format(result[0]);
				endFr = numberFormatter.format(result[1]);
			}
		}
			
		
		protected function addBand(index : uint, speed : String, constant : String):void {
			
//			// TODO: change it!!!!!!!!!!!!!!!!!!!!!!!! 
//			
//			var band : Band = new Band(1);
//			band.band = presetBands[index];
//			band.startFrequency = Number(startFr);
//			band.endFrequency = Number(endFr);
//			band.rotationSpeed = Number(speed);
//			band.constant = Number(constant);
//			
//			bands.addItem(band);
//			clearForm();
			
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(FaultEvent.FAULT, faultHandler);
			ro.createBandForChannel(presetBands[index].name, presetBands[index].id, Number(startFr), Number(endFr), selectedNode.channelid);
			getDataSources(selectedNode.channelid);
		}
		
		private function faultHandler(fault:FaultEvent):void {
			Alert.show("Fault=" + fault);
		}
		
		private function getDataSources(chanId:Number):void {
			getBands();
			getConfigItems(chanId);
			clearForm();
		}
		
		private function getBands():void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, this.getBandCallBack);
			ro.addEventListener(FaultEvent.FAULT, this.errorCallBack);
			ro.getBandsForChannel(selectedNode.channelid);
		}
		
		private function getBandCallBack(event:ResultEvent):void {
			bands = parseBands(event.result as ArrayCollection);
		}
		
		private function errorCallBack(event:FaultEvent):void {
			trace("Error getting band");
		}
		
		private function getConfigItems(chanId:Number):void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, getConfigCallBack);
			ro.getSpectrumAnalysisConfig(chanId);	
		}
		
		private function getConfigCallBack(event:ResultEvent):void {
			var serverData:ArrayCollection = event.result as ArrayCollection;	
			for each (var eachOne:Object in serverData) {
				if (eachOne.current) {
					overallEndFrequency = eachOne.analysisBandwidth as Number;
				}
			}
			recalculate();
		}
		
		public function dataLabel(item:Object, column:AdvancedDataGridColumn):String{
			if (item[column.dataField]) {
				return item[column.dataField].name;
			} else {
				return "";
			}
		}
		
		public function hzLabel(item : Object, column:AdvancedDataGridColumn):String {
			return item[column.dataField] + " Hz";
		}
		
		protected function recalculate():void {
			
		}
		
		protected function clearForm():void {
			startFr = "";
			endFr = "";
		}
		
		protected function onDeleteBand(event : BandSettingsEvent):void {
			
//			// TODO: change it!!!!!!!!!!!!!!!!!!!!!!!!
//			
//			var band : Band = event.band;
//			bands.removeItemAt(bands.getItemIndex(band));
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(FaultEvent.FAULT, faultHandler);
			ro.deleteBandForChannel(event.band.id, selectedNode.channelid);
			getDataSources(selectedNode.channelid);
		}
		
		private function parseBands(source : ArrayCollection) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			
			for each (var obj : Object in source) {
				var band : Band = new Band(obj.bandId);
				band.endFrequency = obj.endFreq;
				band.startFrequency = obj.startFreq;
				band.band = presetBands[obj.bandCoefficient - 1];
				result.addItem(band);
			}
			
			return result;
		}
	}
}