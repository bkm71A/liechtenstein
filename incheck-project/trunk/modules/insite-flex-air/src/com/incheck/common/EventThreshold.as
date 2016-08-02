package com.incheck.common {
	import mx.collections.ArrayCollection;
	
[Bindable]	
public class EventThreshold {

    private var _id : Number;
    private var _parameter : String;
    private var _type : String;
    private var _band : Band;
    private var _severity : Severity;
    private var _value : Number;
    private var _mes : String;
	private var _deliveryList : ArrayCollection;
    private var _bandId : Number;

    public function EventThreshold(id : Number, parameter : String, band : Band, type : String, severity : Severity, value : Number, mes : String, delList : ArrayCollection) {
        _id = id;
        _parameter = parameter;
        _band = band;
        _type = type;
        _severity = severity;
        _value = value;
        _mes = mes;
		_deliveryList = delList;
    }


    public function get id():Number {
        return _id;
    }

    public function set id(value:Number):void {
        _id = value;
    }

    public function get parameter():String {
        return _parameter;
    }

    public function set parameter(value:String):void {
        _parameter = value;
    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }

    public function get band():Band {
        return _band;
    }

    public function set band(value:Band):void {
        _band = value;
    }

    public function get severity():Severity {
        return _severity;
    }

    public function set severity(value:Severity):void {
        _severity = value;
    }

    public function get value():Number {
        return _value;
    }

    public function set value(value:Number):void {
        _value = value;
    }

    public function get mes():String {
        return _mes;
    }

    public function set mes(value:String):void {
        _mes = value;
    }
	
	public function get deliveryList():ArrayCollection {
		return _deliveryList;
	}
	
	public function set deliveryList(value:ArrayCollection):void {
		_deliveryList = value;
	}

    public function get bandId():Number {
        return _bandId;
    }

    public function set bandId(value:Number):void {
        _bandId = value;
    }
}
}