#!/usr/bin/env bash
#
# test.sh
#

cd "$(dirname "$BASH_SOURCE")"

. ./bin/argue.sh

tests=20
passed=0

fail() {
  echo "✖ $@" >&2
  exit 1
}

# positional
argue "one two three"
test ${#args[@]} = 3 || fail "positional: wrong number of arguments"
test "${args[2]}" = "three" || fail "positional: argument value incorrect"
((passed += 2))

# options
argue "-x"\
      "-y" 2> /dev/null && fail "options: did not exit non-zero on unrecognized option"
argue "-a -b -c --cee"\
      "-a"\
      "-b"\
      "-c, --cee" || fail "options: unrecognized option"
test ${#opts[@]} = 3 || fail "options: wrong number of options"
test "${opts[2]}" = "--cee" || fail "options: option value incorrect"
((passed += 4))

# mixed
argue "-b one -c two -a three --cee"\
      "-a"\
      "-b"\
      "-c, --cee" || fail "mixed: unrecognized option"
test ${#args[@]} = 3 || fail "mixed: wrong number of arguments"
test ${#opts[@]} = 3 || fail "mixed: wrong number of options"
test "${args[2]}" = "three" || fail "mixed: argument value incorrect"
test "${opts[2]}" = "--cee" || fail "mixed: option value incorrect"
((passed += 5))

# capture
argue "-a -b captureme -c"\
      "-a"\
      "-b, +"\
      "-c" || fail "capture: unrecognized option"
test ${#opts[@]} = 3 || fail "capture: wrong number of options"
test "${opts[1]}" = "captureme" || fail "capture: option value incorrect"
((passed += 3))

# assignment
argue "-a -b=captureme -c"\
      "-a"\
      "-b, +"\
      "-c" || fail "assignment: unrecognized option"
test ${#opts[@]} = 3 || fail "assignment: wrong number of options"
test "${opts[1]}" = "captureme" || fail "assignment: option value incorrect"
((passed += 3))

# capture empty
argue "-a -b= -c"\
      "-a"\
      "-b, +"\
      "-c" || fail "capture empty: unrecognized option"
test ${#opts[@]} = 3 || fail "capture empty: wrong number of options"
test "${opts[1]}" = "" || fail "capture empty: option value incorrect"
((passed += 3))

# all done
echo "✔︎ $passed / $tests tests passed"
