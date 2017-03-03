#!/usr/bin/env python

from cffi import FFI

ffi = FFI()
ffi.cdef('int double(int);')
lib = ffi.dlopen('rust_lib/target/debug/libtest.dylib')
print([lib.double(x) for x in xrange(501)])
