package com.inchecktech.dpm.flex;


import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.inchecktech.dpm.beans.ICNode;
import com.inchecktech.dpm.dao.DataBucket;

import flex.data.assemblers.AbstractAssembler;
public class ICNodeAssembler extends AbstractAssembler {

	
	public Collection fill(List fillParameters)
    {

		if (fillParameters.size() == 0)
        {
			
        	//return DPMEngine.list4tree;
        	//return null;
        	return DataBucket.getICNodes();
        }else{
	        String queryName = (String) fillParameters.get(0);
	        if (queryName.equals("by-name")){
	            //return DataBucket.getICNodesByName((String) fillParameters.get(1));
	        	return null;
	        }
        }
        
        return super.fill(fillParameters); // throws a nice error
    }
	

	public void createItem(Object newItem)
	{
       
	}

	public void updateItem(Object newVersion, Object prevVersion, List changes)
	{		
		try
		{
			//dao.update((ICNode) newVersion);
		}
		catch (Exception e)
		{
            int nid = ((ICNode) newVersion).getId();
			System.err.println("*** DataSyncException when trying to update node id=" + nid );
			
		}
	}
	
	public void deleteItem(Object prevVersion)
	{		
		try
		{
			//dao.delete((ICNode) prevVersion);
		}
		catch (Exception e)
		{
            int id = ((ICNode) prevVersion).getId();
			System.err.println("*** Throwing DataSyncException when trying to delete node id=" + id);
			
		}
	}

	public Object getItem(Map uid)
	{
		try {
			//return DataBucket.getICNode(.toString());
			System.out.println("\n\n\ngetItem called \n\n\n");
			System.exit(2);
			return null;
			
			//return DPMEngine.list4tree.get(new Integer( uid.get("id").toString()));
			
			//return null;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	
}