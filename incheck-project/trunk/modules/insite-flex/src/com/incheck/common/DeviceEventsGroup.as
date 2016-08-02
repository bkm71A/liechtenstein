package com.incheck.common
{
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.controls.List;

    public class DeviceEventsGroup
    {

        public static const CONNECT_EVENT_TYPE:String = "CON";

        public static const DISCONNECT_EVENT_TYPE:String = "DISCON";

        public var deviceName:String;

        public var lastConnectDate:Date;

        public var lastDisconnectDate:Date;

        private var eventTypeToDates:Dictionary; /** Event type to collection of event dates. */

        public function DeviceEventsGroup(deviceName:String)
        {
            this.deviceName = deviceName;
            eventTypeToDates = new Dictionary();
        }

        public function registerEvent(eventType:String, date:Date):void
        {
            if (eventType && date)
            {
                var dates:IList = eventTypeToDates[eventType] as IList;
                if (!dates)
                {
                    dates = new ArrayCollection();
                    eventTypeToDates[eventType] = dates;
                }
                if ((eventType == CONNECT_EVENT_TYPE) && (!lastConnectDate || (lastConnectDate < date)))
                {
                    lastConnectDate = date;
                }
                if ((eventType == DISCONNECT_EVENT_TYPE) && (!lastDisconnectDate || (lastDisconnectDate < date)))
                {
                    lastDisconnectDate = date;
                }
                dates.addItem(date);
            }
        }

        public function getEventDatesByEventType(eventType:String):IList
        {
            return (eventType ? eventTypeToDates[eventType] : null);
        }

        public function get active():Boolean
        {
            if (!lastConnectDate && !lastDisconnectDate)
            {
                return false;
            }
            if (!lastDisconnectDate && lastConnectDate)
            {
                return true;
            }
            if (lastDisconnectDate && !lastConnectDate)
            {
                return false;
            }
            return lastDisconnectDate < lastConnectDate;
        }
    }
}