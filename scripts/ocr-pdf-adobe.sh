#!/bin/bash

input_filepath=$1
output_filepath=$2

cp $input_filepath $output_filepath

echo "Processing $input_filepath"

echo "empty" | pbcopy

first_char="$(head -c 1 $input_filepath)"

if [[ $first_char == "%" ]]; then

osascript <<EOF

try
    with timeout of 10 seconds
        tell application "Adobe Acrobat"
            activate
            open POSIX file "$output_filepath"
            activate
        end tell
    end timeout

    tell application "System Events"
        keystroke "a" using command down
        delay 1
        if exists (window "Scanned Page Alert" of process "Acrobat Pro DC") then
            key code 36 -- hit yes to pop-up dialog
            delay 1
            key code 36 -- hit yes to OCR box
            delay 60
            keystroke "q" using command down
            delay 2
            key code 36 -- hit save
            delay 5
        else
            tell application "Adobe Acrobat" to quit
        end if
    end tell
on error
    tell application "System Events"
        key code 36
    end tell

    tell application "Adobe Acrobat" to quit
end try

delay 3
EOF

echo "Finished and output to $output_filepath"

else

echo "Not a pdf, skipping: $input_filepath"

fi




