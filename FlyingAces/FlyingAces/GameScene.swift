//
//  GameScene.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 1/6/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Clouds = SKSpriteNode()
    var player:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer: Timer!
    var enemyPlanes = ["enemy1", "enemy2", "enemy3"]
    let enemyCategory: UInt32 = 0x1 << 1
    let bulletCategory:UInt32 = 0x1 << 0
    
    override func didMove(to view: SKView){
        
        player = SKSpriteNode(imageNamed: "player")
        
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        
        self.addChild(player)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 120, y: self.frame.size.height - 60)
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.yellow
        score = 0
        
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addPlane), userInfo:nil, repeats: true)
        
        createClouds()
    }
    
    @objc func addPlane() {
        enemyPlanes = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemyPlanes) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: enemyPlanes[0])
        
        let randomEnemyPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomEnemyPosition.nextInt())
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = bulletCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        let animationDuration: TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -enemy.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actionArray))
    }
    override func update(_ currentTime: TimeInterval) {
        moveClouds()
}

    func createClouds() {
        for i in 0...3 {
            let Clouds = SKSpriteNode(imageNamed: "Clouds")
            Clouds.name = "Clouds"
            Clouds.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            Clouds.anchorPoint = CGPoint(x: 0.0, y: 0)
            Clouds.position = CGPoint(x: -(self.frame.size.width / 2), y: CGFloat(i) * Clouds.size.height)
            Clouds.zPosition = -1
        
            self.addChild(Clouds)
    }
}

    func moveClouds() {
    
        self.enumerateChildNodes(withName: "Clouds", using: ({
            (node, error) in
        
            node.position.y -= 6
        
            if node.position.y < -((self.scene?.size.height)!) {
            
                node.position.y += (self.scene?.size.height)! * 3
        }
    }))
}
}
