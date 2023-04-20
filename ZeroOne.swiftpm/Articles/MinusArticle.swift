// ZeroOne
// ↳ MinusArticle.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct MinusArticle: View {
  var body: some View {
    Article(title: "Subtraction") {
      MinusThumbnail(baseHeight: 400)
    } content: {
      VStack(alignment: .leading, spacing: 10) {
        intro
        compliment
        subtraction
      }
    }
  }
  
  
  //MARK: Article parts
  // Split into several parts because it would have needed to be split anyways because of SwiftUI's template maximum of 10
  
  var intro: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("Before we get to subtraction, we first need to figure out how do we store binary numbers.")
      Text("The naive approach would be to just use a flag (a single bit) to mark a number as negative, for example like this:")
      
      bitFlagExample
        .padding(.vertical, 10)
      
      Text("But while this is easy for humans, this creates the problem of two zeros, which would have been required to be solved on a hardware level")

      twoZeros
        .padding(.vertical, 10)
      
      Text("This is fixable though. By simply choosing one of the zeros as the zero and using the other zero to represent a non-zero integer. This is why, for example, an 8 bit integer can store numbers from -128 to 127 - the negative range (first bit 1) is dedicated only for the negative numbers, while the positive is dedicated to both positive integers and zero.")
    }
  }
  
  var compliment: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("Two's compliment")
        .font(.title3.bold())
        .padding(.top, 8)
      Text("""
But to actually invert a binary integer, we need a bit more - get it's two's compliment, done in 2 steps:
`1. `Invert all bits (0 becomes 1 and vice versa)
`2. `Add 1
The resulting binary integer is called two's compliment and is all you need to change the sign of a binary integer. You can try calculating it yourself or get it calculated automatically bellow:
""")

      Divider()
        .padding(.top, 3)
      TwoComplimentDemo()
        .frame(maxWidth: .infinity,
               alignment: .top)
        .padding(.vertical, 12)
      Divider()
    }
  }
  
  var subtraction: some View {
    VStack(alignment: .leading) {
      Text("Getting into subtraction")
        .font(.title3.bold())
        .padding(.top, 8)
      Text("""
But how do we actually subtract once we have the two's compliment? Well, we just add up the numbers. Something to keep in mind is the use of overflow: there are still situations where it could be problematic (minimum minus one would give us the maximum), yet it also helps us when adding up anything negative related.
""")
      
      Divider()
      TwoComplimentOverflowDemo()
        .frame(maxWidth: .infinity,
               alignment: .top)
        .padding(.vertical, 12)
      Divider()
      
      Text("""
And while we're here, I'd like you to also marvel at the fact that it's not the actual bits that matters, it's how we interpret them.
""")
      interpretationDemo
        .frame(maxWidth: .infinity,
               alignment: .top)
    }
  }
  
  //MARK: Illustrations
  
  var bitFlagExample: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center, spacing: 2) {
        byteView([Character]("0___"))
        Text("Positive")
          .font(.footnote)
      }
      
      VStack(alignment: .center, spacing: 2) {
        byteView([Character]("1___"))
        Text("Negative")
          .font(.footnote)
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }
  
  var twoZeros: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center, spacing: 2) {
        byteView([Character]("0000"))
        Text("Zero")
          .font(.footnote)
      }
      
      VStack(alignment: .center, spacing: 2) {
        byteView([Character]("1000"))
        Text("Also Zero!")
          .font(.footnote)
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }
  
  var interpretationDemo: some View {
    HStack(alignment: .center) {
      Text("196 =")
      byteView([Character]("11000000"))
      Text("= -64")
    }
    .font(.system(size: 20, design: .monospaced))
  }
  
  func byteView(_ chars: [Character]) -> some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<chars.count, id: \.self) { i in
        Text(String(chars[i]))
          .font(.system(size: 20, design: .monospaced))
          .frame(width: 30, height: 30, alignment: .center)
          .background(Color.secondary.opacity(0.2))
          .bold(i == 0)
          .foregroundColor(i == 0 ? .primary : .secondary)
      }
    }
    .cornerRadius(4)
  }
}

struct MinusArticle_Previews: PreviewProvider {
  static var previews: some View {
    MinusArticle()
      .environmentObject(AppSettings())
  }
}
