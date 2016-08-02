package com.slava.tests.workspace_save;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ExtractInteger {

    public ExtractInteger() {
    }

    public static void main(String[] args) {
        String s = new String("Eric Mariacher 1965 AoxomoxoA 1967 Cowabunga 2009 ");
        Matcher matcher = Pattern.compile("\\d+").matcher(s);
        if(matcher.find()){
        int i = Integer.valueOf(matcher.group());
        System.out.println(i);
        }

    }

}
