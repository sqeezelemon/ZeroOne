// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct MultiplyArticle: View {
  var body: some View {
    Article(title: "Multiplication") {
      MultiplyThumbnail(xRes: 16, yRes: 8, baseHeight: 400)
    } content: {
      VStack(alignment: .leading, spacing: 8) {
        bitShift
        multiplication
      }
    }
  }
  
  var bitShift: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("Before we get into multiplication, we need to learn about another operation - bit shift. In it's essence, bit shift is moving bits a set amount to the left or to the right, with the bits that are moved out of the bounds being discarded and with the bits moving in from out of bounds being zero. You can try it in action bellow:")
      
      BitShiftDemo()
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
      
      Text("One observation to make is that a bit shift is equivalent to dividing (right shift) and multiplying (left shift) by 2, with overflow in mind.")
    }
  }
  
  var multiplication: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("Getting into multiplication")
        .font(.title2.bold())
      Text("Now that we've finished with the prerequisites, it's time to get to the bottom of unsigned (positive numbers only) multiplication.")
      
      Text("If you did long multiplication at school, then this should sound familiar. For each bit of the number we want to multiply by that is 1, we add the other number to our result, shifted by the position of the bit in question. Here's an example of how that might look:")
      
      multiplyExample
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
      
      Text("It should be noted than on the actual hardware, the shifts don't need to be executed separately. Instead, they are hard wired.")
      
      Text("If we want to work signed numbers (positive/negative) though, we'd need to multiply their absolute values, after which you'd need to change the sign according to math. Bellow you can test yourself in multiplication.")
      
      MultiplicationDemo()
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
      
      Text("For best experience, use numbers that when multiplied are less than 512, so that you don't loose too much information to the overflow.")
    }
  }
  
  var multiplyExample: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(alignment: .center, spacing: 4) {
        Text("X")
          .font(.system(size: 20, design: .monospaced))
          .frame(width: 20)
        VStack(alignment: .leading, spacing: 2) {
          numRow(0b111)
          numRow(0b1010)
        }
        .cornerRadius(4)
        
        Rectangle()
          .frame(width: 2)
          .padding(.vertical, 4)
        Text("Numbers\nTo multiply")
      }
      
      HStack(alignment: .center, spacing: 4) {
        Text("+")
          .font(.system(size: 20, design: .monospaced))
          .frame(width: 20)
        
        VStack(alignment: .leading, spacing: 2) {
          numRow(0)
            .foregroundColor(.secondary)
          numRow(0b1110)
          numRow(0b0)
            .foregroundColor(.secondary)
          numRow(0b111000)
        }
        .cornerRadius(4)
        
        Rectangle()
          .frame(width: 2,
                 height: 30 * 4 - 2)
        Text("Expand\nInto sum")
      }
      HStack(alignment: .center, spacing: 4) {
        Text("=")
          .font(.system(size: 20, design: .monospaced))
          .frame(width: 20)
        numRow(0b1000110)
          .cornerRadius(4)
        Rectangle()
          .frame(width: 2)
          .padding(.vertical, 4)
        Text("Result")
      }
      Text("4 all-zero rows were omitted for brevity")
        .font(.caption)
        .foregroundColor(.secondary)
        .frame(width: 8 * 30 + 7 * 2, alignment: .center)
        .padding(.leading, 24)
    }
  }
  
  func numRow(_ num: Int) -> some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<8, id: \.self) { i in
        Text(num[7-i] ? "1" : "0")
          .frame(width: 30, height: 30, alignment: .center)
          .background(Color.secondary.opacity(0.2))
      }
    }
    .font(.system(size: 20, design: .monospaced))
  }
}

struct MultiplyArticle_Previews: PreviewProvider {
  static var previews: some View {
    MultiplyArticle()
      .environmentObject(AppSettings())
  }
}
