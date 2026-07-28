#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PRESET="${PRESET:-macos-arm64-clang-rwdi}"
TARGET="${TARGET:-PoseidonGame}"
JOBS="${JOBS:-8}"
CONTENT_DIR="${CONTENT_DIR:-packages/Remastered}"
MODS_DIR="${MODS_DIR:-/Users/alex/Projects/CWR-arm64/packages/Mods}"
if [[ -z "${MODS+x}" ]]; then
    MOD_FOLDERS=()
    if [[ -d "$MODS_DIR" ]]; then
        while IFS= read -r -d '' d; do
            MOD_FOLDERS+=("$(basename "$d")")
        done < <(find "$MODS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
    fi
    MODS="$(IFS=';'; echo "${MOD_FOLDERS[*]:-}")"
fi
RENDER="${RENDER:-mtl}"
CONFIGURE="${CONFIGURE:-1}"
DEFAULT_TEST_MISSION="${HOME}/Documents/Cold War Assault/missions/benchmark.abel"
TEST_MISSION_SET=0
TEST_MISSION=""
DEFAULT_LOG_FILE="/tmp/cwr-run.log"
LOG_FILE_SET=0
LOG_FILE=""
GAME_ARGS=()

usage() {
    cat <<EOF
Usage: $(basename "$0") [options] [--] [game args...]

Builds the default macOS debug game target and launches it with useful
development flags.

Environment overrides:
  PRESET       CMake preset to configure/build (default: $PRESET)
  TARGET       CMake target to build (default: $TARGET)
  JOBS         Parallel build jobs (default: $JOBS)
  CONTENT_DIR  Game content directory passed with -C (default: $CONTENT_DIR)
  MODS_DIR     Mods parent dir passed with --mods-dir, scanned by the in-game
               Mods browser (default: $MODS_DIR)
  MODS         Mod path(s) passed with --mod, semicolon-separated (default:
               every folder directly inside MODS_DIR)
  RENDER       Renderer passed with --render (default: $RENDER)
  CONFIGURE    Run cmake --preset first, 1 or 0 (default: $CONFIGURE)

Options:
  --test-mission[=PATH]  Launch a test mission. Without PATH, uses:
                         $DEFAULT_TEST_MISSION
  --log-file[=PATH]      Mirror log output to a file in addition to the
                         terminal (engine's --log-file, both sinks are
                         always active together). Without PATH, uses:
                         $DEFAULT_LOG_FILE

Examples:
  ./build-and-run.sh
  ./build-and-run.sh --test-mission
  ./build-and-run.sh --test-mission="\$HOME/.local/share/Cold War Assault/missions/benchmark.abel"
  ./build-and-run.sh --test-mission --log-file
  RENDER=gl33 ./build-and-run.sh --no-sound
  MODS="@ModA;@ModB" ./build-and-run.sh
  CONFIGURE=0 JOBS=12 ./build-and-run.sh
EOF
}

while (($# > 0)); do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --test-mission=*)
            TEST_MISSION_SET=1
            TEST_MISSION="${1#*=}"
            shift
            ;;
        --test-mission)
            TEST_MISSION_SET=1
            if [[ $# -ge 2 && "${2:0:1}" != "-" ]]; then
                TEST_MISSION="$2"
                shift 2
            else
                TEST_MISSION="$DEFAULT_TEST_MISSION"
                shift
            fi
            ;;
        --log-file=*)
            LOG_FILE_SET=1
            LOG_FILE="${1#*=}"
            shift
            ;;
        --log-file)
            LOG_FILE_SET=1
            if [[ $# -ge 2 && "${2:0:1}" != "-" ]]; then
                LOG_FILE="$2"
                shift 2
            else
                LOG_FILE="$DEFAULT_LOG_FILE"
                shift
            fi
            ;;
        --)
            shift
            GAME_ARGS+=("$@")
            break
            ;;
        *)
            GAME_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ "$TEST_MISSION_SET" == "1" ]]; then
    if ((${#GAME_ARGS[@]} > 0)); then
        GAME_ARGS=(--test-mission "$TEST_MISSION" "${GAME_ARGS[@]}")
    else
        GAME_ARGS=(--test-mission "$TEST_MISSION")
    fi
fi

if [[ "$LOG_FILE_SET" == "1" ]]; then
    GAME_ARGS=(--log-file "$LOG_FILE" ${GAME_ARGS[@]+"${GAME_ARGS[@]}"})
    echo "Logging to terminal AND $LOG_FILE"
fi

BUILD_DIR="$ROOT_DIR/build/$PRESET"
GAME_BIN="$BUILD_DIR/apps/cwr/Game/PoseidonGame"

if [[ "$CONFIGURE" != "0" ]]; then
    cmake --preset "$PRESET"
fi

cmake --build "$BUILD_DIR" --target "$TARGET" -j "$JOBS"

MOD_ARGS=()
if [[ -n "$MODS" ]]; then
    MOD_ARGS=(--mod "$MODS" --mods-dir "$MODS_DIR")
fi

exec "$GAME_BIN" \
    --no-splash \
    -C "$CONTENT_DIR" \
    "${MOD_ARGS[@]}" \
    --render "$RENDER" \
    --dev \
    --show-fps \
    ${GAME_ARGS[@]+"${GAME_ARGS[@]}"}
