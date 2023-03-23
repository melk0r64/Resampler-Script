#!/bin/bash

# Validate input
if [[ ! -d "$1" ]]; then
  echo "Source directory '$1' does not exist or is not a directory"
  exit 1
fi

if [[ ! -d "$2" ]]; then
  echo "Destination directory '$2' does not exist or is not a directory"
  exit 1
fi

# Resolve source and destination directories to full paths
SourceDirectory=$(readlink -f "$1")
DestinedDirectory=$(readlink -f "$2")

# Use printf instead of echo
printf "Processing files in '%s'...\n" "$SourceDirectory"

# Loop through all files in source directory
find "$SourceDirectory" -type f -print0 | while read -d $'\0' FoundFile
do
  printf "Processing '%s'...\n" "$FoundFile"

  OutputFile="$DestinedDirectory$(basename "$FoundFile")"
  OutputDirectory=$(dirname "$OutputFile")

  if [[ "$FoundFile" == *.flac ]]
  then
    # Use mkdir -p for all directories
    mkdir -p "$OutputDirectory/spectrals"
    OutputFile=${OutputFile%.flac}.flac

    # Add error handling
    if ! sox "$FoundFile" -C $TargetCompression -S -G -V3 -b 16 "$OutputFile" rate 44100 dither -s; then
      echo "Error: Failed to process '$FoundFile'"
      continue
    fi

    # Add error handling
    if ! sox "$OutputFile" -n spectrogram -o "$OutputDirectory/spectrals/$(basename "${OutputFile%.flac}").jpg"; then
      echo "Error: Failed to create spectrogram for '$FoundFile'"
      continue
    fi
  else
    # Use mkdir -p for all directories
    mkdir -p "$OutputDirectory"
    cp "$FoundFile" "$OutputFile"
  fi

  printf "Saved as '%s'\n" "$OutputFile"
done



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
