package com.incheck.admin
{
	import com.incheck.Constants;
	import com.incheck.IncheckModel;
	import com.incheck.admin.events.DeliverySettingsEvent;
	import com.incheck.common.Band;
	import com.incheck.common.Delivery;
	import com.incheck.common.EventThreshold;
	import com.incheck.common.ICNode;
	import com.incheck.common.Severity;
	import com.incheck.components.RightNavigator;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.ListEvent;
	import mx.events.ListEventReason;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class DeliverySettingsBase extends Canvas
	{
		[Bindable]
		protected var selectedNode:ICNode;
		
		[Bindable]
		protected var selectedThreshold:EventThreshold;
		
		[Bindable]
		protected var selectedDelivery:Delivery;

		[Bindable]
		protected var dsm:ArrayCollection;
		
		[Bindable]
		protected var allowAddDeliveryPath:Boolean;
		
		[Bindable]
		protected var severity:ArrayCollection;
		[Bindable]
		protected var bands:Array;
		
		public function DeliverySettingsBase()
		{
			super();
		}
		
		protected function create():void {
			BindingUtils.bindSetter(selectedNodeChanged, IncheckModel.instance(), "selectedNode");
			populateCombobox();
		}
		
		private function populateCombobox():void {
			severity = new ArrayCollection();
			severity.addItem(new Severity(1, "Warning"));
			severity.addItem(new Severity(2, "Alarm"));
		}
		
		private function selectedNodeChanged(node:ICNode):void{
			if((IncheckModel.instance().right as RightNavigator).settingsNav != null && IncheckModel.instance().right.settingsNav.selectedIndex==1){
				if (null != node){ 
					if(node.type=="Channel"){
						dsm=new ArrayCollection();
						selectedNode=node;
						getDataSources(node.channelid);
					}
				}
			}
		}
		
		private function getDataSources(chanId:Number):void {
			getBands(chanId);
			getConfiguredEventresholds(chanId);
			clearForm();
		}
		
		
		private function getBands(channelId : int):void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, this.getBandCallBack);
			ro.getBandsForChannel(channelId);
		}
		
		private function getBandCallBack(event:ResultEvent):void {
			bands = parseBands(event.result as ArrayCollection);
			updateBands(bands);
		}
		
		protected function updateBands(newBands : Array):void {
		}
		
		protected function clearForm():void {
			selectedThreshold = null;
			selectedDelivery = null;
		}
		
		private function getConfiguredEventresholds(chanId:Number):void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(ResultEvent.RESULT, popResult);
			ro.addEventListener(FaultEvent.FAULT, faultHandler);
			ro.getEventThresholds(chanId);
		}
		
		private function popResult(results:ResultEvent):void {
			dsm = parseThresholds(results.result as ArrayCollection);
		}
		
		protected function configuredEventsGrid_itemClickHandler(event:ListEvent):void {
			selectedThreshold = dsm.getItemAt(event.rowIndex) as EventThreshold;
		}
		
		public function dataLabel(item:Object,column:AdvancedDataGridColumn):String{
			if (item[column.dataField]) {
				return item[column.dataField].name;
			} else {
				return "";
			}
		}
		
		public function valueLabel(item:Object,column:AdvancedDataGridColumn):String{
			var threshold:EventThreshold = item as EventThreshold;
			return threshold.value + " " + threshold.mes;
		}
		
		protected function addOrModifyDeliveryPath (deliveryName:String, deliveryAddress:String, deliveryNotes:String):void{
			if (selectedDelivery) {
				editDeliveryPath(selectedDelivery.id, deliveryAddress, deliveryNotes);
			} else {
				addDeliveryPath(deliveryName, deliveryAddress, deliveryNotes);
			}
		}
		
		protected function onEditDelivery(event : DeliverySettingsEvent) : void {
			selectedDelivery = event.delivery;
		}
		
		
		protected function onDeleteDelivery(event : DeliverySettingsEvent) : void {
			deleteDeliveryPath(event.delivery.id, String(selectedThreshold.id));
		}
		
		private function deleteDeliveryPath(deliveryId:int, thresholdId:String) : void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(FaultEvent.FAULT, faultHandler);
			ro.addEventListener(ResultEvent.RESULT, genericAlert);
			ro.deleteDeliveryPath(thresholdId, deliveryId);
			
			selectedNodeChanged(selectedNode);
		}

		private function editDeliveryPath(delId: int, email : String, notes : String) : void {
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(FaultEvent.FAULT, faultHandler);
			ro.addEventListener(ResultEvent.RESULT, genericAlert);
			ro.modifyDeliveryPath(delId, email, notes);
			
			selectedNodeChanged(selectedNode);
		}
		
		private function addDeliveryPath (deliveryName:String, deliveryAddress:String, deliveryNotes:String):void{
			var ro:RemoteObject = new RemoteObject("icNodes");
			ro.addEventListener(FaultEvent.FAULT, faultHandler);
			ro.addEventListener(ResultEvent.RESULT, genericAlert);
			ro.addDeliveryPath(selectedThreshold.id, deliveryName, deliveryAddress, deliveryNotes, 0, 0);
			
			selectedNodeChanged(selectedNode);
		}

		private function genericAlert(result:ResultEvent):void{
			Alert.show(result.result.message);
		}
		
		private function faultHandler(fault:FaultEvent):void{
			Alert.show("Fault=" + fault);
		}
		
		
		private function parseBands(source : ArrayCollection) : Array {
			var result : Array = new Array();
			
			for each (var obj : Object in source) {
				result.push(new Band(obj.bandId, obj.bandName));
			}
			
			return result;
		}
		
		
		private function parseThresholds(source : ArrayCollection) : ArrayCollection {
			var result : ArrayCollection = new ArrayCollection();
			
			for each (var obj : Object in source) {
				var par_type:String = obj.overall_tr_type;
				var paramter:String = par_type.indexOf("Vel") >= 0 ? Constants.VELOCITY : Constants.ACCELERATION;
				var type:String = par_type.indexOf("Peak") >= 0 ? Constants.PEAK : Constants.RMS;
				var sev : Severity = obj.severity == 1 ? severity[0] : severity[1];
				var unit:String = getUnit(paramter, obj.unit_id);
				var band : Band = getBand(obj.band_id);
				
				var deliveryPathList : ArrayCollection = new ArrayCollection();
				for each (var delObj : Object in obj.deliveryPathList) {
					deliveryPathList.addItem(new Delivery(delObj.deliveryId, delObj.deliveryName, delObj.deliveryAddress, delObj.deliveryNotes));
				}
				
				var threshold : EventThreshold = new EventThreshold(obj.event_tr_id, paramter, band, type, sev, obj.event_tr_upper_bound, unit, deliveryPathList);
				
				result.addItem(threshold);
			}
			return result;
		}
		
		private function getBand(bandId : int) : Band {
			for each (var band : Band in bands) {
				if (band.id == bandId) {
					return band;
				}
			}
			if (bands) {
				return bands[0]; 
			}
			return null;
		}
		
		private function getUnit(parameter:String, unitId:int) : String {
			if (unitId == 3) {
				if (parameter == Constants.VELOCITY) {
					return Constants.MEASUREMENT_LABEL_M_S;
				} else {
					return Constants.MEASUREMENT_LABEL_M_S_2;
				}
			}
			return Constants.MEASUREMENT[unitId];
		}
		
//		private function getUnitId(parameter:String, unit:String):int {
//			var ind : int = Constants.MEASUREMENT.indexOf(unit);
//			if (ind == -1) {
//				return 3;
//			}
//			return ind;
//		}
		
//		private function getOverallType(parameter:String, type:String):String {
//			var result:String;
//			if (parameter == Constants.VELOCITY) {
//				result = "Vel";
//			} else {
//				result = "Accel";
//			}		
//			if (type == Constants.PEAK) {
//				result += " Peak";
//			} else {
//				result += "_Rms";
//			}
//			return result;
//		}

	}
}