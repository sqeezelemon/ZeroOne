// ZeroOne
// ↳ Checker.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation
import SwiftUI

class Checker<T: FixedWidthInteger>: ObservableObject {
  enum Verdict {
    case correct
    case incorrect
    case unknown
  }
  
  @Published var verdict = [Verdict](repeating: .unknown, count: T.bitWidth)
  // Active => can't change anything
  @Published public var isActive: Bool = false
  
  func check(_ expected: T, _ actual: T) {
    self.isActive = true
    clear()
    for i in 0..<T.bitWidth {
      verdict[i] = expected[i] == actual[i] ? .correct : .incorrect
    }
    self.isActive = false
  }
  
  func clear() {
    for i in 0..<T.bitWidth {
      verdict[i] = .unknown
    }
  }
  
  var error: Double {
    var errorCount: Double = 0
    for v in verdict {
      if v == .incorrect {
        errorCount += 1
      }
    }
    return errorCount / Double(T.bitWidth)
  }
}

extension Checker.Verdict {
  var color: Color {
    switch self {
    case .unknown:
      return Color.secondary.opacity(0.2)
    case .correct:
      return .green.opacity(0.2)
    case .incorrect:
      return .red.opacity(0.2)
    }
  }
}
