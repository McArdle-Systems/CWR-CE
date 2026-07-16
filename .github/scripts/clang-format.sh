#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
required_version="$(tr -d '[:space:]' < "$repo_root/.clang-format-version")"
if [[ ! "$required_version" =~ ^[0-9]+$ ]]; then
  echo "invalid clang-format version in .clang-format-version: '$required_version'" >&2
  exit 2
fi

formatter="${CLANG_FORMAT:-}"
if [[ -z "$formatter" ]] && command -v "clang-format-$required_version" >/dev/null 2>&1; then
  formatter="clang-format-$required_version"
elif [[ -z "$formatter" ]] && command -v brew >/dev/null 2>&1; then
  brew_llvm_prefix="$(brew --prefix "llvm@$required_version" 2>/dev/null || true)"
  if [[ -x "$brew_llvm_prefix/bin/clang-format" ]]; then
    formatter="$brew_llvm_prefix/bin/clang-format"
  fi
fi
if [[ -z "$formatter" ]] && [[ -x "/usr/lib/llvm-$required_version/bin/clang-format" ]]; then
  formatter="/usr/lib/llvm-$required_version/bin/clang-format"
elif [[ -z "$formatter" ]] && command -v clang-format >/dev/null 2>&1; then
  formatter="clang-format"
fi

if [[ -z "$formatter" ]]; then
  echo "clang-format $required_version is required but was not found on PATH" >&2
  exit 127
fi

version_output="$($formatter --version)"
installed_version="$(sed -nE 's/.*[Vv]ersion ([0-9]+).*/\1/p' <<< "$version_output")"
if [[ "$installed_version" != "$required_version" ]]; then
  echo "clang-format $required_version is required; '$formatter' reports: $version_output" >&2
  exit 2
fi

mode="${1:---check}"
case "$mode" in
  --check)
    format_args=(--dry-run --Werror)
    ;;
  --fix)
    format_args=(-i)
    ;;
  *)
    echo "usage: $0 [--check|--fix]" >&2
    exit 2
    ;;
esac

files=()
while IFS= read -r file; do
  files+=("$file")
done < <(
  {
    git ls-files 'apps/*.cpp' 'engine/*.cpp' 'tests/*.cpp'
    git ls-files 'apps/tools/Studio/StudioApp.hpp'
    git ls-files 'apps/tools/Studio/StudioConfig.hpp'
    git ls-files 'apps/tools/Tools/SDLPreview.hpp'
    git ls-files 'apps/tools/Tools/commands/*.hpp'
    git ls-files 'tests/unit/engine/Poseidon/Asset/Formats/BISFramework/test_helpers.hpp'
    git ls-files 'tests/unit/engine/Poseidon/Support/test_fixtures.hpp'
    git ls-files 'tests/unit/engine/Poseidon/Support/test_stubs.hpp'
    git ls-files 'tests/unit/engine/Poseidon/test_fixtures.hpp'
  } | sort -u \
    | grep -v -E '(^|/)pch\.(cpp|hpp)$' \
    | grep -v -E '^tests/fixtures/' \
    | grep -v -E '^engine/(PoseidonFormats|PoseidonGL33|PoseidonOpenAL)/' \
    | grep -v -E '^engine/Random/randomGen\.cpp$' \
    | grep -v -E '^engine/Poseidon/Foundation/(Algorithms/(Crc|Crc32)|Common/(ConsoleUtils_(posix|win)|GamePaths|Platform|PlatformPaths_(posix|win))|Enums/EnumNames|Framework/AppFrame|Strings/(Mbcs|StrFormat))\.cpp$' \
    | grep -v -E '^tests/unit/apps/Server/test_simulate\.cpp$' \
    | grep -v -E '^tests/unit/engine/Poseidon/Asset/Formats/P3D/test_p3d_header\.cpp$'
)

if ((${#files[@]} > 0)); then
  "$formatter" "${format_args[@]}" "${files[@]}"
fi
