// ZeroOne
// ↳ UInt8+Signed.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

extension UInt8 {
  var signed: Int8 { Int8(bitPattern: self) }
  
  var signStr: String {
    let s = self.signed
    if s < 0 {
      return "\(s)"
    } else if s > 0 {
      return "+\(s)"
    } else {
      return "0"
    }
  }
}
