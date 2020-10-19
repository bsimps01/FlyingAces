//
//  Enemy.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 10/17/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

enum enemyPlaneCollection: String, CaseIterable{
    case enemy1 = "enemy1"
    case enemy2 = "enemy2"
    case enemy3 = "enemy3"
    case enemy4 = "enemy4"
    case enemy5 = "enemy5"
}

class Enemy: SKSpriteNode, SKPhysicsContactDelegate{
    let enemyCategory: UInt32 = 0x1 << 1
    let bulletCategory: UInt32 = 0x1 << 0
    
    init(){
        let randomEnemy = enemyPlaneCollection.allCases.randomElement()!
        let enemy = SKTexture(imageNamed: randomEnemy.rawValue)
        let color = UIColor.clear
        let size = CGSize(width: 110, height: 140)
        super.init(texture: enemy, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = enemyCategory
        self.physicsBody?.contactTestBitMask = bulletCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
