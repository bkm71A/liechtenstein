/**
 * Copyright 2007, IncCheck Technologies, Inc. All Rights Reserved This is unpublished proprietary source code of
 * InCheck Technologies, Inc. The copyright notice above does not evidence any actual or intended publication of such
 * source code.
 */

package com.inchecktech.dpm.dsp;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.inchecktech.dpm.beans.ProcessedData;

/**
 * This is the implementation of Integrator interface. Please refer to each method description for details on the
 * specific methods used.
 * @author Taras Dobrovolsky Change History: 10/10/2007 Taras Dobrovolsky Re-factored to utilize Factory pattern
 *         11/20/2007 Taras Dobrovolsky Added logic to subtract average of all data points before integration
 */
class DefaultIntegrator implements Integrator {

	/**
	 * Class contains constants use for the integration calculations
	 */
	private static class IntegratorConstants {
		final static double ACCELERATION_UNIT_COEFFICIENT	 = 386.089;
		final static double VELOCITY_UNIT_COEFFICIENT		 = 1000;

		/* Coefficient for spectrum acceleration to velocity integration */
		static final double FD_ACCELERATION_TO_VELOCITY_COEFF = 61.447797d;
	}
   
	/**
	 * @see com.inchecktech.dpm.dsp.Integrator#integrateFDAccellerationToVelocity(java.util.List, int,
	 *      com.inchecktech.dpm.beans.ProcessedData)
	 */
	public List<Double> integrateFDAccellerationToVelocity(List<Double> arrIn, int origSamplingRate,
			ProcessedData accelerationSpectrum) {
		List<Double> result = new ArrayList<Double>();

		if (validateIntegrateFDAccellerationToVelocity(arrIn, accelerationSpectrum, origSamplingRate)) {
			int index = 0;
			int size = accelerationSpectrum.getData().size() * 2;
			for (double temp : accelerationSpectrum.getData()) {
				result.add(index, (index != 0) ? calculateFDAccellerationToVelocityStep(temp, index, size, origSamplingRate) : 0d);
				index++;
			}
		}

		return result;
	}

	/**
	 * Validate input parameters for FD acceleration to Velocity integration. The input data must not be
	 * <code>null</code>, or empty.
	 * 
	 * @param arrIn
	 *            - input data
	 * @param accelerationSpectrum
	 *            - accelerated spectrum data
	 * @param origSamplingRate
	 *            - original sampling rate
	 * @return <code>true</code> in case of valid data, otherwise - <code>false</code>.
	 */
	private boolean validateIntegrateFDAccellerationToVelocity(List<Double> arrIn, ProcessedData accelerationSpectrum,
			int origSamplingRate) {
		return ((arrIn != null) && (!arrIn.isEmpty()) && (accelerationSpectrum != null) && (origSamplingRate > 0));
	}
  
	/**
	 * Calculate spectrum FD acceleration to velocity step
	 * 
	 * @param value
	 *            - accelerated spectrum value
	 * @param index
	 *            - current array indes
	 * @param arrayLength
	 *            - length of spectrum accelerated array
	 * @param origSamplingRate
	 *            - original sampling rate
	 * @return <code>double</code> integrated value
	 */
	private double calculateFDAccellerationToVelocityStep(double value, int index, int arrayLength, int origSamplingRate) {
		//return ((IntegratorConstants.FD_ACCELERATION_TO_VELOCITY_COEFF * value) / (index * origSamplingRate)) * (arrayLength);
		double tFrame = (double)arrayLength / (double)origSamplingRate;
		return (value * (tFrame / index) * IntegratorConstants.FD_ACCELERATION_TO_VELOCITY_COEFF);
	}
	
    public List<Double> integrateFDVelocityToDisplacement( List<Double> arrIn, int noOfAppendedZeros ) {
        // TODO Implement integration algorithm in frequency domain
        return arrIn;
    }

    /**
     * Integrate sampled acceleration data in G's (386.089 in/s^2) to obtain velocity data. v(i) = v(i-1) + k * a(i),
     * where v - velocity, a - acceleration. We know that sum(v(i)) = 0 [i from 0 to N], thus we assume v(-1) = 0 k =
     * 386.089 / sampling_rate Reference: 4.6.1.1 in InView Monitoring System Processing document
     */
    public List<Double> integrateTDAccellerationToVelocity( List<Double> arrIn, int sampleRate, int noOfAppendedZeros ) {

        return integrate( arrIn, sampleRate, IntegratorConstants.ACCELERATION_UNIT_COEFFICIENT, noOfAppendedZeros );

    }

    /**
     * Integrate velocity data points to obtain displacement data. d(i) = d(i-1) + k * v(i), where d - displaceemnt, v -
     * velocity we assume d(-1) = 0 k = 1000 / sampling_rate Reference: 4.6.1.1 in InView Monitoring System Processing
     * document
     */
    public List<Double> integrateTDVelocityToDisplacement( List<Double> arrIn, int sampleRate, int noOfAppendedZeros ) {

        return integrate( arrIn, sampleRate, IntegratorConstants.VELOCITY_UNIT_COEFFICIENT, noOfAppendedZeros );

    }

    /**
     * Local generic integration algorithm used for integrating to velocity and displacement. Only
     * integrationCoefficient is different.
     * @param arrIn Input array to be integrated
     * @param sampleRate sampling rate of a sample set
     * @param integrationCoefficient constant integration coefficient ACCELERATION_UNIT_COEFFICIENT = 386.089
     *            VELOCITY_UNIT_COEFFICIENT = 1000
     * @param noOfAppendedZeros Number of zeros's that were appended to the data set during re-sampling to radix 2. It
     *            is used to adjust the range of values that need to be integrated.
     * @return
     */
    private List<Double> integrate( List<Double> arrIn, int sampleRate, double integrationCoefficient,
                                    int noOfAppendedZeros ) {

        if( arrIn == null ) {
            return new Vector<Double>( 0 );
        }
        if( arrIn.size() < 2 ) {
            return new Vector<Double>( 0 );
        }
        if( sampleRate < 1 ) {
            return new Vector<Double>( 0 );
        }

        Vector<Double> results = new Vector<Double>( arrIn.size() );

        // calculate coefficient k
        double k = integrationCoefficient / sampleRate;

        // calculate v(0)
        results.add( k * arrIn.get( 0 ) );

        // calculate the rest of the velocity data points, calculate sum(v(i))
        double v;
        for( int i = 1; i < (arrIn.size() - noOfAppendedZeros); i++ ) {
            v = results.elementAt( i - 1 ) + k * arrIn.get( i );
            results.add( v );
        }
        
        // re-append 0's (do not perform integration for 0's)
        for( int i = (arrIn.size() - noOfAppendedZeros); i < arrIn.size(); i++ ) {
            v = new Double(0.0);
            results.add( v );
        }

        return results;

    }

}
