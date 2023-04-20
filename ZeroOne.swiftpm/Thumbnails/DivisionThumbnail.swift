// ZeroOne
// ↳ DivisionThumbnail.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

import Foundation
import SwiftUI

struct DivisionThumbnail: View {
  @Environment(\.colorScheme) private var colorScheme
  var scene: DivisionScene
  
  public init(xRes: Int = 16, yRes: Int = 8, baseHeight: Int = 500) {
    scene = DivisionScene(xRes: xRes, yRes: yRes, baseHeight: baseHeight)
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

struct DivisionThumbnail_Previews: PreviewProvider {
  static var previews: some View {
    DivisionThumbnail()
  }
}

//MARK: Scene

import SpriteKit

class DivisionScene: SKScene {
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
        let xBase = xGridSize * (CGFloat(x) + 0.05)
        let yBase = yGridSize * (CGFloat(y) + 0.05)
        let wBase = xGridSize * 0.9
        
        //    1---2
        //   /   /
        //  /   /
        // 4---3
        var points: [CGPoint] = [
          .init(x: 2, y: 3),
          .init(x: 3, y: 3),
          .init(x: 1, y: 0),
          .init(x: 0, y: 0),
        ]
        for i in 0..<points.count {
          points[i].x = points[i].x * wBase / 3 + xBase
          points[i].y = points[i].y * wBase / 3 + yBase
        }
        
        let mutablePath = CGMutablePath()
        mutablePath.move(to: points[0])
        for p in points[1...] {
          mutablePath.addLine(to: p)
        }
        mutablePath.closeSubpath()
        
        let node = SKShapeNode(path: mutablePath, centered: true)
        node.position = CGPointMake((CGFloat(x) + 0.5) * xGridSize,
                                    (CGFloat(y) + 0.5) * yGridSize)
        node.fillColor = .label
        node.isAntialiased = true
        node.strokeColor = .clear
        addChild(node)
        objCol.append(node)
        node.run(.sequence([
          .wait(forDuration: delay(x, y)),
          .repeatForever(.rotate(byAngle: .pi / -1.5, duration: 2))
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
