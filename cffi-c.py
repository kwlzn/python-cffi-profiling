#!/usr/bin/env python

import time

from cffi import FFI


def main():
  ffi = FFI()
  ffi.cdef('int doublenumber(int);')
  lib = ffi.dlopen('c_lib/libtest.so')
  for x in xrange(1, 11):
    nums = [lib.doublenumber(y) * x for y in xrange(501)]
    print(nums)
    time.sleep(1)


if __name__ == '__main__':
  main()
