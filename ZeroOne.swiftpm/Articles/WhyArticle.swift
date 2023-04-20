// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct WhyArticle: View {
  @State private var utfHoverViewText = [Character]("Hi,привет,你好,👋")
  @State private var utfHoverEventUuid = 0
  @State private var hoveredCharIndex = -1
  var body: some View {
    Article(title: "Why do binary integers matter?") {
      WhyThumbnail()
    } content: {
      VStack(alignment: .leading, spacing: 8) {
        articleBody
        binaryConversion
      }
    }
  }
  
  var articleBody: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("In a computer everything is a number. A true/false is either 0 or 1, a memory address is a number. Even this text is just a stream of numbers. In a way, all your devices are just fancy calculators. Which is why operations with binary integers are so instrumental - because in a way, they (along with floating point numbers) are what computing really is.")
      
      VStack(alignment: .center) {
        Text("Tap on a character to see the underlying number:")
          .font(.system(.caption))
          .foregroundColor(.secondary)
        utfHoverView
          .padding(.bottom, 30)
      }
      .frame(maxWidth: .infinity, alignment: .top)
      .padding(.top, 10)
    }
  }
  
  var binaryConversion: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("Converting to and from binary")
        .font(.title2.bold())
      
      Text("Just as decimal can be expressed as a sum of digits multiplied by 10 in a certain power, binary is 0 or 1 multiplied by a power of 2. The conversion to binary is simple - you divide by 2, write the remainder at the back and repeat it until you reach 0. And the conversion from it is just as simple - you multiply each bit by 2 to the power of it's position from the right, starting from 0, and sum it up")
      
      HStack(alignment: .top, spacing: 20) {
        conversionToBinary
        Divider()
          .padding(.horizontal, 20)
        conversionFromBinary
      }
      .fixedSize(horizontal: true, vertical: false)
      .frame(maxWidth: .infinity, alignment: .center)
    }
  }
  
  var utfHoverView: some View {
    HStack(alignment: .center, spacing: 0) {
      ForEach(0..<utfHoverViewText.count, id:\.self) { i in
        Text(String(utfHoverViewText[i]))
          .font(.system(size: 30, design: .monospaced))
          .foregroundColor(hoveredCharIndex == i ? .pink : .primary)
          .onTapGesture {
            hoveredCharIndex = i
          }
          .onHover { isHovering in
            if isHovering {
              hoveredCharIndex = i
            } else if hoveredCharIndex == i {
              hoveredCharIndex = -1
            }
          }
          .overlay {
            if hoveredCharIndex == i {
              utfAnnotation(utfHoverViewText[i])
                .offset(y: 35)
                .frame(width: 200)
                .onTapGesture {
                  hoveredCharIndex = -1
                }
            }
          }
          .animation(.easeIn(duration: 0.1), value: hoveredCharIndex)
      }
    }
  }
  
  private var numFromBinary = [Character]("1011")
  var conversionFromBinary: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack(alignment: .top, spacing: 2) {
        ForEach(0..<numFromBinary.count, id:\.self) { i in
          Text(String(numFromBinary[i]))
            .frame(width: 30, height: 30)
            .background(Color.secondary.opacity(0.2))
        }
      }
      .cornerRadius(4)
      ForEach(0..<numFromBinary.count, id:\.self) { i in
        HStack(alignment: .firstTextBaseline, spacing: CGFloat(numFromBinary.count - 1) * (30+2) ) {
          Text(String(numFromBinary[i]))
            .frame(width: 30, height: 20,
                   alignment: .center)
            .offset(x: (30 + 2) * CGFloat(i))
          Text("×2")
          + Text(String(numFromBinary.count - i - 1))
            .font(.system(size: 10, design: .monospaced))
            .baselineOffset(8)
        }
      }
      Text("=11")
        .offset(x: (30 + 2) * 4)
    }
    .font(.system(size: 20, design: .monospaced))
  }
  
  private var numsToBinary = ["11", "05", "02", "01"].map { [Character]($0) }
  private var numsToBinaryBin = [Character]("1101")
  var conversionToBinary: some View {
    VStack(alignment: .leading) {
      ForEach(0..<numsToBinary.count, id: \.self) { i in
        HStack(alignment: .center, spacing: 4) {
          HStack(alignment: .center, spacing: 2) {
            Text(String(numsToBinary[i][0]))
              .frame(width: 30, height: 30, alignment: .center)
              .background(Color.secondary.opacity(0.2))
            Text(String(numsToBinary[i][1]))
              .frame(width: 30, height: 30, alignment: .center)
              .background(Color.secondary.opacity(0.2))
            
          }
          .cornerRadius(4)
          
          Image(systemName: "arrow.forward")
            .frame(width: 30, height: 30, alignment: .center)
          
          Text(String(numsToBinaryBin[i]))
            .frame(width: 30, height: 30, alignment: .center)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(4)
        }
        .font(.system(size: 20, design: .monospaced))
      }
    }
  }
  
  func utfAnnotation(_ char: Character) -> some View {
    HStack(alignment: .center, spacing: 4) {
      Text(String(char))
        .foregroundColor(.pink)
      
      Text("=")
        .foregroundColor(.secondary)
      
      Text(char.unicodeScalars.map { String(format: "%04d", $0.value) }.joined(separator: " "))
    }
    .font(.system(size: 20, design: .monospaced))
    .padding(.vertical, 3)
    .padding(.horizontal, 6)
    .background(Color.primary.colorInvert().opacity(0.8))
    .cornerRadius(2)
  }
}

struct WhyArticle_Previews: PreviewProvider {
  static var previews: some View {
    WhyArticle()
  }
}
