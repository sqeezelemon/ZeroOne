// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct BitView: View {
  @Binding public var value: Bool
  @Binding public var canChange: Bool
  
  @State private var dragOffset: CGFloat = 0
  
  // Flag used to trigger animation when changed externally
  @State private var changedFlag: Bool = false
  // Whether should flicker when changed from code
  public var flickerOnChange: Bool = true
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text("0")
        .frame(width: DemoConsts.textCellWidth,
               height: DemoConsts.textCellHeight,
               alignment: .center)
      Text("1")
        .frame(width: DemoConsts.textCellWidth,
               height: DemoConsts.textCellHeight,
               alignment: .center)
    }
    .font(.system(size: DemoConsts.textSize, design: .monospaced))
    .offset(y: value ? -DemoConsts.textCellHeight : 0)
    .frame(width: DemoConsts.textCellWidth,
           height: DemoConsts.textCellHeight,
           alignment: .top)
    .clipped()
    .animation(.easeOut(duration: 0.125), value: value)
    .overlay {
      // To reduce view's hit target
      Color.secondary.opacity(0.0001)
        .padding(1)
        .onTapGesture {
          if canChange {
            value.toggle()
          }
        }
    }
//    .onTapGesture {
//      if canChange {
//        value.toggle()
//      }
//    }
    // Animate if changed externally
    .onChange(of: value) { _ in
      guard !canChange && flickerOnChange else { return }
      changedFlag.toggle()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.125) {
        changedFlag.toggle()
      }
    }
    .animation(.easeInOut(duration: 0.125), value: changedFlag)
    .foregroundColor(changedFlag ? .secondary : .primary)
//    .gesture(
//      DragGesture()
//        .onChanged { dragValue in
//          let dragUp = dragValue.startLocation.y < dragValue.location.y
//          if dragUp &&
//        })
  }
}

struct BitView_Previews: PreviewProvider {
  static var previews: some View {
    BitView(value: .constant(true),
            canChange: .constant(true))
  }
}
