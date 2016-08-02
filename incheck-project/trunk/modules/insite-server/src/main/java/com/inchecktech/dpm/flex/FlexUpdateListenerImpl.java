package com.inchecktech.dpm.flex;

import com.inchecktech.dpm.beans.ICNode;

import flex.data.DataServiceTransaction;

public class FlexUpdateListenerImpl implements UpdateListener {
	
	public void updatedNode(ICNode o) {
		// TODO Auto-generated method stub
		try{
			DataServiceTransaction trans=DataServiceTransaction.getCurrentDataServiceTransaction();
			if(trans==null){
				trans=DataServiceTransaction.begin(false);
			}
			String fchanged[]={"state"};
			trans.updateItem("channels",o, null,null);
			trans.commit();
			System.out.println("updated "+o);
		}catch(Throwable e){
			e.printStackTrace();
			e.printStackTrace(System.out);
		}
		
	}

}
