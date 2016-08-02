/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

/**
 * The core logic of unit conversions implemented as a set of static structures and methods.
 * No need to keep this info in database unless there is a radical discovery/change in the laws of physics. 
 * <p>
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>07/11/2008 Taras Dobrovolsky Initial release
 *         </ul>
 */

import java.util.Hashtable;
import java.util.ArrayList;

import com.inchecktech.dpm.beans.PhysicalDomain;

@Deprecated
public class EngUnitConverter {

    /** * List of all engineering units ** */
    static final private EngUnit                                 engUnits[] = {

                                                                            // Acceleration
            new EngUnit( "g", 1.0, 0.0, PhysicalDomain.Acceleration ), // g - DEFAULT INTERNAL SYSTEM UNIT
            new EngUnit( "m/s\u00B2", 9.807, 0.0, PhysicalDomain.Acceleration ), // m/s^2
            new EngUnit( "mm/s\u00B2", 9807.0, 0.0, PhysicalDomain.Acceleration ), // mm/s^2
            new EngUnit( "in/s\u00B2", 386.088583, 0.0, PhysicalDomain.Acceleration ), // in/s^2

            // Velocity
            new EngUnit( "in/s", 1.0, 0.0, PhysicalDomain.Velocity ), // in/s - DEFAULT INTERNAL SYSTEM UNIT
            new EngUnit( "m/s", 0.0254, 0.0, PhysicalDomain.Velocity ), // m/s
            new EngUnit( "mm/s", 2.54, 0.0, PhysicalDomain.Velocity ), // mm/s

            // Displacement
            new EngUnit( "mil", 1.0, 0.0, PhysicalDomain.Displacement ), // mil - DEFAULT INTERNAL SYSTEM UNIT
            new EngUnit( "mm", 0.025, 0.0, PhysicalDomain.Displacement ), // mm

            // Frequency
            new EngUnit( "Hz", 1.0, 0.0, PhysicalDomain.Frequency ), // Hz - DEFAULT INTERNAL SYSTEM UNIT
            new EngUnit( "CPM", 60.0, 0.0, PhysicalDomain.Frequency ), // CPM

            // Time
            new EngUnit( "s", 1.0, 0.0, PhysicalDomain.Time ), // s - DEFAULT INTERNAL SYSTEM UNIT
            new EngUnit( "ms", 1000.0, 0.0, PhysicalDomain.Time ), // ms

            // Temperature
            new EngUnit( "\u0080C", 1.0, 0.0, PhysicalDomain.Time ), // C - DEFAULT INTERNAL SYSTEM UNIT
            new EngUnit( "\u0080F", 1.8, 32.0, PhysicalDomain.Time ), // F

                                                                            };

    static private Hashtable<String, EngUnit>                    hEngUnits;
    static private Hashtable<PhysicalDomain, ArrayList<EngUnit>> hEngDomains;

    // static code block to initialize static structures
    static {
        // Hashtable for all units accessible by the symbol
        hEngUnits = new Hashtable<String, EngUnit>();
        for( int i = 0; i < engUnits.length; i++ ) {
            hEngUnits.put( engUnits[i].getSymbol(), engUnits[i] );
        }

        // initialize the hastable for all physical domains/dimensions
        hEngDomains = new Hashtable<PhysicalDomain, ArrayList<EngUnit>>();
        PhysicalDomain domains[] = PhysicalDomain.values();
        for( int i = 0; i < domains.length; i++ ) {
            hEngDomains.put( domains[i], new ArrayList<EngUnit>() );
        }
        for( int i = 0; i < engUnits.length; i++ ) {
            hEngDomains.get( engUnits[i].getDimension() ).add( engUnits[i] );
        }

    }

    /**
     * Lookup all available supported engineering units for a specific physical domain
     * @param domain physical domain from PhysicalDomain enum
     * @return array of EngUnit objects representing all supported engineering units for a specific domain
     */
    public static EngUnit[] getAvailableUnits( PhysicalDomain domain ) {
        try {
            EngUnit[] arr = new EngUnit[hEngDomains.get( domain ).size()];
            return hEngDomains.get( domain ).toArray( arr );
        }
        catch( Exception e ) { // exception - most likely invalid invocation
            return new EngUnit[0];
        }
    }

