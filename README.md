# argue.sh
an argument and option parser for bash

## why
cos `getopt(s)` is a pita

## how
sourceable shell script

## install
get `argue.sh` somewhere in your `PATH`

## example
```bash
#!/bin/bash
#
# argue-example
#

. argue.sh

argue "$*"\                     # first pass argv to argue
      "-v, --version"\          # specify options with comma separated lists of forms
      "-f, --first-name, +"\    # specify options that capture a value by making the last form a "+"
      "-l, --last-name, +"

echo "options: ${opts[@]}"      # access options in the $opts array
echo "arguments: ${args[@]}"    # access positional args in the $args array
```

## test
`bash test.sh`

## inspiration
loosely by [commander.c](https://github.com/visionmedia/commander.c)

## license
WTFPL
