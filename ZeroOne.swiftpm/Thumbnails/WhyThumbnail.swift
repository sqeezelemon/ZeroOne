// ZeroOne
// ↳ WhyScene.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation
import SwiftUI

struct WhyThumbnail: View {
  @Environment(\.colorScheme) private var colorScheme
  var scene: WhyScene
  
  public init(xRes: Int = 16, yRes: Int = 8, baseHeight: Int = 500) {
    scene = WhyScene(xRes: xRes, yRes: yRes, baseHeight: baseHeight)
    scene.scaleMode = .fill
  }
  
  var body: some View {
    SpriteView(scene: scene, options: [.allowsTransparency])
      .aspectRatio(2, contentMode: .fit)
      .onChange(of: colorScheme) { _ in
        scene.refreshColors()
      }
  }
}

struct WhyThumbnail_Previews: PreviewProvider {
  static var previews: some View {
    WhyThumbnail()
  }
}

//MARK: Scene

import SpriteKit

class WhyScene: SKScene {
  var xRes: Int = 16
  var yRes: Int = 8
  var shuffleTimer: Timer!
  
  init(xRes: Int = 16, yRes: Int = 8, baseHeight: Int = 500) {
    self.xRes = xRes
    self.yRes = yRes
    super.init(size: .init(width: (baseHeight * xRes) / yRes,
                           height: baseHeight))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 2D matrix of Nodes, delays [x][y]
  var objMatrix = [[SKLabelNode]]()
  
  override func sceneDidLoad() {
    super.sceneDidLoad()
    let cgxRes = CGFloat(xRes)
    let cgyRes = CGFloat(yRes)
    
    let xGridSize = size.width / cgxRes
    let yGridSize = size.height / cgyRes
    
    backgroundColor = .clear
    let fontSize = xGridSize * 0.8
    
    for x in 0..<xRes {
      var objCol = [SKLabelNode]()
      objCol.reserveCapacity(yRes)
      for y in 0..<yRes {
        let node = SKLabelNode(fontNamed: "Menlo-Bold")
        node.text = ["0", "1"].randomElement()!
        node.fontSize = fontSize
        node.position = CGPointMake((CGFloat(x) + 0.5) * xGridSize,
                                    (CGFloat(y) + 0.25) * yGridSize)
        node.fontColor = .label
        addChild(node)
        objCol.append(node)
      }
      objMatrix.append(objCol)
    }
    
    setupTimer()
  }
  
  public func shuffle() {
    for _ in 0..<((xRes + yRes)/16) {
      let xi = Int.random(in: 0..<xRes)
      let yi = Int.random(in: 0..<yRes)
      let node = objMatrix[xi][yi]
      if node.text == "1" {
        node.text = "0"
      } else {
        node.text = "1"
      }
    }
  }
  
  public func setupTimer() {
    shuffleTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
      guard let self else {
        timer.invalidate()
        return
      }
      self.shuffle()
    }
  }
  
  public func refreshColors() {
    for col in objMatrix {
      for obj in col {
        obj.fontColor = .label
      }
    }
  }
}
