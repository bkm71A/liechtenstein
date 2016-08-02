package com.slava.java_class_usage;

import java.io.IOException;

public class Utils {
    public static String shortNameFromFullName(String fullName) {
        String split[] = fullName.split("[.]");
        return split[split.length - 1];
    }
    
    public static void main(String[] args) throws IOException {
        System.out.println(shortNameFromFullName(""));
        System.out.println(shortNameFromFullName("com.slava.java_class_usage.Utils"));
        System.out.println(shortNameFromFullName("com.slava.java_class_usage.*"));  
        System.out.println(shortNameFromFullName("com.slava.java_class_usage."));
        System.out.println(shortNameFromFullName("com.slava.java_class_usage"));         
    }
}
