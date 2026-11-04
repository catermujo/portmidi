#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
case "$(uname -m)" in
    arm64|aarch64) arch=arm64 ;;
    x86_64|amd64) arch=x64 ;;
    *) echo "Unsupported PortMidi architecture: $(uname -m)" >&2; exit 1 ;;
esac
platform_flags=()
case "$(uname -s)" in
    Darwin)
        platform=darwin
        platform_flags=("-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-26.0}")
        ;;
    Linux) platform=linux ;;
    *) echo "Unsupported PortMidi platform: $(uname -s)" >&2; exit 1 ;;
esac
output="${platform}_${arch}"
build="build/$output"
cmake -S . -B "$build" \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_PORTMIDI_TESTS=OFF \
    -DBUILD_JAVA_NATIVE_INTERFACE=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    "${platform_flags[@]}"
cmake --build "$build" --config Release --target portmidi --parallel
mkdir -p "$output"
cp -a "$build"/libportmidi.* "$output/"
