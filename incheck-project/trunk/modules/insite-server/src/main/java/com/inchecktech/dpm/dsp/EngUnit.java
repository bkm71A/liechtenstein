/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import com.inchecktech.dpm.beans.PhysicalDomain;

/**
 * Class representing an engineering unit and its properties for converting in other engineering units.
 * <p>
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>07/09/2008 Taras Dobrovolsky Initial release
 *         </ul>
 */
@Deprecated
public class EngUnit {

    private String         symbol;
    private double         factor;
    private double         offset;
    private PhysicalDomain dimension;

    public EngUnit(String symbol, double factor, double offset, PhysicalDomain dimension) {
        this.symbol = symbol;
        this.factor = factor;
        this.offset = offset;
        this.dimension = dimension; 
    }

    /**
     * @return the symbol
     */
    public String getSymbol( ) {
        return symbol;
    }

    /**
     * @param symbol the symbol to set
     */
    public void setSymbol( String symbol ) {
        this.symbol = symbol;
    }
   
    /**
     * @return the factor
     */
    public double getFactor( ) {
        return factor;
    }

    /**
     * @param factor the factor to set
     */
    public void setFactor( double factor ) {
        this.factor = factor;
    }

    /**
     * @return the offset
     */
    public double getOffset( ) {
        return offset;
    }

    /**
     * @param offset the offset to set
     */
    public void setOffset( double offset ) {
        this.offset = offset;
    }

    /**
     * @return the dimension
     */
    public PhysicalDomain getDimension( ) {
        return dimension;
    }

    /**
     * @param dimension the dimension to set
     */
    public void setDimension( PhysicalDomain dimension ) {
        this.dimension = dimension;
    }
    
    
}
