# Installing on macOS

CWR-CE supports Apple Silicon Macs. You can run a
[development build](#development-builds) or [build it yourself](#building-manually),
then point the executable at separately installed game data.

## Development builds

The quickest way to play the game is to download a pre-built binary. Changes
to CWR-CE are automatically compiled and tested, and the resulting CI builds
are published at <https://ofpisnotdead-com.github.io/CWR-CE-builds/#main>.

The latest builds are sorted to the top. The macOS downloads include:

- `macOS-arm64-rwdi-Game` — the full game executable.
- `macOS-arm64-rwdi-GameDemo` — the game demo executable.
- `macOS-arm64-rwdi-Server` — the multiplayer server.

These are development builds for Apple Silicon (`arm64`), not Intel
executables. After downloading and extracting an artifact, follow
[Running with game data](#running-with-game-data).

Because development artifacts are not signed or notarized applications,
macOS may quarantine a downloaded executable. If macOS blocks a build that
you trust, remove the quarantine attribute from the extracted directory:

```sh
xattr -dr com.apple.quarantine /path/to/extracted-build
```

## Building manually

### Installing the dependencies

Install the Xcode command-line tools:

```sh
xcode-select --install
```

Install [Homebrew](https://brew.sh/) if necessary, then install the remaining
build tools:

```sh
brew install ccache clang-format cmake git ninja
```

Set up [vcpkg](https://vcpkg.io/):

```sh
git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
"$HOME/vcpkg/bootstrap-vcpkg.sh"
export VCPKG_ROOT="$HOME/vcpkg"
```

Add the `VCPKG_ROOT` export to your shell profile if you want it to persist
across terminal sessions.

### Downloading the repository

Clone the repository and enter its directory:

```sh
git clone https://github.com/ofpisnotdead-com/CWR-CE.git
cd CWR-CE
```

### Compiling

The `macos-arm64-clang-rwdi` preset builds Apple Silicon binaries with debug
symbols:

```sh
cmake --preset macos-arm64-clang-rwdi
cmake --build build/macos-arm64-clang-rwdi --target PoseidonGame -j8
```

Use `macos-arm64-clang` for a Debug build or
`macos-arm64-clang-rel` for a Release build. With the RelWithDebInfo preset,
the game executable is written to
`build/macos-arm64-clang-rwdi/apps/cwr/Game/PoseidonGame`, and packaged
binaries are written under `dist/macos-arm64-clang-rwdi`.

If the repository is moved or renamed after configuration, delete its build
directory and run the configure command again. CMake-generated files contain
absolute paths.

## Running with game data

Game data is distributed separately from the GPL source code. Install the
[Steam game](https://store.steampowered.com/app/65790/Arma_Cold_War_Assault_Remastered/)
or [Steam demo](https://store.steampowered.com/app/4819000/Arma_Cold_War_Assault_Remastered_Demo/),
then copy its data into the ignored `packages/Remastered` directory or point
`-C` at another directory containing that data.

Run a locally built game with the native Metal renderer:

```sh
build/macos-arm64-clang-rwdi/apps/cwr/Game/PoseidonGame \
  -C packages/Remastered \
  --render mtl \
  --window
```

The GL33 renderer is also available for comparison:

```sh
build/macos-arm64-clang-rwdi/apps/cwr/Game/PoseidonGame \
  -C packages/Remastered \
  --render gl33 \
  --window
```

`--window` avoids opening the game in a separate fullscreen macOS Space.
Use `--width` and `--height` to select a resolution and `--no-splash` to
skip the splash screen.
