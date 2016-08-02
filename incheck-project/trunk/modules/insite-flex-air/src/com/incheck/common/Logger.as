package com.incheck.common
{
    public class Logger
    {
        static public function log(classObject:Object, text:String):void {
            var date:Date = new Date();
            trace(date.toString() + "  " + text); 
        }
    }
}