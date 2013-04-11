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
  [ ! -e "$SRC"/.git ] && rm -rf "$SRC" || return 0
  git clone "$(repository)" "$SRC"
}

update() {
  cd "$SRC"
  git fetch --all
  git fetch --tags
}

build() {
  mkdir -p "$LIB"
  cp -R "$SRC"/.git "$LIB"/
  cd "$LIB"
  git reset --hard "$VERSION"
}
