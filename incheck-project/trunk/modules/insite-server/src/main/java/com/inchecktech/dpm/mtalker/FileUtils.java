package com.inchecktech.dpm.mtalker;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;

public class FileUtils{
  
  @SuppressWarnings("unchecked")
  public static File[] dirListByAscendingDate(File folder) {
    if (!folder.isDirectory()) {
      return null;
    }
    File files[] = folder.listFiles();
    Arrays.sort( files, new Comparator()
    {
      public int compare(final Object o1, final Object o2) {
        return new Long(((File)o1).lastModified()).compareTo
             (new Long(((File) o2).lastModified()));
      }
    }); 
    return files;
  }  
  
  @SuppressWarnings("unchecked")
  public static File[] dirListByDescendingDate(File folder) {
    if (!folder.isDirectory()) {
      return null;
    }
    File files[] = folder.listFiles();
    Arrays.sort( files, new Comparator()
    {
      public int compare(final Object o1, final Object o2) {
        return new Long(((File)o2).lastModified()).compareTo
             (new Long(((File) o1).lastModified()));
      }
    }); 
    return files;
  }
  
  @SuppressWarnings("unchecked")
  public static File[] dataFileListByAscendingDate(File folder) {
    if (!folder.isDirectory()) {
      return null;
    }
    
    FilenameFilter nameFilter = new FilenameFilter() {
        public boolean accept(File dir, String name) {
            return !name.endsWith("cntl");
        }
    };

    
    File files[] = folder.listFiles(nameFilter);
    Arrays.sort( files, new Comparator()
    {
      public int compare(final Object o1, final Object o2) {
        return new Long(((File)o1).lastModified()).compareTo
             (new Long(((File) o2).lastModified()));
      }
    }); 
    return files;
  }  
  
  /**
   * 
   * @param fileDir
   * @param fileName
   * @return true if the data file was found, copied and is ready to be read.
   * @throws IOException
   */
  public static boolean prepDataFile(String fileDir, String fileName) throws IOException {
      
      File dir = new File(fileDir);
      
      // get the oldest file in the directory
      File[] dataFiles = dataFileListByAscendingDate(dir);
      if ((dataFiles == null) || (dataFiles.length < 1)) {
          return false;  // no data files found
      }
      
      // check if control file exists, copy the oldest file, remove control file
      File control = new File( fileDir + "\\" + dataFiles[0].getName().substring( 0, dataFiles[0].getName().length() - 4 ) + ".cntl");
      if ( !control.exists() ) {
          return false; // control file has not been found - MTalker is still writing to it
      }
      
      dataFiles[0].renameTo( new File(fileDir + "\\" + fileName) );
      control.renameTo( new File(fileDir + "\\" + fileName.substring( 0, fileName.length() - 4 ) + ".cntl") );
      
      return true;
  }
  
}

