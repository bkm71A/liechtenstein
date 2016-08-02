/**
 * Copyright 2007, Incheck, Inc. All Rights Reserved This is unpublished proprietary source code of Incheck, Inc. The
 * copyright notice above does not evidence any actual or intended publication of such source code.
 */

package com.inchecktech.dpm.tests;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.inchecktech.dpm.beans.ChannelState;
import com.inchecktech.dpm.beans.DSPCoreDump;
import com.inchecktech.dpm.beans.ProcessedData;
import com.inchecktech.dpm.beans.RawData;
import com.inchecktech.dpm.config.ChannelConfigFactory;
import com.inchecktech.dpm.dsp.ButterHighPassFilter;
import com.inchecktech.dpm.dsp.DCFilter;
import com.inchecktech.dpm.dsp.ButterHighPassFilterOrd;
import com.inchecktech.dpm.dsp.DSPCalculator;
import com.inchecktech.dpm.dsp.DSPFactory;
import com.inchecktech.dpm.dsp.DSPUtils;
import com.inchecktech.dpm.dsp.DefaultFFTTransformer;
import com.inchecktech.dpm.dsp.FFTTransformer;
import com.inchecktech.dpm.dsp.Filter;
import com.inchecktech.dpm.dsp.LinearInterpolationResampler;

/**
 * A collection of tests to test various DSP (Digital SIgnal Processing) algorithms TODO: Use JUnit to design and
 * implement unit tests in the future
 */
public class DSPTests {

    /**
     * @param args
     */
    public static void main( String[] args ) {

        System.out.println("x" + "\u00B2");
        
        // ///////////////////////////////////////////////////////////////
        // RUN UNIT TESTS
        // ///////////////////////////////////////////////////////////////

        // RESAMPLER TESTS
        // resamplerTest00 ();

        // FFT TESTS
        // FFTTest01();

        // Unit Conversion Tests
        // UnitConvTest01();

        // Integration Test (Acc -> Velocity)
        // IntegrationTest01();

        // Overall Levels Calculation Tests
        // overallsCalcTest01();

        // Re-sampler Tests
        // ResamplerTest01();

        // FFT Tests - weight then FFT
        // FFTTest01();

        // DSPIntegrationPreTest();

        // DSPStaticChannelTest();

        // DSPFilterTest01();

        // DSPClosestRadix2Test();
        
        // DSPFilterTest02();
        
        DSPFilterTest03();

    }

    protected static void DSPClosestRadix2Test( ) {
        System.out.println( DSPUtils.closestRadix2( 10676 ) );
    }

