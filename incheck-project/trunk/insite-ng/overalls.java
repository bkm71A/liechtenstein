    private OverallLevels calculateOverallLevels(ProcessedData data) {

        if( (data == null) || (data.getData() == null) || (data.getData().size() < 1) ) {
            logger
                  .debug( "ALERTSTEST: empty pants because of (data == null) || (data.getData() == null) || (data.getData().size() < 1)" );
            return new OverallLevels( this.channelId );
        }
        else {
            logger.debug( "ALERTSTEST: no issues with pants" );
        }

        List<Double> samples = data.getData();

        // loop through sample data bins: calculate sum, max and min
        double sumSq = 0;
        double max = samples.get( 0 );
        double min = samples.get( 0 );
        double rms = 0;
		double pk = 0;
		double p2p = 0;
		double[] overalls = new Array();

        for( Double sample : samples ) {
            sumSq = sumSq + sample * sample;
            if( sample > max ) {
                max = sample;
            }
            if( sample < min ) {
                min = sample;
            }
        }
		
		//calculate overalls
        rms = Math.sqrt( sumSq / samples.size() ); // Calculate RMS
		pk = (Math.abs(max)>Math.abs(min))?Math.abs(max):Math.abs(min);
		p2p = max - min;

        double[] overalls = {rms, pk, p2p};
        return overalls;
    }