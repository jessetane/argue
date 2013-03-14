# argue
An argument and option parser for bash

## Why
`getopts` is somewhat limited

## How
Sourceable bash script

## Usage
* Make an array variable called `args` to store the arguments you'd like to parse
* Call `argue` with comma delimited strings representing accepted option formats as arguments
* Make the last form of an option a `+` to capture the next positional argument as an option value
* After `argue` runs, positional arguments end up in the `$args` array variable, options in `$opts`

```
args=("$@")
argue "-v, --version"\
			"-h, --help"\
			"-n, --name, +"
```

## Inspiration
Loosely by [commander.c](https://github.com/visionmedia/commander.c)

## License
[WTFPL](http://www.wtfpl.net/txt/copying/)
