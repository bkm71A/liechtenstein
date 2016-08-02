package com.incheck.common {
public class Severity {

    private var _value : uint;
    private var _description : String;

    public function Severity(value : uint, desc : String) {
        _value = value;
		_description = desc;
    }

    public function get value():uint {
        return _value;
    }
	
	public function get description() :String {
		return _description;
	}

    public function get name():String {
        return _value + " " + _description;
    }
}
}