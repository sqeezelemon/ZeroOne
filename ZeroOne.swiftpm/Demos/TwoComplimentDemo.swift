// ZeroOne
// ↳ TwoComplimentDemo.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct TwoComplimentDemo: View {
  @StateObject private var checker = Checker<UInt8>()
  @StateObject private var model = TwoComplimentModel()
  @State private var mode: Mode = .exercise
  @State private var canChange: Bool = true
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
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
      source
      
      if mode == .exercise {
        checkableResult
        HStack(alignment: .center) {
          Label("Check", systemImage: "checkmark.circle")
            .foregroundColor(canChange ? .green : .secondary)
            .onTapGesture {
              if canChange {
                checker.check(model.expected, model.result)
                setCheckerTitle()
              }
            }
          Spacer()
          Label("New number", systemImage: "arrow.clockwise.circle")
            .foregroundColor(.secondary)
            .onTapGesture {
              if canChange {
                let newSource = UInt8.random(in: 0...255)
                
                // In case random gives the same answer
                if newSource == model.source {
                  model.source = ~newSource
                } else {
                  model.source = newSource
                }
              }
            }
        }
        .padding(.top, 2)
      } else {
        calculatableResult
        Label(canChange ? "Calculate compliment" : "Calculating component",
              systemImage: "play.circle")
          .foregroundColor(canChange ? .blue : .secondary)
          .onTapGesture {
            if canChange {
              model.convert()
            }
          }
          .padding(.top, 2)
      }
    }
    .frame(width: DemoConsts.textCellWidth * 8 + 7*2)
    .onChange(of: mode) {
      switch $0 {
      case .exercise:
        model.title = "Test yourself"
      case .auto:
        model.title = "Compliment calculator"
      }
    }
    .lineLimit(1)
  }
  
  var source: some View {
    HStack(alignment: .top, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.source[7-i],
                canChange: $canChange)
        .background(Color.secondary.opacity(0.2))
      }
    }
    .cornerRadius(4)
  }
  
  var checkableResult: some View {
    HStack(alignment: .top, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.result[7-i],
                canChange: $canChange)
        .background(checker.verdict[7-i].color)
        .animation(.easeIn(duration: 0.1).delay(CGFloat(7-i) * 0.01),
                   value: checker.verdict[7-i])
      }
    }
    .cornerRadius(4)
    .onChange(of: checker.isActive) { isActive in
      canChange = !isActive
    }
    .onChange(of: model.result) { _ in
      checker.clear()
    }
    .onChange(of: model.source) { _ in
      checker.clear()
    }
  }
  
  var calculatableResult: some View {
    HStack(alignment: .top, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.result[7-i],
                canChange: .constant(false))
        .background(model.currentAutocalculateBit == 7-i ? .red.opacity(0.2) : .secondary.opacity(0.2))
      }
    }
    .cornerRadius(4)
    .onChange(of: model.isActive) { newValue in
      canChange = !newValue
    }
  }
  
  private func setCheckerTitle() {
    if checker.error == 0 {
      model.title = "Perfection!"
    } else if checker.error < 0.15 {
      model.title = "Almost perfect!"
    } else if checker.error < 0.26 {
      model.title = "That was close!"
    } else {
      model.title = "You'll get there!"
    }
  }
  
  enum Mode {
    case exercise
    case auto
  }
}

struct TwoComplimentDemo_Previews: PreviewProvider {
  static var previews: some View {
    TwoComplimentDemo()
  }
}

fileprivate class TwoComplimentModel: ObservableObject {
  @Published var source: UInt8 = .random(in: 0...255)
  @Published var result: UInt8 = 0
  @Published var isActive: Bool = false
  @Published var title = "Test yourself"
  @Published var currentAutocalculateBit = -1
  
  var expected: UInt8 {
    ~source &+ 1
  }
  
  func convert() {
    isActive = true
    title = "Inverting"
    let delayModifier: Double = 0.4
    for i in 0...7 {
      DispatchQueue.main.asyncAfter(deadline: .now() + delayModifier * Double(i)) { [weak self] in
        guard let self else { return }
        self.currentAutocalculateBit = i
        self.result[i] = !self.source[i]
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delayModifier * 8) { [weak self] in
      guard let self else { return }
      self.title = "Adding one"
    }
    
    for i in 0...7 {
      DispatchQueue.main.asyncAfter(deadline: .now() + delayModifier * (8 + Double(i))) { [weak self] in
        guard let self else { return }
        self.currentAutocalculateBit = i
        self.result[i] = self.expected[i]
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delayModifier * 16) { [weak self] in
      guard let self else { return }
      self.title = "Converted!"
      self.isActive = false
      self.currentAutocalculateBit = -1
    }
  }
}
