#!/usr/bin/env bash

# Execute wl-paste and store the output in a variable
clipboard_content=$(wl-paste)

# Translate the clipboard content from English to Simplified Chinese using `trans`
translated_content=$(echo "$clipboard_content" | trans :zh)

# Remove ANSI escape codes from the translated content using `sed`
cleaned_content=$(echo "$translated_content" | sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g")

# Print the final cleaned content
echo "$cleaned_content"
