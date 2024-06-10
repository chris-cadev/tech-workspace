#!/bin/bash

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/christiancamacho/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
