#!/usr/bin/env bash
set -euo pipefail

cmake -B build -S . -G Ninja \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DPYTHON3_SITE_PACKAGES=$SP_DIR \
  -DPython3_EXECUTABLE=$PYTHON \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF \
  -DCOMPILE_PYTHON3_BINDINGS=ON \
  -DUDEV_RULES_SYSTEM_INSTALL=OFF \
  -DCMAKE_SYSROOT=$BUILD_PREFIX/$HOST/sysroot \
  ${CMAKE_ARGS} \
  -Wno-dev

if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
  cmake --build build --target install -j 4
else
  cmake --build build --target install -j ${CPU_COUNT}
fi

# Manually patch the rpath
if [ -f "$PREFIX/lib/metavision/hal/plugins/libhal_plugin_prophesee.so" ]; then
  patchelf --add-rpath "\$ORIGIN" "$PREFIX/lib/metavision/hal/plugins/libhal_plugin_prophesee.so"
  echo "Patched rpath for $PREFIX/lib/metavision/hal/plugins/libhal_plugin_prophesee.so"
fi
