package com.incheck.common {
	
[Bindable]
public class Band {

	private var _id : int;
	private var _band : Object;
    private var _name : String;
    private var _rotationSpeed : Number;
    private var _constant : Number;
    private var _startFrequency : Number;
    private var _endFrequency : Number;

    public function Band(id: int, name : String = "") {
		_id = id;
		_name = name;
    }
	
	public function get id():int {
		return _id;
	}
	
	public function set id(value:int):void {
		_id = value;
	}
	
	public function get band():Object {
		return _band;
	}
	
	public function set band(value:Object):void {
		_band = value;
	}

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get rotationSpeed():Number {
        return _rotationSpeed;
    }

    public function set rotationSpeed(value:Number):void {
        _rotationSpeed = value;
    }

    public function get constant():Number {
        return _constant;
    }

    public function set constant(value:Number):void {
        _constant = value;
    }

    public function get startFrequency():Number {
        return _startFrequency;
    }

    public function set startFrequency(value:Number):void {
        _startFrequency = value;
    }

    public function get endFrequency():Number {
        return _endFrequency;
    }

    public function set endFrequency(value:Number):void {
        _endFrequency = value;
    }
}
}