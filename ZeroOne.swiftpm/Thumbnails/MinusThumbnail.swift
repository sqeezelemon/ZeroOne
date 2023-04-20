// ZeroOne
// ↳ MinusThumbnail.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation
import SwiftUI

struct MinusThumbnail: View {
  @Environment(\.colorScheme) private var colorScheme
  
  var scene: MinusScene
  
  public init(xRes: Int = 16, yRes: Int = 8, baseHeight: Int = 500) {
    scene = MinusScene(xRes: xRes, yRes: yRes, baseHeight: baseHeight)
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

struct MinusThumbnail_Previews: PreviewProvider {
  static var previews: some View {
    MinusThumbnail()
  }
}

//MARK: Scene

import SpriteKit

class MinusScene: SKScene {
  var xRes: Int = 16
  var yRes: Int = 8
  
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
  var objMatrix = [[SKShapeNode]]()
  
  override func sceneDidLoad() {
    super.sceneDidLoad()
    let cgxRes = CGFloat(xRes)
    let cgyRes = CGFloat(yRes)
    
    let xGridSize = size.width / cgxRes
    let yGridSize = size.height / cgyRes
    
    backgroundColor = .clear
    
    for x in 0..<xRes {
      var objCol = [SKShapeNode]()
      objCol.reserveCapacity(yRes)
      for y in 0..<yRes {
        let node = SKShapeNode(rectOf: CGSize(width: xGridSize,
                                              height: yGridSize))
        node.position = CGPointMake((CGFloat(x) + 0.5) * xGridSize,
                                    (CGFloat(y) + 0.5) * yGridSize)
        node.fillColor = .label
        node.strokeColor = .clear
        node.isAntialiased = true
        addChild(node)
        objCol.append(node)
        let actions: [SKAction] = [
          .scaleY(to: 0.9, duration: 1),
          .scaleY(to: 0.1, duration: 1),
        ]
        actions.forEach { $0.timingMode = .easeInEaseOut }
        node.run(.sequence([
          .scaleY(to: 0.1, duration: 0),
          .scaleX(to: 0.9, duration: 0),
          .wait(forDuration: delay(x, y)*2),
          .repeatForever(.sequence(actions))
        ]))
      }
      objMatrix.append(objCol)
    }
  }
  
  private func delay(_ x: Int, _ y: Int) -> CGFloat {
      let dist = CGFloat(x+(yRes - y))
      let maxdist = CGFloat(xRes + yRes - 2)
      return dist/maxdist
  }
  
  public func refreshColors() {
    for col in objMatrix {
      for obj in col {
        obj.fillColor = .label
      }
    }
  }
}
