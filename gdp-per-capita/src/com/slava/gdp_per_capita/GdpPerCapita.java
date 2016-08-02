package com.slava.gdp_per_capita;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Properties;

public class GdpPerCapita {

//    private final static String BASE_URL = "http://www.nationmaster.com/graph/eco_gdp_percap-economy-gdp-per-capita&date=";
    private final static String BASE_URL = "http://75.125.249.244/graph/eco_gdp_percap-economy-gdp-per-capita&date=";
    public GdpPerCapita() {
    }

    /**
     * @param args
     * @throws Exception 
     */
    public static void main(String[] args) {
        // http://www.nationmaster.com/graph/eco_gdp_percap-economy-gdp-per-capita&date=1988
        // http://www.nationmaster.com/country/up-ukraine/eco-economy
        // Ukraine: United States Kazakhstan: China: 2006 1985 1960
        GdpPerCapita gdp = new GdpPerCapita();
        try {
            gdp.run();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    private void run() throws Exception {
        Properties props = System.getProperties();
        props.put("http.proxyHost", "inetproxy3");
        props.put("http.proxyPort", "808");
        props.put("http.proxyUser", "kovalesv");
        props.put("http.proxyPassword", "2718235aA");
        
        
//        Authenticator.setDefault(new ProxyAuthenticator());
        
        BufferedReader reader = readYear(2005);
        String line = reader.readLine();
        while (line != null) {
            if(line.indexOf("United States")>=0){
            System.out.println(line);
            }
            line = reader.readLine();
        }
    }

    private static BufferedReader readYear(int year) throws Exception {
        return read(BASE_URL+year);
    }

    private static BufferedReader read(String url) throws Exception {
        return new BufferedReader(new InputStreamReader(new URL(url).openStream()));
    }
}


