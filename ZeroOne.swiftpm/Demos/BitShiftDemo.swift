// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct BitShiftDemo: View {
  @StateObject private var model = BitShiftDemoModel()
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center, spacing: 6) {
        Image(systemName: "arrowtriangle.backward.fill")
          .font(.system(size: 20))
          .offset(x: -1)
          .frame(width: DemoConsts.textCellWidth,
                 height: DemoConsts.textCellHeight)
          .background(Color.secondary.opacity(0.2))
          .onTapGesture {
            if !model.isActive {
              model.shiftLeft()
            }
          }
          .cornerRadius(.infinity)
        
        numView
        
        Image(systemName: "arrowtriangle.forward.fill")
          .font(.system(size: 20))
          .offset(x: 1)
          .frame(width: DemoConsts.textCellWidth,
                 height: DemoConsts.textCellHeight)
          .background(Color.secondary.opacity(0.2))
          .onTapGesture {
            if !model.isActive {
              model.shiftRight()
            }
          }
          .cornerRadius(.infinity)
      }
      HStack(alignment: .top) {
        Text("Shift left")
          .onTapGesture {
            if !model.isActive {
              model.shiftLeft()
            }
          }
        Spacer()
        Label("Reset", systemImage: "arrow.counterclockwise.circle")
          .onTapGesture {
            if !model.isActive {
              model.reset()
            }
          }
        Spacer()
        Text("Shift right")
          .onTapGesture {
            if !model.isActive {
              model.shiftRight()
            }
          }
      }
      .foregroundColor(.secondary)
      .font(.caption)
    }
    .frame(width: DemoConsts.textCellWidth * 10 + 2*7 + 6*2,
           alignment: .center)
  }
  
  var numView: some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        HStack(alignment: .center, spacing: 2) {
          Text(model.num[8-i] ? "1" : "0")
            .frame(width: DemoConsts.textCellWidth,
                   height: DemoConsts.textCellHeight,
                   alignment: .center)
          Text(model.num[7-i] ? "1" : "0")
            .frame(width: DemoConsts.textCellWidth,
                   height: DemoConsts.textCellHeight,
                   alignment: .center)
          Text(model.num[6-i] ? "1" : "0")
            .frame(width: DemoConsts.textCellWidth,
                   height: DemoConsts.textCellHeight,
                   alignment: .center)
        }
        .font(.system(size: DemoConsts.textSize, design: .monospaced))
        .offset(x: model.offset)
        .frame(width: DemoConsts.textCellWidth,
               height: DemoConsts.textCellHeight,
               alignment: .center)
        .clipped()
        .background(Color.secondary.opacity(0.2))
      }
    }
    .cornerRadius(4)
    .clipped()
  }
}

struct BitShiftDemo_Previews: PreviewProvider {
  static var previews: some View {
    BitShiftDemo()
  }
}

fileprivate class BitShiftDemoModel: ObservableObject {
  @Published public var num: UInt8 = .max
  @Published public var offset: CGFloat = 0
  @Published public var isActive: Bool = false
  @Published public var moveAmount: Int = 0
  
  func shiftLeft() {
    isActive = true
    withAnimation(.linear(duration: 0.1)) {
      offset = -DemoConsts.textCellWidth - 2
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let self else { return }
      self.num &<<= 1
      self.offset = 0
      self.isActive = false
    }
  }
  
  func shiftRight() {
    isActive = true
    withAnimation(.easeIn(duration: 0.1)) {
      offset = DemoConsts.textCellWidth + 2
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let self else { return }
      self.num &>>= 1
      self.offset = 0
      self.isActive = false
    }
  }
  
  func reset() {
    moveAmount = 0
    isActive = false
    withAnimation(.easeInOut(duration: 0.1)) {
      num = .max
    }
  }
}
