package com.incheck.admin {
import com.incheck.Constants;
import com.incheck.IncheckModel;
import com.incheck.admin.events.ThresholdSettingsEvent;
import com.incheck.common.Band;
import com.incheck.common.EventThreshold;
import com.incheck.common.ICNode;
import com.incheck.common.Severity;
import com.incheck.components.RightNavigator;

import mx.binding.utils.BindingUtils;
import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.CollectionEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;

public class ThresholdSettingsBase extends Canvas {

    [Bindable]
    protected var selectedNode:ICNode;

    [Bindable]
    protected var dsm:ArrayCollection;

    [Bindable]
    protected var severity:ArrayCollection;
    [Bindable]
    protected var types:ArrayCollection;
    [Bindable]
    protected var parameters:ArrayCollection;
    [Bindable]
    protected var bands:ArrayCollection;
	[Bindable]
    protected var selectedThreshold : EventThreshold;

    public function ThresholdSettingsBase() {
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
		
		types = new ArrayCollection();
		types.addItem(Constants.PEAK);
		types.addItem(Constants.RMS);
		
		parameters = new ArrayCollection();
		parameters.addItem(Constants.VELOCITY);
		parameters.addItem(Constants.ACCELERATION);
    }
	
	private function getBands(channelId : int):void {
        if (bands) bands.removeAll();
		var ro:RemoteObject = new RemoteObject("icNodes");
		ro.addEventListener(ResultEvent.RESULT, this.getBandCallBack);
		ro.addEventListener(FaultEvent.FAULT, this.histError);
		ro.getBandsForChannel(channelId);
	}
	
	private function getBandCallBack(event:ResultEvent):void {
		bands = parseBands(event.result as ArrayCollection);
		updateBands(bands);
	}
	
	protected function updateBands(newBands : ArrayCollection):void {
        for each (var threshold : EventThreshold in dsm) {
            if (!threshold.band) {
                 threshold.band = getBand(threshold.bandId);
            }
        }
	}
	
	private function histError(event:FaultEvent):void {
		trace("Error getting band");
	}

    private function selectedNodeChanged(node:ICNode):void {
		if (IncheckModel.instance().right)
		{	
	        if ((IncheckModel.instance().right as RightNavigator).settingsNav != null && IncheckModel.instance().right.settingsNav.selectedIndex == 1) {
	            if (null != node) {
	                if (node.type == "Channel") {
	                    dsm = new ArrayCollection();
	                    if (bands) bands.removeAll();
	                    selectedNode = node;
	                    getDataSources(node.channelid);
	                }
	            }
	        }
        }
    }
	
	private function getDataSources(chanId:Number):void {
        getConfiguredEventresholds(chanId);
		getBands(chanId);
		clearForm();
    }

	protected function onDeleteThreshold(event:ThresholdSettingsEvent):void {
        deleteEventThreshold(event.eventThreshold.id);
    }

	protected function onEditThreshold(event:ThresholdSettingsEvent):void {
        selectedThreshold = event.eventThreshold;
		callLater(updateMes);
    }
	
	protected function updateMes():void {
		
	}

    private function popResult(results:ResultEvent):void {
		
		dsm = parseThresholds(results.result as ArrayCollection);
		
        //dsm = results.result as ArrayCollection;
    }

    private function getConfiguredEventresholds(chanId:Number):void {
        var ro:RemoteObject = new RemoteObject("icNodes");
        ro.addEventListener(ResultEvent.RESULT, popResult);
        ro.addEventListener(FaultEvent.FAULT, faultHandler);
        ro.getEventThresholds(chanId);
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

    protected function addOrModifyEventThreshold(channelId:String, parameter:String, band:Band, type:String, severity:Severity, value:String, measurement:String) : void {
		if (isDuplicateThreshold(selectedThreshold ? selectedThreshold.id : NaN, parameter, type, severity)) {
			Alert.show("Threshold with the same parameters already exists.");
			return;
		}
        if (!selectedThreshold) {
            addEventThreshold(channelId, parameter, band, type, severity, value, measurement);
        } else {
			updateThresholdValues(channelId, selectedThreshold.id, parameter, band, type, severity, value, measurement);
        }
		selectedThreshold = null;
    }
	
	private function isDuplicateThreshold(trId:int, parameter:String, type:String, severity:Severity):Boolean {
		for each (var tr:EventThreshold in dsm){
			if (tr.id != trId && tr.parameter == parameter && tr.type == type && tr.severity.value == severity.value) {
				return true;
			}
		}
		return false;
	}
	
	protected function clearForm():void {
		
	}

    protected function addEventThreshold(channelId:String, parameter:String, band:Band, type:String, severity:Severity, value:String, measurement:String):void {
        var overallType : String = getOverallType(parameter, type);
		var unitId : int = getUnitId(parameter, measurement);
 		var ro:RemoteObject = new RemoteObject("icNodes");
		ro.addEventListener(FaultEvent.FAULT, faultHandler);
		ro.addEventListener(ResultEvent.RESULT, genericAlert);
		ro.addEventThreshold(channelId, overallType, band.id, severity.value, value, unitId);
		getDataSources(selectedNode.channelid);
    }

    protected function updateThresholdValues(channelId:String, trId:int, parameter:String, band:Band, type:String, severity:Severity, value:String, measurement:String):void {
        var overallType : String = getOverallType(parameter, type);
		var unitId : int = getUnitId(parameter, measurement);
		var ro:RemoteObject = new RemoteObject("icNodes");
		ro.addEventListener(FaultEvent.FAULT, faultHandler);
		ro.addEventListener(ResultEvent.RESULT, genericAlert);
		ro.updateThresholdValue(channelId, trId, overallType, band.id, severity.value, value, unitId);
		getDataSources(selectedNode.channelid);
    }

    protected function deleteEventThreshold(eId:int):void {
	    var ro:RemoteObject = new RemoteObject("icNodes");
		ro.addEventListener(FaultEvent.FAULT, faultHandler);
		ro.addEventListener(ResultEvent.RESULT, genericAlert);
		ro.deleteEventTreshold(selectedNode.channelid,eId);
		getDataSources(selectedNode.channelid);
    }


    private function faultHandler(fault:FaultEvent):void {
        Alert.show("Fault=" + fault);
    }

    private function genericAlert(result:ResultEvent):void {
        Alert.show(result.result.message);
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
			
			var threshold : EventThreshold = new EventThreshold(obj.event_tr_id, paramter, band, type, sev, obj.event_tr_upper_bound, unit, null);
			threshold.bandId = obj.band_id;
			result.addItem(threshold);
		}
		return result;
	}
	
	private function parseBands(source : ArrayCollection) : ArrayCollection {
		var result : ArrayCollection = new ArrayCollection();

		for each (var obj : Object in source) {
			result.addItem(new Band(obj.bandId, obj.bandName));
		}
		
		return result;
	}
	
	private function getBand(bandId : int) : Band {
		for each (var band : Band in bands) {
			if (band.id == bandId) {
				return band;
			}
		}
		if (bands && bands.length) {
			return bands.getItemAt(0) as Band;
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
	
	private function getUnitId(parameter:String, unit:String):int {
		var ind : int = Constants.MEASUREMENT.indexOf(unit);
		if (ind == -1) {
			return 3;
		}
		return ind;
	}
	
	private function getOverallType(parameter:String, type:String):String {
		var result:String;
		if (parameter == Constants.VELOCITY) {
			result = "Vel";
		} else {
			result = "Accel";
		}		
		if (type == Constants.PEAK) {
			result += " Peak";
		} else {
			result += "_Rms";
		}
		return result;
	}
}
}