#!/bin/bash
# Runs "$@" with UserIsActive asserted for its entire duration, however long
# that turns out to be -- macOS withholds real-time CoreAudio render
# callbacks from a session with no recent interactive input (checkable via
# `pmset -g assertions`), which self-hosted CI runners never have.
#
# `caffeinate -u` (with or without -t/-w) has a hard internal decay
# independent of how it's invoked or what it's tied to -- confirmed directly
# against a standalone AL_SEC_OFFSET poll: fine at ~2s, expired by ~90s, even
# under `caffeinate -u -w <pid>` explicitly waiting on the child. Even this
# runner's own long-running `caffeinate -dimsu` (started once, kept alive for
# weeks to hold the OS awake) doesn't hold UserIsActive continuously either --
# only its other assertions (-d/-i/-m/-s) persist.
#
# So a single call can't just be tied to the child once and left alone: this
# re-pulses continuously, stopping only when the child actually exits (via
# kill -0, not a guessed total duration) -- runs exactly as long as the child
# does, whether that's 10 seconds or 10 minutes, with no timeout to outgrow.
set -euo pipefail

"$@" &
target_pid=$!

(
    while kill -0 "$target_pid" 2>/dev/null; do
        caffeinate -u -t 3
    done
) &
keepalive_pid=$!

set +e
wait "$target_pid"
status=$?
set -e

kill "$keepalive_pid" 2>/dev/null || true
wait "$keepalive_pid" 2>/dev/null || true

exit "$status"
