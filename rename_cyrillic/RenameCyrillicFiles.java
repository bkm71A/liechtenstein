package com.slava.util;

import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class RenameCyrillicFiles {
    protected static final Map<Integer,String> unicode2Latinic;
    static {
      Map<Integer,String> tmp = new HashMap<Integer,String>();
      tmp.put(new Integer(1025),"Io");
      tmp.put(new Integer(1026),"J");
      tmp.put(new Integer(1027),"G");
      tmp.put(new Integer(1028),"E");
      tmp.put(new Integer(1029),"Dj");
      tmp.put(new Integer(1030),"I");
      tmp.put(new Integer(1031),"Yi");
      tmp.put(new Integer(1032),"E");
      tmp.put(new Integer(1033),"L");
      tmp.put(new Integer(1034),"N");
      tmp.put(new Integer(1035),"Tch");
      tmp.put(new Integer(1036),"K");
      tmp.put(new Integer(1037),"I");
      tmp.put(new Integer(1038),"U");
      tmp.put(new Integer(1039),"Dj");
      tmp.put(new Integer(1040),"A");
      tmp.put(new Integer(1041),"B");
      tmp.put(new Integer(1042),"V");
      tmp.put(new Integer(1043),"G");
      tmp.put(new Integer(1044),"D");
      tmp.put(new Integer(1045),"I");
      tmp.put(new Integer(1046),"J");
      tmp.put(new Integer(1047),"Z");
      tmp.put(new Integer(1048),"I");
      tmp.put(new Integer(1049),"I");
      tmp.put(new Integer(1050),"K");
      tmp.put(new Integer(1051),"L");
      tmp.put(new Integer(1052),"M");
      tmp.put(new Integer(1053),"N");
      tmp.put(new Integer(1054),"O");
      tmp.put(new Integer(1055),"P");
      tmp.put(new Integer(1056),"R");
      tmp.put(new Integer(1057),"S");
      tmp.put(new Integer(1058),"T");
      tmp.put(new Integer(1059),"U");
      tmp.put(new Integer(1060),"F");
      tmp.put(new Integer(1061),"H");
      tmp.put(new Integer(1062),"Z");
      tmp.put(new Integer(1063),"Ch");
      tmp.put(new Integer(1064),"Sh");
      tmp.put(new Integer(1065),"Shch");
      tmp.put(new Integer(1066),"'");
      tmp.put(new Integer(1067),"'");
      tmp.put(new Integer(1068),"'");
      tmp.put(new Integer(1069),"E");
      tmp.put(new Integer(1070),"Yu");
      tmp.put(new Integer(1071),"Ya");
      tmp.put(new Integer(1072),"a");
      tmp.put(new Integer(1073),"b");
      tmp.put(new Integer(1074),"v");
      tmp.put(new Integer(1075),"g");
      tmp.put(new Integer(1076),"d");
      tmp.put(new Integer(1077),"e");
      tmp.put(new Integer(1078),"j");
      tmp.put(new Integer(1079),"z");
      tmp.put(new Integer(1080),"i");
      tmp.put(new Integer(1081),"i");
      tmp.put(new Integer(1082),"k");
      tmp.put(new Integer(1083),"l");
      tmp.put(new Integer(1084),"m");
      tmp.put(new Integer(1085),"n");
      tmp.put(new Integer(1086),"o");
      tmp.put(new Integer(1087),"p");
      tmp.put(new Integer(1088),"r");
      tmp.put(new Integer(1089),"s");
      tmp.put(new Integer(1090),"t");
      tmp.put(new Integer(1091),"u");
      tmp.put(new Integer(1092),"f");
      tmp.put(new Integer(1093),"h");
      tmp.put(new Integer(1094),"ts");
      tmp.put(new Integer(1095),"ch");
      tmp.put(new Integer(1096),"sh");
      tmp.put(new Integer(1097),"shch");
      tmp.put(new Integer(1098),"'");
      tmp.put(new Integer(1099),"'");
      tmp.put(new Integer(1100),"'");
      tmp.put(new Integer(1101),"e");
      tmp.put(new Integer(1102),"yu");
      tmp.put(new Integer(1103),"ya");
      tmp.put(new Integer(1104),"i");
      tmp.put(new Integer(1105),"yo");
      tmp.put(new Integer(1106),"dj");
      tmp.put(new Integer(1107),"g");
      tmp.put(new Integer(1108),"e");
      tmp.put(new Integer(1109),"s");
      tmp.put(new Integer(1110),"i");
      tmp.put(new Integer(1111),"i");
      tmp.put(new Integer(1112),"j");
      tmp.put(new Integer(1113),"l");
      tmp.put(new Integer(1114),"n");
      tmp.put(new Integer(1115),"ts");
      tmp.put(new Integer(1116),"k");
      tmp.put(new Integer(1117),"i");
      tmp.put(new Integer(1118),"u");
      tmp.put(new Integer(1119),"dz");
      tmp.put(new Integer(1120),"O");
      tmp.put(new Integer(1121),"o");
      tmp.put(new Integer(1122),"YAT");
      tmp.put(new Integer(1123),"ya");
      tmp.put(new Integer(1124),"E");
      tmp.put(new Integer(1125),"e");
      tmp.put(new Integer(1126),"Yu");
      tmp.put(new Integer(1127),"yu");
      tmp.put(new Integer(1128),"Yu");
      tmp.put(new Integer(1129),"yu");
      unicode2Latinic = Collections.unmodifiableMap(tmp);
    }

    private String latinize(String src) {
        StringBuffer sb = new StringBuffer();
        for (int j = 0; j < src.length(); j++) {
            String replacement = (String) unicode2Latinic.get(new Integer((int) src.charAt(j)));
            sb.append(replacement == null ? src.charAt(j) : replacement);
        }
        return sb.toString();
    }
    
    public static void main(String[] args) throws Exception {
        new RenameCyrillicFiles().processFolder("E:/cd_root/media/music");
    }
    
    private void processFolder(String folderName) throws Exception {
        File rootDir = new File(folderName);
        if (rootDir.isDirectory()) {
            File[] files = rootDir.listFiles();
            for (int j = 0; j < files.length; j++) {
                if (files[j].isDirectory()) {
                    processFolder(files[j].getCanonicalPath());
                }
                String name = files[j].getName();
                String newName = latinize(name);
                if (!name.equalsIgnoreCase(newName)) {
                    String newCanonicalName = files[j].getParent() + "\\" + newName;
                    files[j].renameTo(new File(newCanonicalName));
                    System.out.println("File Renamed : " + newCanonicalName);
                }
            }
        }
    }
}
