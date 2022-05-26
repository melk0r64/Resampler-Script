#!/bin/bash

SourceDirectory=$1
DestinedDirectory=$2
TargetCompression=5
BitRate=192000
TAPS=64000000

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
#    sox "$FoundFile" -C $TargetCompression -S -G -V6 -b 24 "$OutputFile" rate -u -b 99.9 -I $BitRate
#    sox "$FoundFile" -C $TargetCompression -S -G -V6 -b 24 "$OutputFile" rate -u -s -b 99.9 -L $BitRate
#    sox "$FoundFile" -C $TargetCompression -S -G -V6 -b 24 "$OutputFile" rate -v -s -b 90 $BitRate
#    sox "$FoundFile" -C $TargetCompression -S -G -V3 -b 24 "$OutputFile" lowpass -2 21000 rate -v -s -b 90 $BitRate
########################################################################################################################
#    sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" upsample 4 sinc -22050 -n $TAPS -L -b 0 vol 2
     sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" upsample 4 sinc -22050 -n $TAPS -L -b 12.5 vol 2
########################################################################################################################
#    sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" upsample 4 sinc -a80 -L -21k -n $TAPS
#    sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" upsample 2 sinc -a80 -L -21k -n $TAPS
#    sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" upsample 4 sinc -a80 -L -20k -n $TAPS
#    sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" sinc -a80 -I -21.5k -t8000
########################################################################################################################
#    sox -S -V6 "$FoundFile" -b 24 -r $BitRate "$OutputFile" lowpass -2 21000 upsample 4 sinc -22050 -n $TAPS -b 0 vol 3


#    sox "$OutputFile" -n spectrogram -o "$OutputDirectory/spectrals/${OutputBasename%.flac}.jpg"
  else
    mkdir -p "$OutputDirectory"
    cp "$FoundFile" "$OutputFile"
  fi

  echo "Saved as" $OutputFile
done
