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

SoX's documentation lags far behind current development. I haven't been able to find the latest syntax for the "rate" (resample) effect anywhere else on the web, so here it is, as I understand it from examining the code:

rate "[<quality-level>] [<override-options>] <rate>"
