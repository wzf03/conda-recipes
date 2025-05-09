#!/usr/bin/env bash
set -euo pipefail

cmake -B build -S . \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DPYTHON3_SITE_PACKAGES=$SP_DIR \
  -DPython3_EXECUTABLE=$PYTHON \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=ON \
  -DCOMPILE_PYTHON3_BINDINGS=ON \
  -DUDEV_RULES_SYSTEM_INSTALL=OFF \
  -DCMAKE_SYSROOT=$BUILD_PREFIX/$HOST/sysroot \
  ${CMAKE_ARGS} \
  -Wno-dev

cmake --build build --target install