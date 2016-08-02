package com.slava.java_class_usage;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public class JavaClassUsageAnalyser {

    final private Set<String> nonFoundClasses = new TreeSet<String>();
    final private String OUT_ROOT = "C:/dev/ubs/RFC/unused-java-classes/class-lists/";
    public JavaClassUsageAnalyser() {
    }

    public static void main(String[] args) throws IOException {
        JavaClassUsageAnalyser analyser = new JavaClassUsageAnalyser();
        analyser.run();
    }

    private void run() throws IOException {
        long start = System.currentTimeMillis();
        JavaFileScanner scanner = new JavaFileScanner();
        scanner.scanFiles(new File("C:/dev/svnroot/skc/trunk/"));
        long middle = System.currentTimeMillis();
        System.out.println("Scanning done in " + (middle - start) + " milliseconds");
        reportDuplicatedShortClassNames(scanner.getClassInfoList());
        Map<String, JavaClassInfo> results = getResultsMap(scanner.getClassInfoList());
        printSetToFile(new TreeSet<String>(results.keySet()), OUT_ROOT + "all_scanned_classes.txt","");
//        long end = System.currentTimeMillis();
//        System.out.println("Done in " + (end - middle) + " milliseconds");
//        while (analyser.usageAnalyse(results)) {
//        }
//        analyser.reportResults(results,scanner.getUsedClasses());     
    }
    
    private void reportDuplicatedShortClassNames(List<JavaClassInfo> classInfoList) {
        Map<String,List<JavaClassInfo>> shortClasses = new HashMap<String,List<JavaClassInfo>>();
        for (JavaClassInfo javaClassInfo : classInfoList) {
            String className = javaClassInfo.getClassName();
            String shortName = Utils.shortNameFromFullName(className);
            if (shortClasses.get(shortName)==null) {
                shortClasses.put(shortName, new ArrayList<JavaClassInfo>());
            }
            shortClasses.get(shortName).add(javaClassInfo);
        }
        for(String shortClassName: shortClasses.keySet()){
         if(shortClasses.get(shortClassName).size()>1)   {
             System.err.println("Duplicated Short : "+ shortClassName+ " ; total = "+shortClasses.get(shortClassName).size());
             for (JavaClassInfo javaClassInfo:shortClasses.get(shortClassName)){
                 System.err.println("    "+javaClassInfo.getClassName() + " -> " + javaClassInfo.getFileName());
             }
         }
        }
//        System.err.println("Duplicated Short : "+ shortClasses.get(shortName)+ "\r\n"+javaClassInfo);
//    } else {
//        shortClasses.put(shortName, javaClassInfo);
//    }
        
    }
    
    private void reportResults(Map<String, JavaClassInfo> results,Set<String> usedClasses) {
        System.out.println("Used classes size = " + usedClasses.size());
        Set<String> allClassesSet = results.keySet();
        allClassesSet.removeAll(usedClasses);
        printSet(nonFoundClasses,"NON FOUND CLASSES : ");
        printSet(allClassesSet,"NON USED CLASSES");
    }

    private static void printSet(Set<String> set, String title) {
        System.out.println(title);
        for (String string : set) {
            System.out.println("    " + string);
        }
    }

    private void printSetToFile(Set<String> set, String fileName,String prefix) {
        try {
            PrintWriter out = new PrintWriter(new FileWriter(fileName));
            for (String string : set) {
                out.println(prefix + string);
            }
            out.close();
        } catch (IOException e) {
            System.out.println(e);
        }
    }
    
//    private boolean usageAnalyse(Map<String, JavaClassInfo> classMap) {
//        int sizeBefore = usedClasses.size();
//        for (String className : usedClasses) {
//            JavaClassInfo classInfo = classMap.get(className);
//            if (classInfo == null) {
//                if (!className.endsWith(".*") && !className.endsWith("Test") && !className.endsWith("Tests")) {
//                    nonFoundClasses.add(className);
//                }
//            } else {
//                classInfo.setIsUsed(Boolean.TRUE);
//            }
//        }
//        Set<String> classesSet = classMap.keySet();
//        for (String className2 : classesSet) {
//            JavaClassInfo info = classMap.get(className2);
//            if (Boolean.TRUE.equals(info.getIsUsed())) {
//                usedClasses.addAll(info.getImports());
//            }
//        }
//        int sizeAfter = usedClasses.size();
//        System.out.println(String.format("NEXT usageAnalyse Iteration, before=%d; after=%d", sizeBefore, sizeAfter));
//        return sizeAfter > sizeBefore;
//    }

    private Map<String, JavaClassInfo> getResultsMap(List<JavaClassInfo> classInfoList) {
        System.out.println("Total classes = " + classInfoList.size());
        Map<String, JavaClassInfo> classInfoMap = new HashMap<String, JavaClassInfo>();
        for (JavaClassInfo javaClassInfo : classInfoList) {
            String className = javaClassInfo.getClassName();
            if (classInfoMap.get(className) != null) {
                System.err.println("Duplicated class 1 :" + javaClassInfo.toString());
                System.err.println("Duplicated class 2 :" + classInfoMap.get(className));
            } else {
                classInfoMap.put(className, javaClassInfo);
            }
        }
        return classInfoMap;
    }
}
