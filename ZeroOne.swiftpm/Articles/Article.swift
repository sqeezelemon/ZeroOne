// ZeroOne
// ↳ Article.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import SwiftUI

struct Article<Thumbnail: View,
               Content : View>: View {
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject var settings: AppSettings
  public let title: String
  public let thumbnail: () -> Thumbnail
  public let content: () -> Content
  
  private var thumbnailBackground: Color {
    colorScheme == .dark ? .white : .black
  }
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        thumbnail()
          .colorInvert()
          .padding(10)
          .background(thumbnailBackground.opacity(settings.thumbnailsPaused ? 0.15 : 1.0))
          .cornerRadius(10)
          .padding(.top, 10)
          .animation(.easeInOut(duration: 0.5), value: settings.thumbnailsPaused)
        
        HStack(alignment: .center) {
          Text(title)
            .font(.title.bold())
            .padding(.horizontal, 10)
          Spacer()
          Label(settings.thumbnailsPaused ? "Undim thumbnails" : "Dim thumbnails",
                systemImage: settings.thumbnailsPaused ? "sun.max" : "sun.min")
            .foregroundColor(.secondary)
            .font(.caption)
            .onTapGesture {
              settings.thumbnailsPaused.toggle()
            }
        }
        content()
          .padding(.horizontal, 10)
        Spacer()
          .frame(height: 100)
      }
    }
    .padding(.horizontal, 10)
    .frame(maxWidth: 600)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct Article_Previews: PreviewProvider {
  static var previews: some View {
    Article(title: "Article title") {
      MultiplyThumbnail()
    } content: {
      Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut nulla nibh. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi sed luctus tellus. Cras a neque semper, cursus lorem viverra, consectetur justo. Phasellus luctus erat ac justo lobortis placerat. Sed molestie justo ut purus tempus, nec posuere lectus lobortis. Duis pulvinar eros quis elit fermentum tincidunt. Curabitur ut porttitor ipsum. Suspendisse ut nisi pulvinar velit ultricies facilisis. Aenean facilisis ipsum lacus. Proin commodo magna lectus, et vulputate nibh volutpat eu. Donec pellentesque nisi vel massa pulvinar vestibulum. Maecenas vulputate lectus ac mauris mollis, at elementum risus viverra. Pellentesque feugiat ante erat, vitae dignissim leo egestas sed. Cras vulputate lorem at ipsum vestibulum, vel placerat velit volutpat. Vivamus feugiat finibus orci in varius.")
    }
    .environmentObject(AppSettings())
  }
}
