#!/bin/bash

SourceDirectory=$1
DestinedDirectory=$2
#DSD64=rate -v 2822400
#DSD128=rate -v 5644800

#choose clans-4, 6, 8 and sdm-4, 6, 8
#sox "$FoundFile" -V3 -b 1 "$OutputFile" rate -v 2822400 sdm -f clans-8
#sox "$FoundFile" -V3 -b 1 "$OutputFile" rate -v 2822400 sdm -f sdm-8

mkdir -p "$DestinedDirectory"

find "$SourceDirectory" -type f -print0 | while read -d $'\0' FoundFile
do
  echo "Processing" $FoundFile

  OutputFile=$DestinedDirectory${FoundFile#"$SourceDirectory"}
  OutputDirectory=$(dirname "$OutputFile")

  if [[ "$FoundFile" == *.flac ]]
  then
    mkdir -p "$OutputDirectory"/spectrals/
    OutputFile=${OutputFile%.flac}.dsf
    OutputBasename=$(basename "$OutputFile")
    sox "$FoundFile" -V3 -b 1 "$OutputFile" rate -v 2822400 sdm -f sdm-8
    sox "$OutputFile" -n spectrogram -o "$OutputDirectory/spectrals/${OutputBasename%.dsf}.jpg"
  else
    mkdir -p "$OutputDirectory"
    cp "$FoundFile" "$OutputFile"
  fi

  echo "Saved as" $OutputFile
done
