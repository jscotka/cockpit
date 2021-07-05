#!/bin/sh
# This script is meant to be run on an ephemeral CI host, for packit/Fedora/RHEL gating.
set -eux

TESTS="$(realpath $(dirname "$0"))"
SOURCE="$(realpath $TESTS/../..)"
LOGS="$(pwd)/logs"
mkdir -p "$LOGS"
chmod a+w "$LOGS"

# Run tests as unprivileged user
chown -R runtest "$SOURCE"
su - -c "env LOGS=$LOGS $TESTS/run-user.sh" runtest

RC=$(cat $LOGS/exitcode)
exit ${RC:-1}
