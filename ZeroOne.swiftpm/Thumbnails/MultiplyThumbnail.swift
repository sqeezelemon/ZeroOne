// SpriteKitTest
// ↳ MultiplyThumbnail.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation
import SwiftUI

struct MultiplyThumbnail: View {
  @Environment(\.colorScheme) private var colorScheme
  
  var scene: MultiplyScene
  
  public init(xRes: Int = 16, yRes: Int = 8, baseHeight: Int = 500) {
    scene = MultiplyScene(xRes: xRes, yRes: yRes, baseHeight: baseHeight)
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

struct MultiplyThumbnail_Previews: PreviewProvider {
  static var previews: some View {
    MultiplyThumbnail()
  }
}

//MARK: Scene

import SpriteKit

class MultiplyScene: SKScene {
  var xRes: Int = 16
  var yRes: Int = 8
  // var appearance =
  
  init(xRes: Int, yRes: Int, baseHeight: Int = 500) {
    super.init(size: .init(width: (baseHeight * xRes) / yRes,
                           height: baseHeight))
    self.xRes = xRes
    self.yRes = yRes
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
    let radius = min(xGridSize, yGridSize) / 2
    
    backgroundColor = .clear
    
    for x in 0..<xRes {
      var objCol = [SKShapeNode]()
      objCol.reserveCapacity(yRes)
      for y in 0..<yRes {
        let circ = SKShapeNode(circleOfRadius: radius * 0.95)
        circ.position = CGPointMake((CGFloat(x) + 0.5) * xGridSize,
                                    (CGFloat(y) + 0.5) * yGridSize)
        circ.fillColor = .label
        circ.strokeColor = .clear
        circ.isAntialiased = true
        addChild(circ)
        objCol.append(circ)
        let actions: [SKAction] = [
          .scale(to: 1.0, duration: 1),
          .scale(to: 0.1, duration: 1),
        ]
        actions.forEach { $0.timingMode = .easeInEaseOut }
        circ.run(.sequence([
          .scale(to: 0.1, duration: 0),
          .wait(forDuration: delay(x, y)),
          .repeatForever(.sequence(actions))
        ]))
      }
      objMatrix.append(objCol)
    }
  }
  
  private func delay(_ x: Int, _ y: Int) -> CGFloat {
    let dist = sqrt(pow(CGFloat(x)-CGFloat(xRes - 1)/2, 2) + pow(CGFloat(y)-CGFloat(yRes - 1)/2, 2))
    let maxdist = sqrt(pow(CGFloat(xRes - 1)/2, 2) + pow(CGFloat(yRes - 1)/2, 2))
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
