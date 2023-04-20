// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct AdditionDemo: View {
  @StateObject private var checker = Checker<UInt16>()
  @StateObject private var model = AdditionDemoModel()
  @State private var canChange: Bool = true
  @State private var mode: Mode = .exercise
  @State private var showCarry: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
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
      
      HStack(alignment: .center, spacing: 4) {
        Text("+")
          .frame(width: DemoConsts.textCellWidth,
                 height: DemoConsts.textCellHeight * 2 + 2,
                 alignment: .center)
          .font(.system(size: DemoConsts.textSize, design: .monospaced))
        sources
        Color.clear
          .frame(width: DemoConsts.textCellWidth,
                 height: DemoConsts.textCellHeight * 2 + 2,
                 alignment: .center)
      }
      
      if showCarry && mode == .auto {
        carry
      }
      
      HStack(alignment: .center) {
        if mode == .exercise {
          checkableResult
        } else {
          calculatableResult
        }
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
                let newSource1 = UInt16.random(in: 0...255)
                
                if newSource1 == model.source1 {
                  model.source1 = ~newSource1
                } else {
                  model.source1 = newSource1
                }
                
                let newSource2 = UInt16.random(in: 0...255)
                
                if newSource2 == model.source2 {
                  model.source2 = ~newSource2
                } else {
                  model.source2 = newSource2
                }
              }
            }
        } else {
          Label(canChange ? "Calculate sum" : "Calculating sum",
                systemImage: "play.circle")
          .foregroundColor(canChange ? .blue : .secondary)
          .onTapGesture {
            if canChange {
              model.calculate()
            }
          }
          Spacer()
          Label(showCarry ? "Hide carry" : "Show carry",
                systemImage: showCarry ? "eye.slash.circle" : "eye.circle")
          .foregroundColor(.green)
          .onTapGesture {
            showCarry.toggle()
          }
        }
      }
      .frame(width: DemoConsts.textCellWidth * 8 + 2*7, alignment: .leading)
      .padding(.leading, DemoConsts.textCellWidth + 4)
    }
    .onChange(of: mode) {
      switch $0 {
      case .exercise:
        model.title = "Test yourself"
      case .auto:
        model.title = "Addition calculator"
      }
    }
    .animation(.easeInOut(duration: 0.05), value: showCarry)
  }
  
  var sources: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.source1[7-i],
                  canChange: $canChange)
          .background(Color.secondary.opacity(0.2))
        }
      }
      
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.source2[7-i],
                  canChange: $canChange)
          .background(Color.secondary.opacity(0.2))
        }
      }
    }
    .cornerRadius(4)
  }
  
  var checkableResult: some View {
    HStack(alignment: .center, spacing: 4) {
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
  
  var calculatableResult: some View {
    HStack(alignment: .center, spacing: 4) {
      BitView(value: $model.result[8],
              canChange: .constant(false))
      .background(model.currentAutocalculateBit == 8
                  ? .red.opacity(0.2)
                  : .secondary.opacity(0.2))
      .cornerRadius(4)
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.result[7-i],
                  canChange: .constant(false))
          .background(model.currentAutocalculateBit == 7-i
                      ? .red.opacity(0.2)
                      : .secondary.opacity(0.2))
          
        }
      }
      .cornerRadius(4)
    }
    .onChange(of: model.isActive) { newValue in
      canChange = !newValue
    }
  }
  
  var carry: some View {
    HStack(alignment: .center, spacing: 4) {
      BitView(value: $model.carry[8],
              canChange: .constant(false))
      .background(model.currentAutocalculateBit + 1 == 8
                  ? .red.opacity(0.2)
                  : .green.opacity(0.2))
      .cornerRadius(4)
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.carry[7-i],
                  canChange: .constant(false))
          .background(model.currentAutocalculateBit + 1 == 7-i
                      ? .red.opacity(0.2)
                      : .green.opacity(0.2))
          
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
    case exercise
    case auto
  }
}

struct AdditionDemo_Previews: PreviewProvider {
  static var previews: some View {
    AdditionDemo()
  }
}

fileprivate class AdditionDemoModel: ObservableObject {
  @Published public var source1: UInt16 = .random(in: 0...255)
  @Published public var source2: UInt16 = .random(in: 0...255)
  @Published public var result: UInt16 = 0
  @Published public var carry: UInt16 = 0
  @Published public var isActive: Bool = false
  @Published public var title: String = "Test yourself"
  @Published public var currentAutocalculateBit = -2
  public var expected: UInt16 { source1 &+ source2 }
  
  func calculate() {
    isActive = true
    title = "Calculating"
    let delayModifier: Double = 0.4
    for i in 0...8 {
      DispatchQueue.main.asyncAfter(deadline: .now() + delayModifier * Double(i)) { [weak self] in
        guard let self else { return }
        self.currentAutocalculateBit = i
        self.result[i] = self.expected[i]
        
        let carryCount: Int = (self.source1[i] ? 1 : 0) + (self.source2[i] ? 1 : 0) + (self.carry[i] ? 1 : 0)
        self.carry[i+1] = carryCount > 1
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delayModifier * 9) { [weak self] in
      guard let self else { return }
      self.title = "Finished calculating!"
      self.isActive = false
      self.currentAutocalculateBit = -2
    }
  }
}
