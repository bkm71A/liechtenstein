package com.incheck.common
{
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	
	public class HTTPUtil
	{

	    public function HTTPUtil()
	    {
	        super();
	    }
	    
	       public static function getUrl():String
	    {
	    	return ExternalInterface.call("window.location.href.toString");
	    }
	    
	    public static function getHostName():String
	    {
	    	return ExternalInterface.call("window.location.hostname.toString");
	    }
	    
	    public static function getProtocol():String
	    {
	    	return ExternalInterface.call("window.location.protocol.toString");
	    } 
	    
	    public static function getPort():String
	    {
	    	return ExternalInterface.call("window.location.port.toString");
	    }
	    
	    public static function getContext():String
	    {
	    	return ExternalInterface.call("window.location.pathname.toString");
	    }
	    
	    
	    public static function getParameterValue(key:String):String
	    { 
	    	var value:String;
	    	var uparam:String = ExternalInterface.call("window.location.search.toString");
	    	
	    	if(uparam==null)
	    	{
		    	return null;
		    }
		    var paramArray:ArrayCollection = new ArrayCollection(uparam.split('&'));
		    for(var x:int=0; x<paramArray.length; x++)
		    {
		    	var p:String = paramArray.getItemAt(x) as String;
		    	if(p.indexOf(key + '=')>-1)
		    	{
		    		value = (p.replace((key + '='), '')).replace('?','');
		    		x=paramArray.length;
		    	}
		    }
		    
		    return value;
	    }
	}
}