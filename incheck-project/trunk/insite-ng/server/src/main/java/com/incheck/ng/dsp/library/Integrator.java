package com.incheck.ng.dsp.library;

/**
 * Defines methods for integration algorithms: Acceleration into Velocity in
 * Time Domain Acceleration into Velocity in Frequency Domain Velocity into
 * Displacement in Time Domain Velocity into Displacement in Frequency Domain
 * 
 * @author Taras Dobrovolsky
 * 
 *         Change History: 10/10/2007 Taras Dobrovolsky Initial Release
 *         05/15/2012 Bertrand Liechtenstein Updated
 */
public class Integrator {
    private static final double ACCELERATION_UNIT_COEFFICIENT = 386.089;
    private static final double VELOCITY_UNIT_COEFFICIENT = 1000;
    /* Coefficient for spectrum acceleration to velocity integration */
    private static final double FD_ACCELERATION_TO_VELOCITY_COEFF = 61.447797d;

    /**
     * This method integrates sampled data in Time Domain to obtain velocity
     * values from acceleration values. Integrate sampled acceleration data in
     * G's (386.089 in/s^2) to obtain velocity data. v(i) = v(i-1) + k * a(i),
     * where v - velocity, a - acceleration. We know that sum(v(i)) = 0 [i from
     * 0 to N], thus we assume v(-1) = 0 k = 386.089 / sampling_rate Reference:
     * 4.6.1.1 in InView Monitoring System Processing document
     * 
     * @param arrIn
     *            input array
     * @param sampleRate
     *            Channel sampling rate
     * @param noOfAppendedZeros
     *            Number of zeros's that were appended to the data set during
     *            re-sampling to radix 2. It is used to adjust the range of
     *            values that need to be integrated.
     * @return array of integrated values
     */

    public static double[] integrateTDAccellerationToVelocity(double arrIn[], int sampleRate, int noOfAppendedZeros) {
        return integrate(arrIn, sampleRate, ACCELERATION_UNIT_COEFFICIENT, noOfAppendedZeros);
    }

    /**
     * This method integrates sampled data in Frequency Domain to obtain
     * displacement values from velocity values. Integrate velocity data points
     * to obtain displacement data. d(i) = d(i-1) + k * v(i), where d -
     * displaceemnt, v - velocity we assume d(-1) = 0 k = 1000 / sampling_rate
     * Reference: 4.6.1.1 in InView Monitoring System Processing document
     * 
     * @param arrIn
     *            input array
     * @param sampleRate
     *            Channel sampling rate
     * @param noOfAppendedZeros
     *            Number of zeros's that were appended to the data set during
     *            re-sampling to radix 2. It is used to adjust the range of
     *            values that need to be integrated.
     * @return array of integrated values
     */
    public static double[] integrateTDVelocityToDisplacement(double arrIn[], int sampleRate, int noOfAppendedZeros) {

        return integrate(arrIn, sampleRate, VELOCITY_UNIT_COEFFICIENT, noOfAppendedZeros);

    }

    /**
     * This method integrates sampled data in Frequency Domain to obtain
     * velocity values from acceleration values.
     * 
     * @param arrIn
     *            input array
     * @param origSampleRate
     *            original sampling rate
     * @param accelerationSpectrum
     *            Acceleration spectrum to process
     * @return array of integrated values
     */
    public static double[] integrateFDAccellerationToVelocity(double arrIn[], int origSamplingRate, double[] accelerationSpectrum) {
        double result[] = new double[0];
        if (validateIntegrateFDAccellerationToVelocity(arrIn, origSamplingRate)) {
            int index = 0;
            int size = accelerationSpectrum.length * 2;
            result = new double[accelerationSpectrum.length];
            for (double temp : accelerationSpectrum) {
                result[index] = (index != 0) ? calculateFDAccellerationToVelocityStep(temp, index, size, origSamplingRate) : 0d;
                index++;
            }
        }
        return result;
    }

    /**
     * This method integrates sampled data in Frequency Domain to obtain
     * displacement values from velocity values.
     * 
     * @param arrIn
     *            input array
     * @param noOfAppendedZeros
     *            Number of zeros's that were appended to the data set during
     *            re-sampling to radix 2. It is used to adjust the range of
     *            values that need to be integrated.
     * @return array of integrated values
     */
    public static double[] integrateFDVelocityToDisplacement(double arrIn[], int noOfAppendedZeros) {
        // TODO Implement integration algorithm in frequency domain
        return arrIn;
    }

    /**
     * Local generic integration algorithm used for integrating to velocity and
     * displacement. Only integrationCoefficient is different.
     * 
     * @param arrIn
     *            Input array to be integrated
     * @param sampleRate
     *            sampling rate of a sample set
     * @param integrationCoefficient
     *            constant integration coefficient ACCELERATION_UNIT_COEFFICIENT
     *            = 386.089 VELOCITY_UNIT_COEFFICIENT = 1000
     * @param noOfAppendedZeros
     *            Number of zeros's that were appended to the data set during
     *            re-sampling to radix 2. It is used to adjust the range of
     *            values that need to be integrated.
     * @return
     */
    private static double[] integrate(double arrIn[], int sampleRate, double integrationCoefficient, int noOfAppendedZeros) {
        if (arrIn == null || arrIn.length < 2 || sampleRate < 1) {
            return new double[0];
        }
        double results[] = new double[arrIn.length];
        // calculate coefficient k
        double k = integrationCoefficient / sampleRate;
        // calculate v(0)
        results[0] = k * arrIn[0];
        // calculate the rest of the velocity data points, calculate sum(v(i))
        double v;
        for (int i = 1; i < (arrIn.length - noOfAppendedZeros); i++) {
            v = results[i - 1] + k * arrIn[i];
            results[i] = v;
        }
        // re-append 0's (do not perform integration for 0's)
        for (int i = (arrIn.length - noOfAppendedZeros); i < arrIn.length; i++) {
            results[i] = 0.0D;
        }
        return results;
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
    private static double calculateFDAccellerationToVelocityStep(double value, int index, int arrayLength, int origSamplingRate) {
        double tFrame = (double) arrayLength / (double) origSamplingRate;
        return (value * (tFrame / index) * FD_ACCELERATION_TO_VELOCITY_COEFF);
    }

    /**
     * Validate input parameters for FD acceleration to Velocity integration.
     * The input data must not be <code>null</code>, or empty.
     * 
     * @param arrIn
     *            - input data
     * @param accelerationSpectrum
     *            - accelerated spectrum data
     * @param origSamplingRate
     *            - original sampling rate
     * @return <code>true</code> in case of valid data, otherwise -
     *         <code>false</code>.
     */
    private static boolean validateIntegrateFDAccellerationToVelocity(double arrIn[], int origSamplingRate) {
        return ((arrIn != null) && (arrIn.length > 0) && (origSamplingRate > 0));
    }
}