    /**
     * Lookup all available supported engineering units for a specific physical domain
     * @param domain physical domain from PhysicalDomain enum
     * @return array of String symbols for all supported engineering units for a specific domain
     */
    public static String[] getAVailableUnits( PhysicalDomain domain ) {
        try {
            EngUnit[] arr = new EngUnit[hEngDomains.get( domain ).size()];
            EngUnit[] engUnits = hEngDomains.get( domain ).toArray( arr );
            String[] units = new String[engUnits.length];

            for( int i = 0; i < engUnits.length; i++ ) {
                units[i] = engUnits[i].getSymbol();
            }

            return units;
        }
        catch( Exception e ) { // exception - most likely invalid invocation
            return new String[0];
        }
    }
    
    /**
     * Lookup PhysicalDomain enum member by description: Acceleration, Velocity, Displacement, Frequency, Time, Temperature
     * @param descr Description of a physical domain
     * @return PhysicalDomain enum member for a specific description
     */
    public static PhysicalDomain lookupDomainByDescr( String descr ) {
        if( descr == null ) {
            return null;
        }
        PhysicalDomain domains[] = PhysicalDomain.values();
        for( int i = 0; i < domains.length; i++ ) {
            if( descr.equals( domains[i].descr() ) ) {
                return domains[i];
            }
        }
        return null; // not found
    }
    
    /**
     * Lookup PhysicalDomain enum member by abbreviation: Acc, Vel, Dis, Freq, Time, Temp
     * @param abbr Abbreviation of a physical domain
     * @return PhysicalDomain enum member for a specific abbreviation
     */
    public static PhysicalDomain lookupDomainByAbbr( String abbr ) {
        if( abbr == null ) {
            return null;
        }
        PhysicalDomain domains[] = PhysicalDomain.values();
        for( int i = 0; i < domains.length; i++ ) {
            if( abbr.equals( domains[i].descr() ) ) {
                return domains[i];
            }
        }
        return null; // not found
    }
    
    /**
     * Lookup engineering unit object for a specific engineering unit symbol: g, Hz, ms etc.
     * @param symbol Engineering unit symbol: g, Hz, ms etc.
     * @return EngUnit object for specified symbol 
     */
    public static EngUnit lookupEngUnitBySymbol (String symbol) {
        if( symbol == null ) {
            return null;
        }
        return hEngUnits.get( symbol );
    }
    
    /**
     * Convert value from default system internal unit into target unit.
     * @param value the value to be converted
     * @param targetUnit desired target unit 
     * @return converted value
     */
    public static double convert(double value, EngUnit targetUnit) {
        if ( targetUnit == null ) {
            return value;
        }
        return value * targetUnit.getFactor() + targetUnit.getOffset();
    }
    
    /**
     * Convert value from source unit into target unit.
     * @param value the value to be converted
     * @param targetUnit desired target unit
     * @param sourceUnit source unit (i.e. current unit of provided value) 
     * @return converted value
     */
    public static double convert(double value, EngUnit sourceUnit, EngUnit targetUnit) {
        if ( (sourceUnit == null) || (targetUnit == null) ) {
            return value;
        }
        // first, convert to default then convert to new target
        double temp = ( value - sourceUnit.getOffset() ) / sourceUnit.getFactor();
        return temp * targetUnit.getFactor() + targetUnit.getOffset();
    }
    
    /**
     * Convert value from default system internal unit into target unit.
     * @param value the value to be converted
     * @param targetSymbol desired unit symbol (Hz, ms etc.) 
     * @return converted value
     */
    public static double convert(double value, String targetSymbol) {
        return convert(value, lookupEngUnitBySymbol( targetSymbol ));
    }
    
    /**
     * Convert value from default system internal unit into target unit.
     * @param value the value to be converted
     * @param targetSymbol desired unit symbol (Hz, ms etc.) 
     * @return converted value
     */
    public static double convert(double value, String sourceSymbol, String targetSymbol) {
        return convert(value, lookupEngUnitBySymbol( sourceSymbol ), lookupEngUnitBySymbol( targetSymbol ));
    }

}
