# Sox Resampler Script
Batch script for massive resampler with Sox

ex. /ResamplerDSD.sh /mnt/c/Resampler /mnt/c/Resampler/Resampled

For sox git
https://github.com/mansr/sox

For sox-dsd check
https://www.audiofaidate.org/sw/sox-dsd/

For sox and dsd test check:
http://archimago.blogspot.com/2021/10/measurements-look-at-dsd-and-using-sox.html

Sox Taps Modified
https://github.com/rhgg2/sox.git

Sox Info Filter
https://www.diyaudio.com/community/threads/beginners-filter-brewing-thread-for-the-soekris-r2r.271927/


Sox parameter
https://forums.slimdevices.com/showthread.php?105309-C-3PO-plugin-a-trnscoding-helper&p=982220&viewfull=1#post982220

SoX's documentation lags far behind current development. I haven't been able to find the latest syntax for the "rate" (resample) effect anywhere else on the web, so here it is, as I understand it from examining the code:

rate "quality-level" "override-options" "rate"
  
The higher the quality level, the more compute power is required.

The quality-level options are as follows. If none is chosen, the default is "-h" (high):

-q = quick
-l = low
-m = medium
-g = medium-high
-h = high
-e = extra
-v = very high
-u = ultra
 
These quality levels set the resampler parameters to:

filter phase = linear (50%)
anti-aliasing bandwidth percentage = 100 (no aliasing above the audio passband)

bandwidth, noise rejection, bit depth, and allowed passband rolloff are set according to this table:

![immagine](https://user-images.githubusercontent.com/106148952/170472776-1b572a6d-880e-4708-8a2f-dac897762eab.png)


  
The override-options parameters, if provided, will override the values in the above table. In the following list of override options, the options in each group are mutually exclusive. For example, you can use -s, or -b <n>, or -B <n>, or none of those three, but you cannot use any combination of -s, -b, and -B.

Quality:

    -Q <0 .. 7> = optional numeric method of specifying quality; numerals correspond to q|l|m|g|h|e|v|u


Filter Phase:

    -M = minimum (0%)
    -I = intermediate (25%)
    -L = linear (50%)
    -p <0 .. 100> = specified percentage (values between 50 and 100 are unlikely to be useful)


Allow Aliasing:

    -a = above the -3 dB audio passband
    -A <85 .. 100> = above a specified bandwidth percentage


Bandwidth (Audio Passband Percentage):

    -s = -3 dB 99% (steep filter)
    -b <74 .. 99.7> = -3 dB percentage
    -B <53 .. 99.5> = 0 dB percentage


Noise Rejection / Bit Depth:

    -R <90 .. 200> = noise rejection dB
    -d <15 .. 33> = bit depth


Passband Rolloff:

    -f = 0 dB (no passband rolloff allowed)  
  
  
  
The following override-options parameters are also supported, but they merely change the internal implementation of certain aspects of the resampler. They are for software testing and development, and are not intended to have any effect on the sound:

-t = use high-precision clock (i.e., use a double-precision floating-point number, rather than a fixed-point Q32.32 number, to express the ratio between output and input sample rates). Apparently intended for testing weird resampler use-cases like continuously variable sampling rates. Has no effect on C-3PO's sampling-rate conversions.

-i <-1 .. 2> = force a particular coefficient interpolator

-c <100 .. INT_MAX> = for certain values of the -i parameter, set maximum amount (in approximately kilobytes) of memory used for coefficients

-n: no small integer optimization  
  
