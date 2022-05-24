#!/bin/bash

SourceDirectory=$1
DestinedDirectory=$2
TargetCompression=5

mkdir -p "$DestinedDirectory"

find "$SourceDirectory" -type f -print0 | while read -d $'\0' FoundFile
do
  echo "Processing" $FoundFile

  OutputFile=$DestinedDirectory${FoundFile#"$SourceDirectory"}
  OutputDirectory=$(dirname "$OutputFile")

  if [[ "$FoundFile" == *.flac ]]
  then
    mkdir -p "$OutputDirectory"/spectrals/
    OutputFile=${OutputFile%.flac}.flac
    OutputBasename=$(basename "$OutputFile")
    sox "$FoundFile" -C $TargetCompression -S -G -V3 -b 16 "$OutputFile" rate 44100 dither -s
    sox "$OutputFile" -n spectrogram -o "$OutputDirectory/spectrals/${OutputBasename%.flac}.jpg"
  else
    mkdir -p "$OutputDirectory"
    cp "$FoundFile" "$OutputFile"
  fi

  echo "Saved as" $OutputFile
done
### dithering:
#Effect usage:

#dither [-S|-s|-f filter] [-a] [-p precision]
#  (none)   Use TPDF
#  -S       Use sloped TPDF (without noise shaping)
#  -s       Shape noise (with shibata filter)
#  -f name  Set shaping filter to one of: lipshitz, f-weighted,
#           modified-e-weighted, improved-e-weighted, gesemann,
#           shibata, low-shibata, high-shibata.
#  -a       Automatically turn on & off dithering as needed (use with caution!)
#  -p bits  Override the target sample precision
