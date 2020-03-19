//
//  GameScene.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 1/6/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Clouds = SKSpriteNode()
    var Waves = SKSpriteNode()
    //var player: SKSpriteNode!
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
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMove(to view: SKView){
        //Sets the logic for creating the player in the game
       //let player = SKSpriteNode(imageNamed: "player")
        
        //player.position = CGPoint(x: 0, y: player.size.height / 2 + 10)
        
        self.addChild(player)
        //Sets the location for the objects in the game
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        player.xScale = 0.5
        player.yScale = 0.5
        player.position = CGPoint(x: frame.width / 2 + 10, y: frame.height / 2)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        //Creates the score for the logic when an enemy gets hit
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 120, y: self.frame.size.height - 60)
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.yellow
        score = 0
        
        self.addChild(scoreLabel)
        //Sets the amount of planes that get emmitted from the top of the game
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addPlane), userInfo:nil, repeats: true)
        //Creates the movement for the player on the screen
        
        createClouds()
        createWaves()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.location(in: self)
            
            if player.contains(location){
                player.position = location
            }
        }
    }
    
    //Creates the enemy planes in the game
    @objc func addPlane() {
        enemyPlanes = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemyPlanes) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: enemyPlanes[0])
        
        let randomEnemyPosition = GKRandomDistribution(lowestValue: -200, highestValue: 200)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get the first touch
        //move the plane to the touch's x position
        //leave y the same
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let name = self.player.atPoint(positionInScene).name
            let nodeFound = self.player.atPoint(positionInScene)
            
            if name != nil {
                nodeFound.removeFromParent()
            }
        }
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.location(in: self)
            
            if player.contains(location){
                player.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullets()
    }
    override func update(_ currentTime: TimeInterval) {
        moveClouds()
        moveWaves()
}
    
    func fireBullets() {
        //Creates the bullets and adds effects with how it reacts after pressing down on the screen
        let bulletNode = SKSpriteNode(imageNamed: "bullet")
        bulletNode.position = player.position
        bulletNode.position.y += 5
        
        bulletNode.physicsBody = SKPhysicsBody(circleOfRadius: bulletNode.size.width / 2)
        bulletNode.physicsBody?.isDynamic = true
        
        bulletNode.physicsBody?.categoryBitMask = bulletCategory
        bulletNode.physicsBody?.contactTestBitMask = enemyCategory
        bulletNode.physicsBody?.collisionBitMask = 0
        bulletNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bulletNode)
        
        let animationDuration: TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        bulletNode.run(SKAction.sequence(actionArray))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & bulletCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0 {
            bulletDidCollideWithEnemy(bulletNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
            
        }
        
    }
    
    func bulletDidCollideWithEnemy (bulletNode:SKSpriteNode, enemyNode:SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = enemyNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        bulletNode.removeFromParent()
        enemyNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        score += 5
    }
    
    func enemyDidCollideWithPlayer (player: SKSpriteNode, enemyNode: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = enemyNode.position
        explosion.position = player.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        player.removeFromParent()
        enemyNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
    }

    func createClouds() {
        //Creates clouds that gets emitted from the clouds.png
        for i in 0...3 {
            let Clouds = SKSpriteNode(imageNamed: "Clouds")
            Clouds.name = "Clouds"
            Clouds.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            Clouds.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            Clouds.position = CGPoint(x: -(self.frame.size.width / 2), y: CGFloat(i) * Clouds.size.height)
            Clouds.zPosition = -1
        
            self.addChild(Clouds)
    }
}
    
    func createWaves(){
        //Creates waves background
        for i in 0...3 {
            let Waves = SKSpriteNode(imageNamed: "Waves")
            Waves.name = "Waves"
            Waves.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            Waves.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            Waves.position = CGPoint(x: -(self.frame.size.width / 2), y: CGFloat(i) * Waves.size.height)
            Waves.zPosition = -2
            
            self.addChild(Waves)
        }
    }

    func moveClouds() {
        //Moves the clouds down the screen in a loop
        self.enumerateChildNodes(withName: "Clouds", using: ({
            (node, error) in
            node.position.y -= 6
            if node.position.y < -((self.scene?.size.height)!) {
                node.position.y += (self.scene?.size.height)! * 3
        }
    }))
}
    func moveWaves() {
        self.enumerateChildNodes(withName: "Waves", using: ({
            (node, error) in
            node.position.y -= 2
            if node.position.y < -((self.scene?.size.height)!) {
                node.position.y += (self.scene?.size.height)! * 3
            }
            
        }))
    }
}
