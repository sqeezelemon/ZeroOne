// 
// ↳ SwiftUIView.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct ArticleCard<Thumbnail: View>: View {
  @EnvironmentObject var settings: AppSettings
  @Environment(\.colorScheme) private var colorScheme
  public let title: String
  public let preview: () -> Thumbnail
  var body: some View {
    VStack(alignment: .leading) {
      preview()
        .opacity(settings.thumbnailsPaused ? 0.2 : 1.0)
        .animation(.easeInOut(duration: 0.5), value: settings.thumbnailsPaused)
      Text(title)
        .font(.title3.bold())
    }
    .padding(10)
    .background(colorScheme == .dark ? .black : .white)
    .cornerRadius(10)
  }
}

struct ArticleCard_Previews: PreviewProvider {
  static var previews: some View {
    ArticleCard(title: "Test title") {
      MinusThumbnail()
    }
    .environmentObject(AppSettings())
  }
}
