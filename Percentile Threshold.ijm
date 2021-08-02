/*
 * This macro will threshold your image based on a percentile setting. 
 * A maximum of the x-percentile of pixels will pass the threshold.
 * By changing the percentile and bins settings you can control the range and precision of the threshold.
 * Works on selections if present.
 */

/** 
 * Here you can change the percentile. 
 * Any pixel that has a value that falls above this percentile cut-off will pass the threshold 
 */
 percentage = 90; 

/** 
 * Here you can change the precision of the precentile division. A lower setting will be less precise.
 * Note that a setting over the number of values for your image depth makes no sense (i.e. 256 for 8-bits and 4096 for 12-bits).
 */
nBins = 256; 

/** 
 * Is the background black with a light foreground or, vice-versa, is the background light with a increasingly darker foreground?
 * Set this as true (black background) or false (white background) depending on your image.
 */
blackBackground = true;

// Reset windows/level to standard
resetMinAndMax(); 

// Get the histogram according the the precision settings
getHistogram(values, counts, nBins); 

// Find the number of pixels (needed for selections)
nPixels = 0; 
for (i = 0; i<counts.length; i++)
{
  nPixels += counts[i]; 
}

// Calculate the number of pixels that need to be thresholded away to keep the given percentile as left-over
nBelowThreshold = nPixels * percentage / 100; 

sum = 0; 
for (i = 0; i < counts.length; i++) { 
	// Increase the potential threshold setting by one each time and see how many pixels havw been thesholded away.
	sum = sum + counts[i]; 
	if (sum >= nBelowThreshold) // Stop when percentile is reached (or exceeded)
	{ 
		setThreshold(values[i + 1], values[255]); // Set the value found and up as threshold
		setOption("BlackBackground", blackBackground);
		run("Convert to Mask");
		print(values[0]+"-"+values[i]+": "+sum/nPixels*100+"%"); 
		i = 99999999; // break the loop
	} 
} 