#!/usr/bin/env bash
#
# test.sh
#

cd "$(dirname "$BASH_SOURCE")"

. ./bin/argue.sh

tests=22
passed=0

fail() {
  echo "✖ $@" >&2
  exit 1
}

# positional
argv=(one two three)
argue
test ${#args[@]} = 3 || fail "positional: wrong number of arguments"
test "${args[2]}" = "three" || fail "positional: argument value incorrect"
((passed += 2))

# options
argv=(-x)
argue "-y" 2> /dev/null && fail "options: did not exit non-zero on unrecognized option"

argv=(-a -b -c --cee)
argue "-a"\
      "-b"\
      "-c, --cee" || fail "options: unrecognized option"
test ${#opts[@]} = 3 || fail "options: wrong number of options"
test "${opts[2]}" = "--cee" || fail "options: option value incorrect"
((passed += 4))

# mixed
argv=(-b one -c two -a three --cee)
argue "-a"\
      "-b"\
      "-c, --cee" || fail "mixed: unrecognized option"
test ${#args[@]} = 3 || fail "mixed: wrong number of arguments"
test ${#opts[@]} = 3 || fail "mixed: wrong number of options"
test "${args[2]}" = "three" || fail "mixed: argument value incorrect"
test "${opts[2]}" = "--cee" || fail "mixed: option value incorrect"
((passed += 5))

# capture
argv=(-a -b captureme -c)
argue "-a"\
      "-b, +"\
      "-c" || fail "capture: unrecognized option"
test ${#opts[@]} = 3 || fail "capture: wrong number of options"
test "${opts[1]}" = "captureme" || fail "capture: option value incorrect"
((passed += 3))

# assignment
argv=(-a -b=captureme -c)
argue "-a"\
      "-b, +"\
      "-c" || fail "assignment: unrecognized option"
test ${#opts[@]} = 3 || fail "assignment: wrong number of options"
test "${opts[1]}" = "captureme" || fail "assignment: option value incorrect"
((passed += 3))

# capture empty
argv=(-a -b= -c)
argue "-a"\
      "-b, +"\
      "-c" || fail "capture empty: unrecognized option"
test ${#opts[@]} = 3 || fail "capture empty: wrong number of options"
test "${opts[1]}" = "" || fail "capture empty: option value incorrect"
((passed += 3))

# spaces
argv=(a 'b c' d)
argue
test ${#args[@]} = 3 || fail "spaces: wrong number of options"
test "${args[1]}" = "b c" || fail "spaces: argument value incorrect"
((passed += 2))

# all done
echo "✔︎ $passed / $tests tests passed"
