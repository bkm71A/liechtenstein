/**
 * Copyright 2008, Incheck Tech, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck Tech,
 * Inc. The copyright notice above does not evidence any actual or intended publication of such source code.
 */
package com.inchecktech.dpm.dsp;

import java.security.InvalidAlgorithmParameterException;

import com.inchecktech.dpm.beans.EUnit;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.DSPCoreDump;

/**
 * This interface is to be used by DPM engine for transparent processing of dynamic and static data sets. Known
 * implementing classes: DSPDynamicCalculator, DSPStaticCalculator. Use DSPFactory class to instantiate the instance.
 * <p>
 * @author Taras Dobrovolsky
 *         <p>
 *         Change History:
 *         <ul>
 *         <li>11/07/2007 Taras Dobrovolsky Initial release
 *         <li>04/24/2008 Taras Dobrovolsky Added a new method for calculations on-demand from GUI
 *         </ul>
 */
public interface DSPCalculator {

    /**
     * Re-initialize algorithm sub-engines based on new configuration settings looked up from the database.
     * @throws RuntimeException if a runtime exception occurs (i.e. database down, network down etc.). Check logs for
     *             trace details.
     */
    void reload( ) throws RuntimeException;
    
    /**
     * Returns channel id
     * @return
     */
    int getChannelId();

    /**
     * This method processes incoming data from DAM in idle (client-less) mode. It produces minimum outputs and overalls
     * for alarm generation and historical data storage.
     * @param rawData raw data read from DAM packaged in RawData object
     * @param methods This parameter is unused - pass <code>null</code>. Alternative on-demand approach has been
     *            implemented.
     * @return ChannelState object containing raw and processed data that represents current real-time channel state.
     * @throws InvalidAlgorithmParameterException
     * @throws RuntimeException
     */
    ChannelState processData( RawData rawData, String[] methods ) throws InvalidAlgorithmParameterException,
                                                                 RuntimeException;

    /**
     * This method processes the data in
     * @param data Input data set. Must be re-sampled data set in Time Wave domain (Release 1).
     * @param calcMethod Calculating method to be used to process the data. Must be one of the following keys for
     *            dynamic channel processing (Release 1):
     *            <ul>
     *            <li><code>ProcessedData.KEY_TIMEWAVE_ACC</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_ACC_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_ACC_RMS</code>
     *            <li><code>ProcessedData.KEY_TIMEWAVE_VEL</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_VEL_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_VEL_RMS</code>
     *            <li><code>ProcessedData.KEY_TIMEWAVE_DISPL</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_DISPL_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_DISPL_RMS</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_RMS</code>
     *            </ul>
     *            <p>
     *            NOTE: For static channels the method does not apply any processing to the input data.
     * @return Caller requested ProcessedData object that was processed using specified calculating method.
     * @throws InvalidAlgorithmParameterException
     * @throws RuntimeException
     */
    //@Deprecated
    //ProcessedData processData( ProcessedData data, String calcMethod ) throws InvalidAlgorithmParameterException,
    //                                                                  RuntimeException;

    /**
     * This method processes the data in
     * @param data Input data set. Must be re-sampled data set in Time Wave domain (Release 1).
     * @param calcMethod Calculating method to be used to process the data. Must be one of the following keys for
     *            dynamic channel processing (Release 1):
     *            <ul>
     *            <li><code>ProcessedData.KEY_TIMEWAVE_ACC</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_ACC_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_ACC_RMS</code>
     *            <li><code>ProcessedData.KEY_TIMEWAVE_VEL</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_VEL_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_VEL_RMS</code>
     *            <li><code>ProcessedData.KEY_TIMEWAVE_DISPL</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_DISPL_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_DISPL_RMS</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_PEAK</code>
     *            <li><code>ProcessedData.KEY_SPECTRUM_BRN_DEM_ACC_RMS</code>
     *            </ul>
     *            <p>
     *            NOTE: For static channels the method does not apply any processing to the input data.
     * @param yUnitTarget target engineering units for data points (Y axis)
     * @param xUnitTarget target engineering units for data labels (X axis) 
     * @return Caller requested ProcessedData object that was processed using specified calculating method.
     * @throws InvalidAlgorithmParameterException
     * @throws RuntimeException
     */
    ProcessedData processData( ProcessedData data, String calcMethod, EUnit xUnitTarget, EUnit yUnitTarget, double centralFrequency, int deviation )
                                                                                                            throws InvalidAlgorithmParameterException,
                                                                                                            RuntimeException;

    /**
     * Check if the current DSP Calculator object runs in debug mode
     * @return <code>true</code> if the DSPCalculator object is in debug mode generating extra data sets for analysis.
     *         <code>false</code> otherwise.
     */
    boolean isDebugMode( );

    /**
     * Returns the latest DSPCoreDump object containing data for analysis/debugging
     * @return dspCoreDump Returns the latest DSPCoreDump object containing data for analysis/debugging
     */
    DSPCoreDump getDspCoreDump( );

    /**
     * Returns the key for the primary/default ProcessedData object (99% of the time it will be acceleration)
     * @return the key for the primary/default ProcessedData object
     */
    String getPrimaryProcessedDataKey( );

}
