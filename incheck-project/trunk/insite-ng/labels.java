// Here are two pieces of code showinhg how to calculate the graph labels for waveform and spectrum functions

// Labels for time waveform in default units (seconds)
{
int SR = data.get("SamplingRate"); //this will be passed to a function
int size = data.get("timeData").length;
double[] labels;
double step = 1/SR;

	for (int i = 0; i < size; i++) {
		labels.push(i*step);
	}

return labels;
}

//Labels for frequency spectrum in default units (hertz)
{
int SR = data.get("SamplingRate"); //this will be passed to a function
int size = data.get("spectrumData").length; //this is the length of the spectrum array before size reduction for plotting
double[] labels;
double step = SR/(2*size);

	for (int i = 0; i < size; i++) {
		labels.push(i*step);
	}

return labels;
}
