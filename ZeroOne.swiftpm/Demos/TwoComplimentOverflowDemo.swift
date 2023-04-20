// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct TwoComplimentOverflowDemo: View {
  @StateObject private var model = TwoComplimentOverflowDemoModel()
  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: 0) {
        Text("+")
          .font(.system(size: DemoConsts.textSize,
                        design: .monospaced))
          .frame(width: DemoConsts.textCellWidth,
                 height: DemoConsts.textCellHeight * 2 + 2 + 4,
                 alignment: .center)
        
        BitView(value: .constant(true),
                canChange: .constant(false),
                flickerOnChange: false)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(4)
        .opacity(0.5)
      }
      
      VStack(alignment: .center, spacing: 4) {
        VStack(alignment: .leading, spacing: 2) {
          source
          compliment
        }
        .cornerRadius(4)
        result
          .cornerRadius(4)
        Label(model.isPaused ? "Resume" : "Pause",
              systemImage: model.isPaused ? "play.circle" : "pause.circle")
          .foregroundColor(.secondary)
          .font(.caption)
          .onTapGesture {
            model.isPaused.toggle()
          }
      }
      
      VStack(alignment: .leading, spacing: 2) {
        Text(model.source.signStr)
          .frame(width: DemoConsts.textCellWidth * 4,
                 height: DemoConsts.textCellHeight,
                 alignment: .leading)
        Text(model.compliment.signStr)
          .frame(width: DemoConsts.textCellWidth * 4,
                 height: DemoConsts.textCellHeight,
                 alignment: .leading)
        Text("0")
          .frame(width: DemoConsts.textCellWidth * 4,
                 height: DemoConsts.textCellHeight,
                 alignment: .leading)
          .padding(.top, 2)
      }
      .font(.system(size: DemoConsts.textSize - 2,
                    design: .monospaced))
      .frame(width: DemoConsts.textCellWidth,
             alignment: .leading)
    }
    .onAppear {
      model.next()
    }
  }
  
  var source: some View {
    HStack(alignment: .top, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.source[7-i],
                canChange: .constant(false),
                flickerOnChange: false)
        .background(Color.secondary.opacity(0.2))
      }
    }
  }
  
  var compliment: some View {
    HStack(alignment: .top, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: $model.compliment[7-i],
                canChange: .constant(false),
                flickerOnChange: false)
        .background(Color.secondary.opacity(0.2))
      }
    }
  }
  
  var result: some View {
    HStack(alignment: .top, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        BitView(value: .constant(false),
                canChange: .constant(false),
                flickerOnChange: false)
        .background(Color.secondary.opacity(0.2))
      }
    }
  }
}

struct TwoComplimentOverflowDemo_Previews: PreviewProvider {
  static var previews: some View {
    TwoComplimentOverflowDemo()
  }
}

class TwoComplimentOverflowDemoModel: ObservableObject {
  @Published public var source: UInt8 = 0
  @Published public var compliment: UInt8 = 0
  @Published public var isPaused = false
  
  public func next() {
    if !isPaused {
      source &+= 1
      compliment = ~source &+ 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
      guard let self else { return }
      self.next()
    }
  }
}
