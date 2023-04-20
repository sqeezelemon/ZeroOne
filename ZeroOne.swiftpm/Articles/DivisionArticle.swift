// ZeroOne
// ↳ DivisionArticle.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct DivisionArticle: View {
  var body: some View {
    Article(title: "Division") {
      DivisionThumbnail()
    } content: {
      VStack(alignment: .leading, spacing: 8) {
        division
        DivisionDemo()
      }
    }
  }
  
  var division: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text("If there's one thing computers don't like it's integer division. That's because this operation requires branching - a much harder concept to physically make than, say, an shifter. So much so in fact, that despite all the groundbreaking innovation, the iPhone didn't get hardware division until iPhone 5 and instead relied on a function called `___divsi3`. Even crazier, some of the lower end ARM-based CPUs still don't include hardware support for integer division!")
      
      Text("This is to say, division is, again, hard. Bellow you can play around with the pseudocode similar to the algorithm used for unsigned division on the pre-division iPhone, which was usually further wrapped in code to handle signed integers.")
    }
  }
}

struct DivisionArticle_Previews: PreviewProvider {
  static var previews: some View {
    DivisionArticle()
  }
}
