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
    OutputFile=${OutputFile%.flac}.dsf
    OutputBasename=$(basename "$OutputFile")
    sox "$FoundFile" -V3 -b 1 "$OutputFile" rate -v 2822400 sdm -f sdm-8
  else
    mkdir -p "$OutputDirectory"
    cp "$FoundFile" "$OutputFile"
  fi

  echo "Saved as" $OutputFile
done
