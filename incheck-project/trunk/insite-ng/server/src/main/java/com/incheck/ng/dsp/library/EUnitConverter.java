package com.incheck.ng.dsp.library;

/**
 * The core logic of unit conversions implemented as a set of static structures and methods. No need to keep this info
 * in database unless there is a radical discovery/change in the laws of physics.
 * <p>
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>07/11/2008 Taras Dobrovolsky Initial release
 *         </ul>
 */

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;


public class EUnitConverter {

    static private Hashtable<String, EUnit> hEngUnits;
    static private Hashtable<PhysicalDomain, ArrayList<EUnit>> hEngDomains;

    // static code block to initialize static structures
    static {
        // Hashtable for all units accessible by the symbol
        hEngUnits = new Hashtable<String, EUnit>();
        for (int i = 0; i < EUnit.values().length; i++) {
            hEngUnits.put(EUnit.values()[i].symbol(), EUnit.values()[i]);
        }

        // initialize the hastable for all physical domains/dimensions
        hEngDomains = new Hashtable<PhysicalDomain, ArrayList<EUnit>>();
        PhysicalDomain domains[] = PhysicalDomain.values();
        for (int i = 0; i < domains.length; i++) {
            hEngDomains.put(domains[i], new ArrayList<EUnit>());
        }
        for (int i = 0; i < EUnit.values().length; i++) {
            hEngDomains.get(EUnit.values()[i].domain()).add(EUnit.values()[i]);
        }

    }

    /**
     * Lookup all available supported engineering units for a specific physical
     * domain
     * 
     * @param domain
     *            physical domain from PhysicalDomain enum
     * @return array of EUnit objects representing all supported engineering
     *         units for a specific domain
     */
    public static EUnit[] getAvailableUnits(PhysicalDomain domain) {
        try {
            EUnit[] arr = new EUnit[hEngDomains.get(domain).size()];
            return hEngDomains.get(domain).toArray(arr);
        } catch (Exception e) { // exception - most likely invalid invocation
            return new EUnit[0];
        }
    }

    /**
     * Lookup all available supported engineering units for a specific physical
     * domain
     * 
     * @param domain
     *            physical domain from PhysicalDomain enum
     * @return array of String symbols for all supported engineering units for a
     *         specific domain
     */
    public static String[] getAVailableUnits(PhysicalDomain domain) {
        try {
            EUnit[] arr = new EUnit[hEngDomains.get(domain).size()];
            EUnit[] eUnits = hEngDomains.get(domain).toArray(arr);
            String[] units = new String[eUnits.length];

            for (int i = 0; i < eUnits.length; i++) {
                units[i] = eUnits[i].symbol();
            }

            return units;
        } catch (Exception e) { // exception - most likely invalid invocation
            return new String[0];
        }
    }

    /**
     * Lookup default engineering unit for a given physical domain
     * 
     * @param domain
     *            physical domain (acceleration, velocity, time etc.)
     * @return default engineering unit for a given physical domain
     */
    public static EUnit getDefaultUnit(PhysicalDomain domain) {
        return hEngUnits.get(domain.defaultUnit());
    }

    /**
     * Lookup PhysicalDomain enum member by description: Acceleration, Velocity,
     * Displacement, Frequency, Time, Temperature
     * 
     * @param descr
     *            Description of a physical domain
     * @return PhysicalDomain enum member for a specific description
     */
    public static PhysicalDomain lookupDomainByDescr(String descr) {
        if (descr == null) {
            return null;
        }
        PhysicalDomain domains[] = PhysicalDomain.values();
        for (int i = 0; i < domains.length; i++) {
            if (descr.equals(domains[i].descr())) {
                return domains[i];
            }
        }
        return null; // not found
    }

    /**
     * Lookup PhysicalDomain enum member by abbreviation: Acc, Vel, Dis, Freq,
     * Time, Temp
     * 
     * @param abbr
     *            Abbreviation of a physical domain
     * @return PhysicalDomain enum member for a specific abbreviation
     */
    public static PhysicalDomain lookupDomainByAbbr(String abbr) {
        if (abbr == null) {
            return null;
        }
        PhysicalDomain domains[] = PhysicalDomain.values();
        for (int i = 0; i < domains.length; i++) {
            if (abbr.equals(domains[i].descr())) {
                return domains[i];
            }
        }
        return null; // not found
    }

