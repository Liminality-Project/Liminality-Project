#!/usr/bin/env bash

logo=Liminality-Logo.png
icon=Liminality-Icon.png

for size in 16 24 32 48 64
do
  out=icon/icon-${size}x${size}.png
  magick $icon -trim -background none -resize $size $out
done

for size in 128 256
do
  out=icon/icon-${size}x${size}.png
  magick $logo -trim -background none -resize $size $out
done

cp icon/icon-256x256.png logo.png
magick $logo -trim -background none -resize 512 $out
magick icon/* -channel Alpha icon.ico