    protected static void DSPFilterTest03( ) {

        Filter filter = new DCFilter();

        try {
            
            // Read the data from input file
            FileReader fr = new FileReader( "input001.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Double> data = new Vector<Double>();
            while( (s = br.readLine()) != null ) {
                data.add( Double.parseDouble( s ) );
            }
            
            List<Double> filtered = filter.filter( data, 500, 500.0 );
            
            FileWriter out1 = new FileWriter( "output001.csv" );
            
            for( int j = 0; j < filtered.size(); j++ ) {
                out1.write( filtered.get( j ).toString() + '\n' );
            }

            fr.close();
            out1.close();

        }
        catch( Exception e ) {

        }
    }
    
    protected static void DSPFilterTest02( ) {

        Filter filter = new ButterHighPassFilterOrd();

        try {
            
            // Read the data from input file
            FileReader fr = new FileReader( "BeforeHP02.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Double> data = new Vector<Double>();
            while( (s = br.readLine()) != null ) {
                data.add( Double.parseDouble( s ) );
            }
            
            List<Double> filtered = filter.filter( data, 8192, 2D, 2 );
            
            FileWriter out1 = new FileWriter( "AfterHP02-BO.csv" );
            
            for( int j = 0; j < filtered.size(); j++ ) {
                out1.write( filtered.get( j ).toString() + '\n' );
            }

            fr.close();
            out1.close();

        }
        catch( Exception e ) {

        }
    }

    protected static void DSPFilterTest01( ) {

        try {

            // load configuration properties from database
            Map<String, String> configProps = ChannelConfigFactory.readChannelConfig( 1001 );

            configProps.put( "com.inchecktech.dpm.dsp.CalculationsSamplingRate", "1024" );

            FFTTransformer fftTransformer = DSPFactory.newFFTTransformer( 3, configProps );
            //Resampler resampler = DSPFactory.newResampler( 3, configProps );

            // System.out.println(configProps);

            Filter filter = new ButterHighPassFilter();

            FileWriter out1 = new FileWriter( "HighPassFilterTest00.csv" );
            FileWriter out2 = new FileWriter( "HighPassFilterTest14.csv" );

            // Read the data from input file
            FileReader fr = new FileReader( "LowPassFilterTest.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Double> data = new Vector<Double>();
            while( (s = br.readLine()) != null ) {
                data.add( Double.parseDouble( s ) );
            }

            int[] arrIn = new int[data.size()];
            for( int i = 0; i < data.size(); i++ ) {
                arrIn[i] = data.elementAt( i ).intValue();
            }

            /*
             * Vector<Double> resampled = resampler.resample(data, 2048); Vector<Double> fft =
             * fftTransformer.FFTTransform(resampled);
             */

            List<Double> filtered = filter.filter( data, 2048, 0.2D, 6 );

            List<Double> filteredFft = fftTransformer.FFTTransform( filtered );

            /*
             * for (int j=0; j<fft.size(); j++) { out1.write(fft.elementAt(j).toString() + '\n'); }
             */

            for( int j = 0; j < filteredFft.size(); j++ ) {
                out2.write( filteredFft.get( j ).toString() + '\n' );
            }

            fr.close();
            out1.close();
            out2.close();

        }
        catch( Exception e ) {
            e.printStackTrace( System.out );
        }

    }

    protected static void DSPFilterTest( ) {

        try {

            DSPCalculator calc = DSPFactory.newDSPCalculator( 1 );

            FileWriter out1 = new FileWriter( "FilterTest001.csv" );
            FileWriter out2 = new FileWriter( "FilterTest002.csv" );
            FileWriter out3 = new FileWriter( "FilterTest003.csv" );

            // Read the data from input file and package into the RawData object
            FileReader fr = new FileReader( "waveform1a.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Integer> data = new Vector<Integer>();
            while( (s = br.readLine()) != null ) {
                data.add( Integer.parseInt( s ) );
            }

            int[] arrIn = new int[data.size()];
            for( int i = 0; i < data.size(); i++ ) {
                arrIn[i] = data.elementAt( i ).intValue();
            }

            RawData rawData = new RawData( 1 );
            rawData.setChannelId( 1 );
            rawData.setSamplingRate( 1000 );
            rawData.setDateTimeStamp( new java.util.Date( System.currentTimeMillis() ) );
            rawData.setData( arrIn );

            ChannelState state = calc.processData( rawData, null );

            ProcessedData dynData = state.getProcessedData( "Acceleration, G" );
            for( int j = 0; j < dynData.getData().size(); j++ ) {
                out1.write( dynData.getData().get( j ).toString() + '\n' );
            }

            dynData = state.getProcessedData( "Frequency (A)" );
            for( int j = 0; j < dynData.getData().size(); j++ ) {
                out2.write( dynData.getData().get( j ).toString() + '\n' );
            }

            Filter filter = new ButterHighPassFilter();
            List<Double> filtered = filter.filter( state.getProcessedData( "Acceleration, G" ).getData(),
                                                   state.getProcessedData( "Acceleration, G" ).getSamplingRate());
            FFTTransformer transformer = new DefaultFFTTransformer();
            List<Double> filteredThenTransformed = transformer.FFTTransform( filtered );

            for( int j = 0; j < filteredThenTransformed.size(); j++ ) {
                out3.write( filteredThenTransformed.get( j ).toString() + '\n' );
            }

            fr.close();
            out1.close();
            out2.close();
            out3.close();

        }
        catch( Exception e ) {
            e.printStackTrace( System.out );
        }

    }

    // test that the DSP is ready for integration
    // it will evolve, but end-to-end test is needed
    protected static void DSPIntegrationPreTest( ) {

        try {

            DSPCalculator calc = DSPFactory.newDSPCalculator( 1000 ); // 4 - Static, 11 or 1 - Dynamic

            FileWriter out1 = new FileWriter( "InterTest001.csv" );
            FileWriter out2 = new FileWriter( "InterTest002.csv" );

            // Read the data from input file and package into the RawData object
            FileReader fr = new FileReader( "SimulatedData11508t.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Integer> data = new Vector<Integer>();
            while( (s = br.readLine()) != null ) {
                data.add( Integer.parseInt( s ) );
            }

            int[] arrIn = new int[data.size()];
            for( int i = 0; i < data.size(); i++ ) {
                arrIn[i] = data.get( i ).intValue();
            }

            RawData rawData = new RawData( 4 );
            rawData.setChannelId( 4 );
            rawData.setSamplingRate( 5000 );
            rawData.setDateTimeStamp( new java.util.Date( System.currentTimeMillis() ) );
            rawData.setData( arrIn );

            ChannelState state = calc.processData( rawData, null );

            // print overalls
            /*
             * out1.write("RMS," + state.getOverallLevels().getRms().toString() + '\n'); out1.write("True Peak," +
             * state.getOverallLevels().getTruePeak().toString() + '\n'); out1.write("Derived Peak," +
             * state.getOverallLevels().getDerivedPeak().toString() + '\n'); out1.write("True Peak To Peak," +
             * state.getOverallLevels().getTruePeakToPeak().toString() + '\n'); out1.write("Derived Peak To Peak," +
             * state.getOverallLevels().getDerivedPeakToPeak().toString() + '\n');
             */

            // print dynamic processed data into different files
            for( int i = 0; i < state.getMethodKeys().size(); i++ ) {
                String methodKey = state.getMethodKeys().get( i );
                ProcessedData dynData = state.getProcessedData( methodKey );
                FileWriter out = new FileWriter( "SimulatedData11508t_" + methodKey + "_" + (i + 1) + "_.csv" );
                out.write( "rpm," + state.getRpm() + '\n' );
                out.write( "Method Key," + methodKey + '\n' );
                out.write( "Channel Id," + dynData.getChannelId() + '\n' );
                out.write( "Data Units," + dynData.getEU() + '\n' );
                out.write( "Sampling Rate," + dynData.getSamplingRate() + '\n' );
                out.write( "Time Stamp," + dynData.getDateTimeStamp() + '\n' );
                // Overalls
                out.write( "Overall - RMS," + dynData.getOveralls().getOverall( "RMS" ) + '\n' );
                out.write( "Overall - Accel Peak," + dynData.getOveralls().getOverall( "Accel Peak" ) + '\n' );
                out.write( "Overall - Derived Peak," + dynData.getOveralls().getOverall( "Derived Peak" ) + '\n' );
                out.write( "Overall - Derived Peak To Peak,"
                           + dynData.getOveralls().getOverall( "Derived Peak To Peak" ) + '\n' );
                out.write( "Overall - Accel Peak To Peak," + dynData.getOveralls().getOverall( "Accel Peak To Peak" )
                           + '\n' );

                for( int j = 0; j < dynData.getData().size(); j++ ) {
                    out.write( dynData.getData().get( j ).toString() + ',' );
                    out.write( dynData.getDataLabels().get( j ).toString() + '\n' );
                }

                out.close();
            }

            if( calc.isDebugMode() ) {
                DSPCoreDump dspCoreDump = calc.getDspCoreDump();
                List<List<Double>> dataSets = dspCoreDump.getDataSets();
                List<String> dataSetLabels = dspCoreDump.getDataSetLabels();
                List<String> metaData = dspCoreDump.getMetaData();

                FileWriter out01 = new FileWriter( "DSPCoreDumpMetaData" + dspCoreDump.getChannelId() + ".csv" );
                for( int i = 0; i < metaData.size(); i++ ) {
                    out01.write( metaData.get( i ) + '\n' );
                }
                out01.close();

                FileWriter out02 = new FileWriter( "DSPCoreDumpDataSets" + dspCoreDump.getChannelId() + ".csv" );
                for( int i = 0; i < dataSetLabels.size(); i++ ) {
                    out02.write( dataSetLabels.get( i ) + ',' );
                }
                out02.write( '\n' );

                int max = dspCoreDump.getMaxDataSetLength();
                for( int i = 0; i < max; i++ ) {
                    for( int j = 0; j < dataSets.size(); j++ ) {
                        try {
                            out02.write( dataSets.get( j ).get( i ) + "," );
                        }
                        catch( Exception e ) {
                            out02.write( " ," );
                        }
                    }
                    out02.write( '\n' );
                }

                out02.close();
            }

            fr.close();
            out1.close();
            out2.close();

        }
        catch( Exception e ) {
            e.printStackTrace( System.out );
        }
    }

    protected static void DSPStaticChannelTest( ) {

        try {

            DSPCalculator calc = DSPFactory.newDSPCalculator( 11 );

            // Read the data from input file and package into the RawData object
            FileReader fr = new FileReader( "StaticChannelTest001.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Integer> data = new Vector<Integer>();
            while( (s = br.readLine()) != null ) {
                data.add( Integer.parseInt( s ) );
            }

            int[] arrIn = new int[data.size()];
            for( int i = 0; i < data.size(); i++ ) {
                arrIn[i] = data.get( i ).intValue();
            }

            RawData rawData = new RawData( 1 );
            rawData.setChannelId( 1 );
            rawData.setSamplingRate( 1000 );
            rawData.setDateTimeStamp( new java.util.Date( System.currentTimeMillis() ) );
            rawData.setData( arrIn );

            ChannelState state;

            for( int k = 0; k < 14; k++ ) {

                state = calc.processData( rawData, null );

                // print static processed data into different files
                for( int i = 0; i < state.getMethodKeys().size(); i++ ) {
                    String methodKey = state.getMethodKeys().get( i );
                    ProcessedData dynData = state.getProcessedData( methodKey );
                    FileWriter out = new FileWriter( "InterTestStatic" + (k) + "_" + (i + 3) + ".csv" );
                    out.write( "Method Key," + methodKey + '\n' );
                    out.write( "Channel Id," + dynData.getChannelId() + '\n' );
                    out.write( "Data Units," + dynData.getEU() + '\n' );
                    out.write( "Sampling Rate," + dynData.getSamplingRate() + '\n' );
                    out.write( "Time Stamp," + dynData.getDateTimeStamp() + '\n' );
                    out.write( "Overall," + dynData.getOveralls().getOverall( "T" ) + '\n' );

                    for( int j = 0; j < dynData.getData().size(); j++ ) {
                        out.write( dynData.getData().get( j ).toString() + '\n' );
                    }

                    out.close();
                }
            }

        }
        catch( Exception e ) {
            e.printStackTrace( System.out );
        }
    }

    protected static void ResamplerTest01( ) {

        try {

            // DSPCalculator calc = DSPFactory.newDSPCalculator( 11 );

            FileWriter out1 = new FileWriter( "ResampleTest01out.csv" );

            FileReader fr = new FileReader( "ResampleTest01.csv" );
            BufferedReader br = new BufferedReader( fr );
            String s;
            Vector<Double> data = new Vector<Double>();
            while( (s = br.readLine()) != null ) {
                data.add( Double.parseDouble( s ) );
            }

            LinearInterpolationResampler resampler = new LinearInterpolationResampler();

            List<Double> resampled = resampler.resampleRadix2( data, 16, 35, null );

            for( int i = 0; i < resampled.size(); i++ ) {
                out1.write( resampled.get( i ).toString() + '\n' );
            }

            fr.close();
            out1.close();

        }
        catch( Exception e ) {
            e.printStackTrace( System.out );
        }
    }

    /*
     * protected static void UnitConvTest01() { try { DSPDynamicCalculator calc = new DSPDynamicCalculator(1);
     * FileWriter out1 = new FileWriter("SensTest001Volts.csv"); FileWriter out2= new FileWriter("SensTest001Gs.csv");
     * FileReader fr = new FileReader("SensTest001.csv"); BufferedReader br = new BufferedReader(fr); String s; Vector<Integer>
     * data = new Vector<Integer>(); while((s = br.readLine()) != null) { data.add(Integer.parseInt(s)); } int[] arrIn =
     * new int[data.size()]; for (int i=0; i<data.size(); i++) { arrIn[i] = data.get(i).intValue(); } Vector<Double>
     * volts = calc.convertToVolts(arrIn); Vector<Double> gs = calc.convertToGs(arrIn); for (int i=0; i < volts.size();
     * i++) { out1.write(volts.get(i).toString() + '\n'); } for (int i=0; i < gs.size(); i++) {
     * out2.write(gs.get(i).toString() + '\n'); } fr.close(); out1.close(); out2.close(); } catch (Exception e) {
     * e.printStackTrace(System.out); } }
     */

    /*
     * protected static void IntegrationTest01() { try { DSPDynamicCalculator calc = new DSPDynamicCalculator(1);
     * FileWriter out1 = new FileWriter("SensTest001Intgr.csv"); FileReader fr = new FileReader("SensTest001Gs.csv");
     * BufferedReader br = new BufferedReader(fr); String s; Vector<Double> data = new Vector<Double>(); while((s =
     * br.readLine()) != null) { data.add(Double.parseDouble(s)); } Vector<Double> velocities =
     * calc.integrateAtoV(data, 1000); for (int i=0; i < velocities.size(); i++) {
     * out1.write(velocities.get(i).toString() + '\n'); } fr.close(); out1.close(); } catch (Exception e) {
     * e.printStackTrace(System.out); } }
     */

    /*
     * protected static void FFTTest00() { try { Vector<Double> data = new Vector<Double>(1024); Vector<Double>
     * fftData; FileWriter fftOut = new FileWriter("fft1b.csv"); FileReader fr = new FileReader("waveform1.csv");
     * BufferedReader br = new BufferedReader(fr); String s; while((s = br.readLine()) != null) {
     * data.add(Double.parseDouble(s)); } //if (data.size() > 1024) data.removeElementAt(1024); if (data.size() > 2048)
     * data.removeElementAt(2048); //if (data.size() > 4096) data.removeElementAt(4096); //if (data.size() > 8192)
     * data.removeElementAt(8192); ProcessedDynamicData dynData = new ProcessedDynamicData(1); DSPDynamicCalculator calc =
     * new DSPDynamicCalculator(1); dynData.setData(data); fftData = calc.fftTransform(dynData); for (int i=0; i <
     * fftData.size(); i++) { fftOut.write(fftData.get(i).toString() + '\n'); } fr.close(); fftOut.close(); } catch
     * (Exception e) { e.printStackTrace(System.out); } } /* protected static void FFTTest01() { try { Vector<Double>
     * data = new Vector<Double>(1024); Vector<Double> fftData; FileWriter fftOut = new
     * FileWriter("SensTest001WeightFFT.csv"); FileReader fr = new FileReader("SensTest001Resampled.csv");
     * BufferedReader br = new BufferedReader(fr); String s; while((s = br.readLine()) != null) {
     * data.add(Double.parseDouble(s)); } //if (data.size() > 1024) data.removeElementAt(1024); if (data.size() > 2048)
     * data.removeElementAt(2048); //if (data.size() > 4096) data.removeElementAt(4096); //if (data.size() > 8192)
     * data.removeElementAt(8192); ProcessedDynamicData dynData = new ProcessedDynamicData(1); DSPDynamicCalculator calc =
     * new DSPDynamicCalculator(1); dynData.setData(data); fftData = calc.WeightAndFFTTransform(dynData); for (int i=0;
     * i < fftData.size(); i++) { fftOut.write(fftData.get(i).toString() + '\n'); } fr.close(); fftOut.close(); } catch
     * (Exception e) { e.printStackTrace(System.out); } } /* protected static void resamplerTest00 () { //
     * System.out.println(((double) 8 / (double) 3 )); // System.out.println(Math.sin((double) 2.5)); try { Resampler
     * rsmpl = DSPFactory.newResampler(1); // TEST # 1: use one-half period of sin() to generate sample data points //
     * then apply resampling with factors or 2.7, .7, 1, 2, 35.7 FileWriter initalSampleOut = new
     * FileWriter("initialSamples.txt"); FileWriter resampledOut_2_7 = new FileWriter("Resampled_2_7.txt"); FileWriter
     * resampledOut_0_7 = new FileWriter("Resampled_0_7.txt"); FileWriter resampledOut_1 = new
     * FileWriter("Resampled_1.txt"); FileWriter resampledOut_2 = new FileWriter("Resampled_2.txt"); FileWriter
     * resampledOut_35_7 = new FileWriter("Resampled_35_7.txt"); FileWriter resampledOut_407 = new
     * FileWriter("Resampled_407.txt"); FileWriter resampledOutSlices = new FileWriter("ResampledWSlices.txt"); Vector<Double>
     * sampleSet = new Vector<Double>(0); Vector<Double> resampledSet = new Vector<Double>(0); // these are used in
     * TEST # 2 Vector<Double> sampleSetWT = new Vector<Double>(0); Vector<Integer> triggers = new Vector<Integer>(0); //
     * Generate sample data set based on SIN() function for (int i=1; Math.sin((double) i / 1000) > 0; i++) {
     * sampleSet.add(Math.sin((double) i / 1000)); } for (int i=0; i < sampleSet.size(); i++) {
     * initalSampleOut.write(sampleSet.get(i).toString() + '\n'); // TEST #2 - pad with slice that will be thrown away
     * //sampleSetWT.add(sampleSet.get(i)); //triggers.add(new Integer(0)); } resampledSet = rsmpl.resample(sampleSet,
     * 2.7f); for (int i=0; i < resampledSet.size(); i++) { resampledOut_2_7.write(resampledSet.get(i).toString() +
     * '\n'); // TEST #2 sampleSetWT.add(resampledSet.get(i)); if (i == 0) triggers.add(new Integer(1)); else
     * triggers.add(new Integer(0)); } resampledSet.clear(); resampledSet = rsmpl.resample(sampleSet, 0.7f); for (int
     * i=0; i < resampledSet.size(); i++) { resampledOut_0_7.write(resampledSet.get(i).toString() + '\n'); // TEST #2
     * sampleSetWT.add(resampledSet.get(i)); if (i == 0) triggers.add(new Integer(1)); else triggers.add(new
     * Integer(0)); } resampledSet.clear(); resampledSet = rsmpl.resample(sampleSet, 1f); for (int i=0; i <
     * resampledSet.size(); i++) { resampledOut_1.write(resampledSet.get(i).toString() + '\n'); // TEST #2
     * sampleSetWT.add(resampledSet.get(i)); if (i == 0) triggers.add(new Integer(1)); else triggers.add(new
     * Integer(0)); } resampledSet.clear(); resampledSet = rsmpl.resample(sampleSet, 2f); for (int i=0; i <
     * resampledSet.size(); i++) { resampledOut_2.write(resampledSet.get(i).toString() + '\n'); // TEST #2
     * sampleSetWT.add(resampledSet.get(i)); if (i == 0) triggers.add(new Integer(1)); else triggers.add(new
     * Integer(0)); } resampledSet.clear(); resampledSet = rsmpl.resample(sampleSet, 35.7f); for (int i=0; i <
     * resampledSet.size(); i++) { resampledOut_35_7.write(resampledSet.get(i).toString() + '\n'); // TEST #2
     * sampleSetWT.add(resampledSet.get(i)); if (i == 0) triggers.add(new Integer(1)); else triggers.add(new
     * Integer(0)); } resampledSet.clear(); resampledSet = rsmpl.resample(sampleSet, 407f); for (int i=0; i <
     * resampledSet.size(); i++) { resampledOut_407.write(resampledSet.get(i).toString() + '\n'); // TEST #2 - pad with
     * slice that will be thrown away //sampleSetWT.add(resampledSet.get(i)); //triggers.add(new Integer(0)); }
     * resampledSet.clear(); initalSampleOut.close(); resampledOut_2_7.close(); resampledOut_0_7.close();
     * resampledOut_1.close(); resampledOut_2.close(); resampledOut_35_7.close(); resampledOut_407.close(); // TEST #2:
     * Use arrays of various length collected in TEST # 1 // to test re-sampling with slicing int destinationSize = 200; //
     * <-- the length of re-sampled arrays int[] arrTrigger = new int[triggers.size()]; for (int i=0; i <
     * triggers.size(); i++) arrTrigger[i] = triggers.get(i).intValue(); Vector<Vector<Double>> resampledWithSlices =
     * rsmpl.resample(sampleSetWT, arrTrigger, destinationSize); for (int i=0; i < resampledWithSlices.size(); i++) {
     * for (int j=0; j < destinationSize; j++) { resampledOutSlices.write(resampledWithSlices.get(i).get(j).toString() +
     * '\n'); } } resampledOutSlices.close(); } catch (Exception e) { e.printStackTrace(System.out); } }
     */

    /*
     * protected static void overallsCalcTest01() { try { DSPDynamicCalculator calc = new DSPDynamicCalculator(1);
     * FileWriter out1 = new FileWriter("SensTest001Overalls.csv"); FileReader fr = new
     * FileReader("SensTest001Intgr.csv"); BufferedReader br = new BufferedReader(fr); String s; Vector<Double> data =
     * new Vector<Double>(); while((s = br.readLine()) != null) { data.add(Double.parseDouble(s)); }
     * ProcessedDynamicData processedData = new ProcessedDynamicData(); processedData.setSamplingRate(1000);
     * processedData.setChannelId(1); processedData.setData(data); OverallLevels overalls =
     * calc.calculateOverallLevels(processedData); out1.write("RMS," + overalls.getRms().toString() + '\n');
     * out1.write("True Peak," + overalls.getTruePeak().toString() + '\n'); out1.write("Derived Peak," +
     * overalls.getDerivedPeak().toString() + '\n'); out1.write("True Peak To Peak," +
     * overalls.getTruePeakToPeak().toString() + '\n'); out1.write("Derived Peak To Peak," +
     * overalls.getDerivedPeakToPeak().toString() + '\n'); fr.close(); out1.close(); } catch (Exception e) {
     * e.printStackTrace(System.out); } }
     */
}
