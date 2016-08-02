package com.inchecktech.dpm.dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectInputStream;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.util.List;

import com.inchecktech.dpm.beans.ChartDataPoint;
import com.inchecktech.dpm.beans.FunctionDataVO;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.utils.Logger;


public class ProcessedDataCacher {

	public static final String ACC_DATA = "_accData";
	public static final String VEL_DATA = "_velData";
	public static final String EXPONENTIAL = "_exp";
	public static final String LINEAR = "_lin";
	public static final String PEACK_HOLD = "_peak";
	
	private static final Logger logger = new Logger(ProcessedDataCacher.class);
	private static String baseDir=System.getProperty("java.io.tmpdir");
	private static int charsPerLevel=4;
	
	public static void saveProcessedData(ProcessedData pd) throws IOException{
		File dest=getFileForStoring(pd.getSampleId());
		logger.debug(" saving to "+dest);
		ObjectOutput oo = new ObjectOutputStream(new FileOutputStream(dest));
		oo.writeObject(pd);
		oo.close();
	}
	
	public static void saveProcessedData(List<ChartDataPoint> data, String fileName)
			throws IOException {
		File dest = null;
		if (data != null) {
			// save acceleration data
			if (data != null) {
				dest = getFileForStoring(fileName);
				ObjectOutput oo = new ObjectOutputStream(new FileOutputStream(
						dest));
				oo.writeObject(data);
				oo.close();
			}
		}
		if (dest != null) {
			logger.debug(" saving to " + dest);
		} else {
			logger.error("Error acceleration data Cache saving");
		}
	}

	
    @SuppressWarnings("unchecked")
    public static List<ChartDataPoint> loadAveragesFromCache(String id) throws Throwable {
	List<ChartDataPoint> result = null;
	File src = getFileForLoading(id);
	logger.debug(" about to load from  " + src);
	try {
	    ObjectInput oi = new ObjectInputStream(new FileInputStream(src));
	    result = (List<ChartDataPoint>) oi.readObject();
	    oi.close();
	} catch (FileNotFoundException e) {
	    logger.error(ProcessedDataCacher.class.getCanonicalName() + " file:" + src + ": has not been found");
	}
	return result;

    }

	public static ProcessedData loadFromCache(String id) throws Throwable{
		ProcessedData procD = null;
		File src=getFileForLoading(id);
		logger.debug(" about to load from  "+src);
		try{
		ObjectInput oi = new ObjectInputStream(new FileInputStream(src));
		procD =(ProcessedData) oi.readObject();
		oi.close();
		}catch (FileNotFoundException e) {
			logger.error(ProcessedDataCacher.class.getCanonicalName() + " file:" + src + ": has not been found");
		}
		return procD;
	}
	
	
	private static File getFileForStoring(String id){
		
		String path=baseDir;
		int full=id.length()/charsPerLevel;
		int rem=id.length()%charsPerLevel;
		for(int i=0;i<full*charsPerLevel;i=i+charsPerLevel){
			path+=File.separator+(id.substring(i,i+charsPerLevel));
			
			
		}
		if(rem>0){
			path+=File.separator+(id.substring(id.length()-rem, id.length()));
			
		}
		
		
		File dir=new File(path);
		dir.mkdirs();
		File f=new File(path+File.separator+id+".ser");
		try {
			
			f.createNewFile();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return f;
		
	}
	
	private static File getFileForLoading(String id){
		
		String path=baseDir;
		int full=id.length()/charsPerLevel;
		int rem=id.length()%charsPerLevel;
		for(int i=0;i<full*charsPerLevel;i=i+charsPerLevel){
			path+=File.separator+(id.substring(i,i+charsPerLevel));
			
			
		}
		if(rem>0){
			path+=File.separator+(id.substring(id.length()-rem, id.length()));
			
		}
		
		
		File f=new File(path+File.separator+id+".ser");
		return f;
		
	}
}
