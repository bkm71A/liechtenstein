package com.slava.java_class_usage;

import java.util.Set;
import java.util.TreeSet;

public class JavaClassInfo {

    private String fileName;
    private String className;
    private Boolean isUsed;
    private Set<String> imports = new TreeSet<String>();

    public JavaClassInfo() {
    }
    
    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public void addImport(String className){
        imports.add(className);
    }

    @Override
    public String toString() {
        return "JavaClassInfo [fileName=" + fileName + ", className=" + className + ", imports=" + imports + "]";
    }

    public Boolean getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(Boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Set<String> getImports() {
        return imports;
    }
}
