#!/bin/sh

set -euxo pipefail

GPERF_INSTALL_PATH="gperftools-install"
PROFILE_RESULTS_DIR="profile-results"

# (Re-)Initialize the profile results dir.
rm -rf "${PROFILE_RESULTS_DIR}"
mkdir "${PROFILE_RESULTS_DIR}"

# Build the rust lib.
pushd rust_lib
  RUSTFLAGS="-C relocation-model=pic" cargo build
popd

# Build gperftools from the submodule.
if [ ! -e $GPERF_INSTALL_PATH ]; then
  pushd gperftools
    ./autogen.sh
    ./configure --prefix="$(pwd)/../${GPERF_INSTALL_PATH}"
    make
    make install
  popd
fi

# Execute the cffi integration via pex under care of the profiler.
LD_PRELOAD="./${GPERF_INSTALL_PATH}/lib/libtcmalloc_and_profiler.so" HEAPPROFILE="${PROFILE_RESULTS_DIR}/profile.out" pex --not-zip-safe --no-wheel cffi -- cffi.py


${GPERF_INSTALL_PATH}/bin/pprof \`which python2.7\` ${PROFILE_RESULTS_DIR}/profile.out.0001.heap
