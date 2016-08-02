package com.incheck.common
{
	// http://livedocs.adobe.com/flex/3/html/help.html?content=celleditor_8.html
	import com.incheck.IncheckModel;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.AdvancedDataGridEvent;
	import mx.rpc.remoting.RemoteObject;
	
	public class EventLogUtils
	{
		public function EventLogUtils()
		{
		}
	

	// need to disable editing on items that already checked.	
	public static function disableItems(grid:AdvancedDataGrid):void{
		
		var cols:Array = grid.columns;
		for each (var col:AdvancedDataGridColumn in cols){
			if (col.dataField == 'acked'){
				//see if the value is true
				//col.editable= false;
			}
			
		}
	}	
	
	public static function labelFuncUser(item:Object, item2:AdvancedDataGridColumn) : String
    {
       	if (item.ackuser){
    		item2.editable=false;
    		return item.ackuser.userName;
    	}else{
    		item2.editable=false;
    		return null;
    	}
    }
    
    public static function toggleAck():void{
    	
    }
    
//	public static function showItem(event:AdvancedDataGridEvent, grid:AdvancedDataGrid):void{
//		var colName:String = grid.columns[event.columnIndex].dataField;
//		if (colName == 'acked' || colName == "notes"){
//			var r:Object = event.itemRenderer.data;
//			var eId:int = event.itemRenderer.data.eventId;
//			var userName:String;
//			var userId:Number;
//			var a:Boolean = r.acked;
//			var notes:String = new String();
//			
//			//if (event.itemRenderer.data.ackuser == null){
//				
//				event.itemRenderer.data.ackuser = IncheckModel.instance().currentUser;
//			//}
//				notes = event.itemRenderer.data.notes;
//				event.itemRenderer.data.acked=true;
//				var ro:RemoteObject = new RemoteObject("icNodes");
//				ro.ackEvent(IncheckModel.instance().currentUser.userName,eId,notes);
//				
//				event.stopImmediatePropagation();
//				event.stopPropagation();
//				event.preventDefault();
//			
//			grid.invalidateDisplayList();
//			grid.invalidateList();
//			grid.validateNow();
//			grid.dataProvider.itemUpdated(event.itemRenderer);
//		}	
//	}
	
	public static function updateItem(item:Object):void {
		var eId:int = item.eventId;
		var userName:String;
		var userId:Number;
		var a:Boolean = item.acked;
		var notes:String = new String();
		
		//if (event.itemRenderer.data.ackuser == null){
		
		item.ackuser = IncheckModel.instance().currentUser;
		//}
		notes = item.notes;
		item.acked=true;
		var ro:RemoteObject = new RemoteObject("icNodes");
		ro.ackEvent(item.channelId, IncheckModel.instance().currentUser.userName,eId,notes);
//		
//		event.stopImmediatePropagation();
//		event.stopPropagation();
//		event.preventDefault();
		
//		grid.invalidateDisplayList();
//		grid.invalidateList();
//		grid.validateNow();
//		grid.dataProvider.itemUpdated(item);
	}

	}
}