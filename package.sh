#!/usr/bin/env bash
#
# package.sh for argue
#

name() {
  echo "argue"
}

version() {
  echo "0.0.5"
}

repository() {
  echo "https://github.com/jessetane/argue"
}

fetch() {
  git clone "$(repository)" "$src"
}

update() {
  git fetch --all
  git fetch --tags
}

build() {
  mkdir -p "$lib"/"$build"
  cd "$lib"/"$build"
  cp -R "$src"/.git ./
  git reset --hard "$version"
}
