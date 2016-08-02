package com.slava.java_class_usage;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class JavaFileParser {

    private static final String PACKAGE_REGEX = "^\\s*package\\s*\\w.*";
    private static final String IMPORT_REGEX = "^\\s*import\\s*.*";
    private static final String FILTER_PACKAGE = "com.ubs.swiskey";

    public JavaFileParser() {
    }

    public JavaClassInfo parseJavaFile(File javaFile) throws IOException {
        JavaClassInfo classInfo = new JavaClassInfo();
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(javaFile));
            classInfo.setFileName(javaFile.getAbsolutePath());
            String bareClassName = javaFile.getName().replace(".java", "");
            String line = null;
            boolean exit = false;
            // repeat until all lines is read
            while (!exit && (line = reader.readLine()) != null) {
                if (line.matches(PACKAGE_REGEX)) {
                    processPackage(line, classInfo, bareClassName);
                }
                if (line.matches(IMPORT_REGEX)) {
                    processImports(line, classInfo, FILTER_PACKAGE);
                }
                if (line.indexOf('{') >= 0) {
                    exit = true;
                }
            }
            if (classInfo.getClassName() == null) {
                // no package
                classInfo.setClassName(bareClassName);
            }
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                System.err.println(e);
            }
        }
        return classInfo;
    }

    private void processPackage(String line, JavaClassInfo classInfo, String shortClass) {
        String packageStr = line.replace("package", "").replace(";", "").replace(" ", "");
        classInfo.setClassName(packageStr + "." + shortClass);
    }

    private void processImports(String line, JavaClassInfo classInfo, String filterPackage) {
        String className = line.replace("import", "").replace(";", "").replace(" ", "");
        if (className.startsWith(filterPackage)) {
            classInfo.addImport(className);
        }
    }
}
