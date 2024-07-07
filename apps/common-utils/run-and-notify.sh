#!/bin/bash -e

if [ $1 -eq 0 ]; then
  afplay /System/Library/Sounds/Hero.aiff
else
  afplay /System/Library/Sounds/Basso.aiff
fi
