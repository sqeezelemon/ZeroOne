// ZeroOne
// ↳ MultiplicationDemo.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct MultiplicationDemo: View {
  @StateObject private var checker = Checker<UInt16>()
  @StateObject private var model = MultiplicationDemoModel()
  @State private var canChange: Bool = true
  @State private var mode: Mode = .exercise
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack(alignment: .center) {
        Text(model.title)
          .font(.title2.bold())
        Spacer()
        Picker("Mode", selection: $mode) {
          Text("Exercise")
            .tag(Mode.exercise)
          Text("Auto")
            .tag(Mode.auto)
        }
        .disabled(!canChange)
        .tint(.gray)
      }
      .frame(width: DemoConsts.textCellWidth * 8 + 2*7)
      .padding(.leading, DemoConsts.textCellWidth + 4)
      
      HStack(alignment: .top, spacing: 4) {
        Text("X")
          .font(.system(size: 20, design: .monospaced))
          .frame(width: DemoConsts.textCellWidth,
                 height: DemoConsts.textCellHeight * 2 + 2,
                 alignment: .center)
        
        VStack(alignment: .leading, spacing: 2) {
          source1
            .cornerRadius(4)
            .animation(.easeOut(duration: 0.2), value: model.currentSource1Bit)
          source2
            .cornerRadius(4)
            .offset(x: -model.source2Offset)
            .frame(width: DemoConsts.textCellWidth * 8 + 2*7)
            .clipped()
            .cornerRadius(4)
            .animation(.easeOut(duration: 0.2).delay(0.1), value: model.source2Offset)
            .padding(.bottom, 2)
        }
        .frame(width: DemoConsts.textCellWidth * 8 + 2*7, alignment: .leading)
      }
      
      if mode == .exercise {
        checkableResult
      } else {
        computableResult
      }
      
      HStack(alignment: .center) {
        if mode == .exercise {
          Label("Check", systemImage: "checkmark.circle")
            .foregroundColor(canChange ? .green : .secondary)
            .onTapGesture {
              if canChange {
                checker.check(model.expected, model.result)
                setCheckerTitle()
              }
            }
          Spacer()
          Label("New numbers", systemImage: "arrow.clockwise.circle")
            .foregroundColor(.secondary)
            .onTapGesture {
              if canChange {
                let newSource1 = UInt16.random(in: 0...16)
                
                if newSource1 == model.source1 {
                  model.source1 = ~newSource1
                } else {
                  model.source1 = newSource1
                }
                
                let newSource2 = UInt16.random(in: 0...16)
                
                if newSource2 == model.source2 {
                  model.source2 = ~newSource2
                } else {
                  model.source2 = newSource2
                }
              }
            }
        } else {
          Label(canChange ? "Multiply" : "Multiplying",
                systemImage: "play.circle")
          .foregroundColor(canChange ? .blue : .secondary)
          .onTapGesture {
            if canChange {
              model.calculate()
            }
          }
        }
      }
      .frame(width: DemoConsts.textCellWidth * 8 + 2*7, alignment: .leading)
      .padding(.leading, DemoConsts.textCellWidth + 4)
    }
    .padding(.trailing, DemoConsts.textCellWidth + 2)
    .onChange(of: mode) {
      switch $0 {
      case .exercise:
        model.title = "Test yourself"
      case .auto:
        model.title = "Multiplication calculator"
      }
    }
  }
  
  var source1: some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.source1[7-i],
                canChange: $canChange)
        .background(model.currentSource1Bit == 7-i
                    ? Color.red.opacity(0.2)
                    : Color.secondary.opacity(0.2))
      }
    }
  }
  
  var source2: some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.source2[7-i],
                canChange: $canChange)
        .background(Color.secondary.opacity(0.2))
      }
    }
  }
  
  var checkableResult: some View {
    HStack(alignment: .top, spacing: 4) {
      BitView(value: $model.result[8],
              canChange: $canChange)
      .background(checker.verdict[8].color)
      .cornerRadius(4)
      .animation(.easeIn(duration: 0.1).delay(9 * 0.01),
                 value: checker.verdict[8])
      
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.result[7-i],
                  canChange: $canChange)
          .background(checker.verdict[7-i].color)
          .animation(.easeIn(duration: 0.1).delay(CGFloat(7-i) * 0.01),
                     value: checker.verdict[7-i])
        }
      }
      .cornerRadius(4)
    }
    .onChange(of: model.source1) { _ in
      checker.clear()
    }
    .onChange(of: model.source2) { _ in
      checker.clear()
    }
    .onChange(of: model.result) { _ in
      checker.clear()
    }
  }
  
  var computableResult: some View {
    HStack(spacing: 4) {
      BitView(value: $model.result[8],
              canChange: .constant(false))
      .background(Color.secondary.opacity(0.2))
      .cornerRadius(4)
      
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.result[7-i],
                  canChange: .constant(false))
          .background(Color.secondary.opacity(0.2))
          .opacity(model.currentSource1Bit <= 7-i
                   ? 1 : 0.5)
          .animation(.easeOut(duration: 0.2), value: model.currentSource1Bit)
        }
      }
      .cornerRadius(4)
    }
    .onChange(of: model.isActive) { newValue in
      canChange = !newValue
    }
  }
  
  func setCheckerTitle() {
    var error = 0
    for i in 0...8 {
      error += (checker.verdict[i] == .incorrect) ? 1 : 0
    }
    if error == 0 {
      model.title = "Perfection"
    } else if error == 1 {
      if checker.verdict[8] == .incorrect {
        model.title = "Missed the overflow!"
      } else {
        model.title = "Almost perfect!"
      }
    } else if error == 2 {
      model.title = "That was close!"
    } else {
      model.title = "You'll get there"
    }
  }
  
  enum Mode {
    case auto
    case exercise
  }
}

struct MultiplicationDemo_Previews: PreviewProvider {
  static var previews: some View {
    MultiplicationDemo()
  }
}

fileprivate class MultiplicationDemoModel: ObservableObject {
  @Published public var source1: UInt16 = .random(in: 0...16)
  @Published public var source2: UInt16 = .random(in: 0...16)
  @Published public var result: UInt16 = 0
  
  @Published public var currentSource1Bit = -1
  @Published private var intermediateRes = 0
  public var source2Offset: CGFloat {
    if currentSource1Bit <= 0 { return 0 }
    return CGFloat(currentSource1Bit) * (DemoConsts.textCellWidth + 2)
  }
  
  @Published public var isActive = false
  @Published public var title = "Test yourself"
  
  public var expected: UInt16 {
    var res: UInt16 = 0
    for i in 0..<8 {
      if source1[i] {
        res += (source2 &<< i) & 0xFF
      }
    }
    if res &>> 8 == 0 {
      // No overflow
      return res
    } else {
      // Overflow, mark bit 9 true to indicate
      return (res & 0xFF) | 0x100
    }
  }
  
  public func calculate() {
    isActive = true
    title = "Calculating..."
    for i in 0..<8 {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) { [weak self] in
        guard let self else { return }
        var newRes: UInt16 = self.result
        self.currentSource1Bit = i
        if self.source1[i] {
          newRes += (self.source2 &<< i) & 0xFF
        }
        if (newRes &>> 8) > 0 {
          // Overflow, mark bit 9 true to indicate
          newRes = (newRes & 0xFF) | 0x100
        }
        self.result = newRes
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 8 * 0.8) { [weak self] in
      guard let self else { return }
      self.title = "Finished!"
      self.currentSource1Bit = -1
      self.isActive = false
    }
  }
}