    /**
     * Lookup engineering unit object for a specific engineering unit symbol: g,
     * Hz, ms etc.
     * 
     * @param symbol
     *            Engineering unit symbol: g, Hz, ms etc.
     * @return EUnit object for specified symbol
     */
    public static EUnit lookupEUnitBySymbol(String symbol) {
        if (symbol == null) {
            return null;
        }
        return hEngUnits.get(symbol);
    }

    /**
     * Convert value from default system internal unit into target unit.
     * 
     * @param value
     *            the value to be converted
     * @param targetUnit
     *            desired target unit
     * @return converted value
     */
    public static double convert(double value, EUnit targetUnit) {
        if (targetUnit == null) {
            return value;
        }
        return value * targetUnit.factor() + targetUnit.offset();
    }

    /**
     * Convert value from source unit into target unit.
     * 
     * @param value
     *            the value to be converted
     * @param targetUnit
     *            desired target unit
     * @param sourceUnit
     *            source unit (i.e. current unit of provided value)
     * @return converted value
     */
    public static double convert(double value, EUnit sourceUnit, EUnit targetUnit) {
        if ((targetUnit == null)) {
            return value;
        }

        EUnit sUnit = sourceUnit;
        if (sourceUnit == null) {
            sUnit = getDefaultUnit(targetUnit.domain());
        }
        if (sUnit.equals(targetUnit)) {
            return value;
        }
        if (sUnit.defaultUnit()) {
            return convert(value, targetUnit);
        }
        // if unit not default: first, convert to default then convert to new
        // target
        double temp = (value - sUnit.offset()) / sUnit.factor();
        return temp * targetUnit.factor() + targetUnit.offset();
    }

    /**
     * Convert value from default system internal unit into target unit.
     * 
     * @param value
     *            the value to be converted
     * @param targetSymbol
     *            desired unit symbol (Hz, ms etc.)
     * @return converted value
     */
    public static double convert(double value, String targetSymbol) {
        return convert(value, lookupEUnitBySymbol(targetSymbol));
    }

    /**
     * Convert value from default system internal unit into target unit.
     * 
     * @param value
     *            the value to be converted
     * @param targetSymbol
     *            desired unit symbol (Hz, ms etc.)
     * @return converted value
     */
    public static double convert(double value, String sourceSymbol, String targetSymbol) {
        return convert(value, lookupEUnitBySymbol(sourceSymbol), lookupEUnitBySymbol(targetSymbol));
    }

    /**
     * Perform in-place conversion of the list of elements
     * 
     * @param values
     *            values to convert
     * @param targetUnit
     *            target engineering unit (source is assumed to be default
     *            system unit)
     */
    public static void convert(List<Double> values, EUnit targetUnit) {
        for (int i = 0; i < values.size(); i++) {
            values.set(i, convert(values.get(i).doubleValue(), targetUnit));
        }
    }

    /**
     * Perform in-place conversion of the list of elements
     * 
     * @param values
     *            values to convert
     * @param sourceUnit
     *            source engineering unit
     * @param targetUnit
     *            target engineering unit
     */
    public static void convert(List<Double> values, EUnit sourceUnit, EUnit targetUnit) {
        for (int i = 0; i < values.size(); i++) {
            values.set(i, convert(values.get(i).doubleValue(), sourceUnit, targetUnit));
        }
    }

    /**
     * Perform in-place conversion of the list of elements
     * 
     * @param values
     *            values to convert
     * @param targetSymbol
     *            target engineering unit symbol (source is assumed to be
     *            default system unit)
     */
    public static void convert(List<Double> values, String targetSymbol) {
        for (int i = 0; i < values.size(); i++) {
            values.set(i, convert(values.get(i).doubleValue(), lookupEUnitBySymbol(targetSymbol)));
        }
    }

    /**
     * Perform in-place conversion of the list of elements
     * 
     * @param values
     *            values to convert
     * @param sourceSymbol
     *            source engineering unit symbol
     * @param targetSymbol
     *            target engineering unit symbol
     */
    public static void convert(List<Double> values, String sourceSymbol, String targetSymbol) {
        for (int i = 0; i < values.size(); i++) {
            values.set(i, convert(values.get(i).doubleValue(), lookupEUnitBySymbol(sourceSymbol), lookupEUnitBySymbol(targetSymbol)));
        }
    }
}
