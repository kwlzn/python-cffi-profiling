#!/usr/bin/env python

import time

from cffi import FFI


def main():
  ffi = FFI()
  ffi.cdef('int double(int);')
  lib = ffi.dlopen('rust_lib/target/debug/libtest.so')
  for x in xrange(1, 11):
    nums = [lib.double(y) * x for y in xrange(501)]
    print(nums)
    time.sleep(1)


if __name__ == '__main__':
  main()