cmake --fresh --preset macos-arm64-clang-rwdi && \
cmake --build build/macos-arm64-clang-rwdi --target PoseidonGame -j24 && \
dist/arm64-macos-rwdi/PoseidonGame --render mtl --window -C packages/Remastered --no-splash