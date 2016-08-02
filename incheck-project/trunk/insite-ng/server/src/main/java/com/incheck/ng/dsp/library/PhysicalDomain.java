package com.incheck.ng.dsp.library;

/**
 * Enum for all physical domains the system will operate in.
 * <p>
 * 
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>07/09/2008 Taras Dobrovolsky Initial release
 *         </ul>
 */
public enum PhysicalDomain {

    Acceleration("Acc", "Acceleration", "g"),
    Velocity("Vel", "Velocity", "in/s"),
    Displacement("Dis", "Displacement", "mil"),
    Frequency("Freq", "Frequency", "Hz"),
    Time("Time", "Time", "s"),
    Temperature("Temp", "Temperature", "C");

    private String abbr;
    private String descr;
    private String defaultUnit;

    PhysicalDomain(String abbr, String descr, String defaultUnit) {
        this.abbr = abbr;
        this.descr = descr;
        this.defaultUnit = defaultUnit;
    }

    public String abbr() {
        return abbr;
    }

    public String descr() {
        return descr;
    }

    public String defaultUnit() {
        return defaultUnit;
    }
}
