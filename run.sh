#!/bin/sh

set -euxo pipefail

# Build the rust lib.
pushd rust_lib
  cargo build
popd

# Build gperftools from the submodule.
if [ ! -e "tcmalloc-install" ]; then
	pushd gperftools
		./autogen.sh
		./configure --prefix=$(pwd)/../tcmalloc-install
		make
		make install
	popd
fi

# Execute the cffi integration via pex under care of the profiler.
LD_PRELOAD=./tcmalloc-install/lib/libtcmalloc_and_profiler.dylib CPUPROFILE=profile.out pex --no-wheel cffi -- cffi.py
