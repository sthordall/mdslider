#!/usr/bin/env bash

root="$(dirname "$(readlink -f "$0")")"

RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if [[ "$#" -ne 6 ]]; then
  echo "Expected arguments are missing: SLIDES_FILE TARGET_DIR PORT THEME TRANSITION TITLE"
  echo ""
  echo "Example:"
  echo -e "  ${CYAN}mdslider${YELLOW} slides.md ./out 8080 sky concave \"Super cool slides\"${NC}"
  echo ""
  echo -e "${YELLOW}Supported themes:${NC} beige, black, blood, league, moon, night, serif, simple, sky, solarized, white"
  echo -e "${YELLOW}Supported transitions:${NC} none, fade, slide, convex, concave, zoom"
  exit 1
fi

slides=$1
target=$2
port=$3
theme=$4
transition=$5
title=$6

if [ ! -f "$slides" ]; then
  echo -e "${RED}ERROR:${YELLOW} supplied slides file does not exist${NC}"
  exit 1
fi

if [ ! -d "$target" ]; then
  mkdir -p "$target"
  exit_code=$?
  if [ "$exit_code" -ne 0 ]; then
    echo -e "${RED}ERROR:${YELLOW} cannot create target directory${NC}"
    exit $exit_code
  fi
fi

theme_exists=$(case "$theme" in "beige") echo 1; ;; "black") echo 1; ;; "blood") echo 1; ;; "league") echo 1; ;; "moon") echo 1; ;; "night") echo 1; ;; "serif") echo 1; ;; "simple") echo 1; ;; "sky") echo 1; ;; "solarized") echo 1; ;; "white") echo 1; ;; *) echo 0; ;; esac)
if [ "$theme_exists" -eq "0" ]; then
  echo -e "${RED}ERROR:${YELLOW} supplied theme does not exist${NC}"
  exit 1
fi

transition_exists=$(case "$transition" in "none") echo 1; ;; "fade") echo 1; ;; "slide") echo 1; ;; "convex") echo 1; ;; "concave") echo 1; ;; "zoom") echo 1; ;; *) echo 0; ;; esac)
if [ "$transition_exists" -eq "0" ]; then
  echo -e "${RED}ERROR:${YELLOW} supplied transition does not exist${NC}"
  exit 1
fi

cp "$root/../share/index.html" "$target/"
cp -r "$root/../share/reveal.js" "$target/"
absslides=$(realpath "$slides")
chmod -R +w "$target"
ln -s "$absslides" "$target/index.md"

fixed_title=$(echo $title | sed -e 's/\//\\\//g')
sed -i "s/__TITLE__/$fixed_title/g" "$target/index.html"
sed -i "s/__THEME__/$theme/g" "$target/index.html"
sed -i "s/__TRANSITION__/$transition/g" "$target/index.html"

darkhttpd "$target" --port $port
