// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct AdditionArticle: View {
  var body: some View {
    Article(title: "Addition") {
      AdditionThumbnail(xRes: 16, yRes: 8, baseHeight: 400)
    } content: {
      VStack(alignment: .leading, spacing: 8) {
        addition
        overflow
        
        Divider()
        
        AdditionDemo()
          .frame(maxWidth: .infinity)
      }
    }
  }
  
  //MARK: Article parts
  
  var addition: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("""
Addition is the most basic operation and it's one which the others build upon. It, however, is built on just 4 rules:
""")
      additionRules
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
      Text("The latter bit goes towards the result and the leading carries over to the next bit (to the left). Here's an example of such carry:")
      additionExample
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, 10)
    }
  }
  
  var overflow: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("Overflow")
        .font(.title2.bold())
      
      Text("The problem with a fixed number of bits is that we can run out of them. Say, we add 1 to 255 (maximum you can store in 8 bits) in an 8 bit space. The result, unlike what you might expect, is zero, because the carry overflowed outside our 8 bit bounds.")
      
      Text("This phenomena is called integer overflow. While it doesn't seem as scary at first, over the years it has been responsible for anything from Minecraft Far Lands (terrain generation glitch) to crashing the Ariane 5 rocket. If you code in Swift though, that's nothing to worry about - under the hood the language checks for overflow on all operations where it can occur and you'd need to explicitly tell it not to check for it.")
      
      swiftOverflow
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, 10)
      
      Text("And now after you've familiar with the rules, you can see it in action or try to add them up yourself. Just tap on the bytes you want to change and when ready, press check or calculate")
    }
  }
  
  //MARK: Illustrations
  
  var additionRules: some View {
    VStack(alignment: .center) {
      HStack(alignment: .center) {
        VStack(alignment: .leading) {
          ruleView("0 + 0 =", "0", "0")
          ruleView("1 + 1 =", "1", "0")
        }
        
        VStack(alignment: .leading) {
          ruleView("0 + 1 =", "0", "1")
          ruleView("1+1+1 =", "1", "1")
        }
      }
      
      HStack(alignment: .center, spacing: 0) {
        Text("1")
          .frame(width: 30, height: 30, alignment: .center)
          .background(.red.opacity(0.2))
          .cornerRadius(4)
          .font(.system(size: 20, design: .monospaced))
        Text("  -  Carry over to the next bit")
          .font(.system(size: 20, design: .default))
      }
    }
  }
  
  var additionExample: some View {
    HStack(alignment: .top, spacing: 2) {
      Text("+")
        .font(.system(size: 20, design: .monospaced))
        .frame(width: 30, height: 30 * 2 + 2, alignment: .center)
      
      VStack(alignment: .trailing, spacing: 2) {
        byteView([Character]("0011"))
        byteView([Character]("0011"))
        byteView([Character]("0110"))
          .padding(.vertical, 4)
        byteView([Character]("0110"))
      }
      VStack(alignment: .leading, spacing: 2) {
        Text(" = 3")
          .frame(height: 30, alignment: .center)
        Text(" = 3")
          .frame(height: 30, alignment: .center)
        Text(" - Carry")
          .frame(height: 30, alignment: .center)
          .padding(.vertical, 4)
        Text(" = 6")
          .frame(height: 30, alignment: .center)
      }
      .font(.system(size: 20, design: .monospaced))
    }
  }
  
  var swiftOverflow: some View {
    HStack(alignment: .top, spacing: 20) {
      VStack(alignment: .center) {
        Text("""
var a = UInt8.max
a += 1
""")
        .font(.system(.body, design: .monospaced))
        .frame(width: 200, alignment: .center)
        .padding(10)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(10)
        Text("Will crash")
          .font(.footnote)
      }
      
      VStack(alignment: .center) {
        Text("""
var a = UInt8.max
a **&**+= 1
""")
        .font(.system(.body, design: .monospaced))
        .frame(width: 200, alignment: .center)
        .padding(10)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(10)
        Text("Will overflow to 0")
          .font(.footnote)
      }
    }
  }
  
  //MARK: Utils
  
  func ruleView(_ equation: String, _ b0: String, _ b1: String) -> some View {
    HStack(alignment: .center) {
      Text(equation)
        .frame(width: 100, alignment: .trailing)
      HStack(alignment: .center, spacing: 2) {
        Text(b0)
          .frame(width: 30, height: 30, alignment: .center)
          .background(b0 == "0" ? Color.secondary.opacity(0.2) : .red.opacity(0.2))
        Text(b1)
          .frame(width: 30, height: 30, alignment: .center)
          .background(Color.secondary.opacity(0.2))
      }
      .cornerRadius(4)
      .frame(width: 100, alignment: .leading)
    }
    .font(.system(size: 20, design: .monospaced))
    .lineLimit(1)
  }
  
  func byteView(_ chars: [Character]) -> some View {
    HStack(alignment: .center, spacing: 2) {
      ForEach(0..<chars.count, id: \.self) { i in
        Text(String(chars[i]))
          .font(.system(size: 20, design: .monospaced))
          .frame(width: 30, height: 30, alignment: .center)
          .background(Color.secondary.opacity(0.2))
      }
    }
    .cornerRadius(4)
  }
}

struct AdditionArticle_Previews: PreviewProvider {
  static var previews: some View {
    AdditionArticle()
      .environmentObject(AppSettings())
  }
}
