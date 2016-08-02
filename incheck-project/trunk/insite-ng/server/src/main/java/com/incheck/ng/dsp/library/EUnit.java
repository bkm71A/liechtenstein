package com.incheck.ng.dsp.library;




/**
 * Enum representing an engineering unit and its properties for converting in other engineering units.
 * 
 * To add new engineering units simply add a new enum member with conversion factor and conversion offset.
 * For instance,
 *      F = C * 9/5 + 32
 *          9/5 (or 1.8) is the conversion factor from C to F
 *          32 is the conversion offset from C to F
 * <p>
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>07/12/2008 Taras Dobrovolsky Initial release
 *         </ul>
 */
public enum EUnit {

    // Acceleration
    AccG("g", 1.0, 0.0, PhysicalDomain.Acceleration), // g - DEFAULT INTERNAL SYSTEM UNIT
    AccMtrPerSec2("m/s\u00B2", 9.807, 0.0, PhysicalDomain.Acceleration), // m/s^2
    AccMmSec2("mm/s\u00B2", 9807.0, 0.0, PhysicalDomain.Acceleration), // mm/s^2
    AccInSec2("in/s\u00B2", 386.088583, 0.0, PhysicalDomain.Acceleration), // in/s^2

    // Velocity
    VelInSec("in/s", 1.0, 0.0, PhysicalDomain.Velocity), // in/s - DEFAULT INTERNAL SYSTEM UNIT
    VelMtrSec("m/s", 0.0254, 0.0, PhysicalDomain.Velocity), // m/s
    VelMmSec("mm/s", 2.54, 0.0, PhysicalDomain.Velocity), // mm/s

    // Displacement
    DisplMil("mil", 1.0, 0.0, PhysicalDomain.Displacement), // mil - DEFAULT INTERNAL SYSTEM UNIT
    DisplMm("mm", 0.025, 0.0, PhysicalDomain.Displacement), // mm

    // Frequency
    FreqHz("Hz", 1.0, 0.0, PhysicalDomain.Frequency), // Hz - DEFAULT INTERNAL SYSTEM UNIT
    FreqCPM("CPM", 60.0, 0.0, PhysicalDomain.Frequency), // CPM

    // Time
    TimeSec("s", 1.0, 0.0, PhysicalDomain.Time), // s - DEFAULT INTERNAL SYSTEM UNIT
    TimeMiliSec("ms", 1000.0, 0.0, PhysicalDomain.Time), // ms

    // Temperature
    TempC("\u0080C", 1.0, 0.0, PhysicalDomain.Temperature), // C - DEFAULT INTERNAL SYSTEM UNIT
    TempF("\u0080F", 1.8, 32.0, PhysicalDomain.Temperature); // F

    private String symbol;
    private double factor;
    private double offset;
    private PhysicalDomain domain;

    EUnit(String symbol, double factor, double offset, PhysicalDomain domain) {
        this.symbol = symbol;
        this.factor = factor;
        this.offset = offset;
        this.domain = domain;
    }

    public String symbol() {
        return symbol;
    }

    public double factor() {
        return factor;
    }

    public double offset() {
        return offset;
    }

    public PhysicalDomain domain() {
        return domain;
    }

    /**
     * Check if the unit is default system internal unit for its domain
     * @return true if the unit is default system internal unit, false otherwise
     */
    public boolean defaultUnit() {
        if (this.symbol.equals(this.domain.defaultUnit())) {
            return true;
        }
        return false;
    }
}
