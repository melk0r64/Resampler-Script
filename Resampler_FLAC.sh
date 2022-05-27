#Batch modified from https://gist.github.com/jorgehatccrma/24786ee7fc8158e7bd1b010d7cf34bbe
#!/bin/bash

SourceDirectory=$1
DestinedDirectory=$2
TargetCompression=5
BitRate=176400

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
    sox "$FoundFile" -C $TargetCompression -S -G -V3 -b 24 "$OutputFile" lowpass -2 21000 rate -v -s -b 90 $BitRate
    sox "$OutputFile" -n spectrogram -o "$OutputDirectory/spectrals/${OutputBasename%.flac}.jpg"
  else
    mkdir -p "$OutputDirectory"
    cp "$FoundFile" "$OutputFile"
  fi

  echo "Saved as" $OutputFile
done

#Effect usage:

#lowpass [-1|-2] frequency [width[q|o|h|k]](0.707q)
