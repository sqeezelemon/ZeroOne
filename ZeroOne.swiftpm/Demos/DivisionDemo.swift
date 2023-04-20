// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct DivisionDemo: View {
  @StateObject private var model = DivisionDemoModel()
  @State private var canChange = true
  var body: some View {
    VStack(alignment: .center, spacing: 6) {
      VStack(alignment: .leading, spacing: 6) {
        HStack(alignment: .top, spacing: 4) {
          Text("÷")
            .font(.system(size: DemoConsts.textSize, design: .monospaced))
            .frame(width: DemoConsts.textCellWidth, height: DemoConsts.textCellHeight * 2 + 2, alignment: .center)
          sources
        }
        
        HStack(alignment: .top, spacing: 4) {
          VStack(alignment: .trailing, spacing: 2) {
            Text("Quot.")
              .frame(width: 80, height: DemoConsts.textCellHeight)
            Text("Rem.")
              .frame(width: 80, height: DemoConsts.textCellHeight)
          }
            .frame(width: DemoConsts.textCellWidth, height: DemoConsts.textCellHeight * 2 + 2, alignment: .center)
          results
        }
        
        Label(canChange ? (model.divisor == 0 ? "Cannot divide by zero" : "Divide" )
              : "Dividing",
              systemImage: "play.circle")
        .foregroundColor(canChange ? (model.divisor == 0 ? .red : .blue) : .secondary)
        .onTapGesture {
          if canChange && model.divisor != 0 {
            DispatchQueue.global(qos: .userInteractive).async {
              self.model.div(n: model.number, d: model.divisor)
            }
          }
        }
        .padding(.leading, DemoConsts.textCellWidth + 4)
      }
      .padding(.leading, -DemoConsts.textCellWidth - 4)
      
      ScrollView(.horizontal, showsIndicators: false) {
        VStack(alignment: .leading) {
          ForEach(0..<model.lines.count, id:\.self) { line in
            Text(model.lines[line])
              .frame(width: 800, alignment: .leading)
              .background(model.currentLine == line
                          ? Color.red.opacity(0.2) : Color.clear)
              .lineLimit(1)
          }
        }
        .font(.system(size: 14, design: .monospaced))
        .padding(.leading, 20)
        .animation(.easeInOut(duration: 0.1), value: model.currentLine)
      }
      .padding(.vertical, 20)
      .background(.secondary.opacity(0.2))
      .cornerRadius(10)
    }
    .onChange(of: model.isActive) {
      canChange = !$0
    }
  }
  
  var sources: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.number[7-i],
                  canChange: $canChange)
          .background(Color.secondary.opacity(0.2))
        }
      }
      
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.divisor[7-i],
                  canChange: $canChange)
          .background(Color.secondary.opacity(0.2))
        }
      }
    }
    .cornerRadius(4)
  }
  
  var results: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.quotient[7-i],
                  canChange: .constant(false))
          .background(Color.secondary.opacity(0.2))
        }
      }
      
      HStack(alignment: .center, spacing: 2) {
        ForEach(0..<8, id: \.self) { i in
          BitView(value: $model.remainder[7-i],
                  canChange: .constant(false))
          .background(Color.secondary.opacity(0.2))
        }
      }
    }
    .cornerRadius(4)
  }
}

struct DivisionDemo_Previews: PreviewProvider {
  static var previews: some View {
    DivisionDemo()
  }
}

class DivisionDemoModel: ObservableObject {
  @Published public var number: UInt8 = 0
  @Published public var divisor: UInt8 = 0
  
  @Published public var quotient: UInt8 = 0
  @Published public var remainder: UInt8 = 0
  @Published public var errorText: String?
  
  @Published public var currentLine = -1
  @Published public var isActive = false
  
  public let code = """
func divide(number: Int, divisor: Int) -> (quotient: Int, remainder: Int) {
  if divisor == 0 {
    return error // Division by zero!
  }
  
  var quotient = 0
  var remainder = 0

  // n - amount of bits in our number
  for i in (n-1) ... 0 {
    remainder << 1 // Left bit shift
    remainder[0] = number[i]
    if remainder >= divisor {
      remainder -= divisor
      q[i] = 1
    }
  }
  return (quotient, remainder)
}
""".replacing("\t", with: "  ")
  public var lines: [String] { code.components(separatedBy: "\n") }
  
  private var currentLineMain: Int {
    set {
      DispatchQueue.main.async { [weak self] in
        self?.currentLine = newValue
      }
    }
    get {
      currentLine
    }
  }
  
  private var quontientMain: UInt8 {
    set {
      DispatchQueue.main.async { [weak self] in
        self?.quotient = newValue
      }
    }
    get {
      quotient
    }
  }
  
  private var remainderMain: UInt8 {
    set {
      DispatchQueue.main.async { [weak self] in
        self?.remainder = newValue
      }
    }
    get {
      remainder
    }
  }
  
  private var isActiveMain: Bool {
    set {
      DispatchQueue.main.async { [weak self] in
        self?.isActive = newValue
      }
    }
    get {
      isActive
    }
  }
  
  func div(n: UInt8, d: UInt8) {
    let delay: TimeInterval = 0.5
    isActiveMain = true
    Thread.sleep(forTimeInterval: delay)
    currentLineMain = 1
    if d == 0 {
      Thread.sleep(forTimeInterval: delay)
      currentLineMain = 2
      isActive = false
      return
    }
    Thread.sleep(forTimeInterval: delay)
    currentLineMain = 5
    var q: UInt8 = 0
    var r: UInt8 = 0
    for i in (0...(UInt8.bitWidth-1)).reversed() {
      Thread.sleep(forTimeInterval: delay)
      currentLineMain = 9
      
      r &<<= 1
      Thread.sleep(forTimeInterval: delay)
      currentLineMain = 10
      remainderMain = r
      
      r[0] = n[i]
      Thread.sleep(forTimeInterval: delay)
      currentLineMain = 11
      remainderMain = r
      
      Thread.sleep(forTimeInterval: delay)
      currentLineMain = 12
      if r >= d {
        
        r = r &- d
        Thread.sleep(forTimeInterval: delay)
        currentLineMain = 13
        remainderMain = r
        
        q[i] = true
        Thread.sleep(forTimeInterval: delay)
        currentLineMain = 14
        quontientMain = q
        
      }
    }
    Thread.sleep(forTimeInterval: delay)
    currentLineMain = 17
    Thread.sleep(forTimeInterval: delay)
    currentLineMain = 18
    Thread.sleep(forTimeInterval: delay)
    currentLineMain = -1
    isActiveMain = false
  }
}
