// ZeroOne
// ↳ FixedWidthInteger+subscript.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

extension FixedWidthInteger {
  public subscript(_ offset: Int) -> Bool {
    get {
      if Self.bitWidth <= offset || offset < 0 {
        return false
      }
      let value = (self &>> offset) & 1
      return value == 1
    }
    set {
      let mask: Self = ~(1 &<< offset)
      self = (self & mask) | ((newValue ? 1 : 0) &<< offset)
    }
  }
}
