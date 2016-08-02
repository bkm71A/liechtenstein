package com.slava.java_class_usage;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class JavaFileScanner {

    final private List<JavaClassInfo> classInfoList = new ArrayList<JavaClassInfo>();
    final private Set<String> usedClasses = new TreeSet<String>();
    final private JavaFileParser parser = new JavaFileParser();
    
    public JavaFileScanner() {
    }

    public void scanFiles(File file) throws IOException {
        final File[] children = file.listFiles(new FileFilter() {
            public boolean accept(File someFile) {
                return someFile.isDirectory() || someFile.getName().endsWith(".java");
            }
        });
        if (children != null) {
            for (File child : children) {
                if (child.isDirectory()) {
                    scanFiles(child);
                } else {
                    JavaClassInfo info = parser.parseJavaFile(child);
                    if (child.getName().endsWith("_jsp.java")) {
                        usedClasses.addAll(info.getImports());
                    } else {
                        classInfoList.add(info);
                    }
                }
            }
        }
    }

    public List<JavaClassInfo> getClassInfoList() {
        return classInfoList;
    }

    public Set<String> getUsedClasses() {
        return usedClasses;
    }
}
