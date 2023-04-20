// ZeroOne
// ↳ Navigation.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct Navigation: View {
  @StateObject private var settings = AppSettings()
  @State private var chosenArticle: ChosenArticle = .why
  var body: some View {
    NavigationSplitView {
      List {
        ArticleCard(title: "Prelude") {
          WhyThumbnail(xRes: 12, yRes: 6, baseHeight: 200)
        }
        .onTapGesture {
          chosenArticle = .why
        }
        
        ArticleCard(title: "Addition") {
          AdditionThumbnail(xRes: 12, yRes: 6, baseHeight: 200)
        }
        .onTapGesture {
          chosenArticle = .addition
        }
        
        ArticleCard(title: "Subtraction") {
          MinusThumbnail(xRes: 12, yRes: 6, baseHeight: 200)
        }
        .onTapGesture {
          chosenArticle = .subtraction
        }
        
        ArticleCard(title: "Multiplication") {
          MultiplyThumbnail(xRes: 12, yRes: 6, baseHeight: 200)
        }
        .onTapGesture {
          chosenArticle = .multiplication
        }
        
        ArticleCard(title: "Division") {
          DivisionThumbnail(xRes: 12, yRes: 6, baseHeight: 200)
        }
        .onTapGesture {
          chosenArticle = .division
        }
        
        Text("For WWDC23 by Alexander Nikitin")
          .font(.footnote)
          .frame(maxWidth: .infinity, alignment: .top)
      }
      .navigationTitle("ZeroOne")
    } detail: {
      switch chosenArticle {
      case .why:
        WhyArticle()
      case .addition:
        AdditionArticle()
      case .subtraction:
        MinusArticle()
      case .multiplication:
        MultiplyArticle()
      case .division:
        DivisionArticle()
      }
    }
    // .animation(.easeInOut(duration: 0.1), value: chosenArticle)
    .environmentObject(settings)
  }
}

struct Navigation_Previews: PreviewProvider {
  static var previews: some View {
    Navigation()
  }
}

enum ChosenArticle: Hashable {
  case why, addition, subtraction, multiplication, division
}
