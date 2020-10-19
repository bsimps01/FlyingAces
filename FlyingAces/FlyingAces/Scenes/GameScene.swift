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
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Clouds = SKSpriteNode()
    var Waves = SKSpriteNode()
    //var player: SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var scoreLabelText:SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    public var backgroundMusicPlayer: AVAudioPlayer?
    
    var gameTimer: Timer!
    var enemyPlanes = ["enemy1", "enemy2", "enemy3"]
    let enemyCategory: UInt32 = 0x1 << 1
    let bulletCategory: UInt32 = 0x1 << 0
    let playerCategory: UInt32 = 0x1 << 0
    let player = SKSpriteNode(imageNamed: "player")
    
    enum colliderType: UInt32 {
        case heroPlane = 1
        case enemies = 2
    }
    
    var livesArray: [SKSpriteNode]!
    
    override func didMove(to view: SKView){
        //Sets the logic for creating the player in the game
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self
        //Creates the score for the logic when an enemy gets hit
        scoreLabelText = SKLabelNode(text: "Score")
        scoreLabelText.position = CGPoint(x: 75, y: self.frame.size.height - 45)
        scoreLabelText.fontName = "Copperplate"
        scoreLabelText.fontSize = 35
        scoreLabelText.fontColor = UIColor.yellow
        scoreLabelText.zPosition = 4
        
        scoreLabel = SKLabelNode(text: "\(score)")
        scoreLabel.position = CGPoint(x: 75, y: self.frame.size.height - 70)
        scoreLabel.fontName = "Copperplate"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        self.addChild(scoreLabelText)
        //Sets the amount of planes that get emmitted from the top of the game
        
        let timeInterval = 0.75
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(addPlane), userInfo:nil, repeats: true)
        //Creates the movement for the player on the screen
        createPlayer()
        createClouds()
        createLand()
        addLives()
        playBackgroundMusic("backgroundMusicGame.mp3")
    }
    
    public func playBackgroundMusic(_ filename: String) {
      let url = Bundle.main.url(forResource: "backgroundMusicGame.mp3", withExtension: nil)
      if (url == nil) {
        print("Could not find file: \(filename)")
        return
      }

      var error: NSError? = nil
      do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
      } catch let error1 as NSError {
        error = error1
        backgroundMusicPlayer = nil
      }
      if let player = backgroundMusicPlayer {
        player.numberOfLoops = -1
        player.prepareToPlay()
        player.play()
      } else {
        print("Could not create audio player: \(error!)")
      }
    }
    
    func createPlayer(){
        player.position = CGPoint(x: view!.frame.width / 2, y: 75)
        player.size = CGSize(width: 100, height: 150)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.isDynamic = false
        //player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.addChild(player)
    }
    
    func addLives(){
        livesArray = [SKSpriteNode]()
        
        for live in 1...3 {
            let liveNode = SKSpriteNode(imageNamed: "player")
            liveNode.size = CGSize(width: 50, height: 50)
            liveNode.zPosition = 3
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width, y: self.frame.size.height - 40)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            
            if player.contains(location){
                player.position = location
            }
        }
    }
    
    //Creates the enemy planes in the game
    @objc func addPlane() {
        let enemy = Enemy()

        let randomEnemyPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomEnemyPosition.nextInt())
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height)
        
        self.addChild(enemy)
        
        let animationDuration: TimeInterval = 3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -enemy.size.height), duration: animationDuration))
                actionArray.append(SKAction.run {self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        if self.livesArray.count > 0 {
            let liveNode = self.livesArray.first
            liveNode!.removeFromParent()
            self.livesArray.removeFirst()
            
            if self.livesArray.count == 0 {
                self.backgroundMusicPlayer!.stop()
                let transition = SKTransition.crossFade(withDuration: 0.2)
                let gameOver = GameOverScene(size: (self.view?.bounds.size)!)
                gameOver.finalScore = self.score
                self.view?.presentScene(gameOver, transition: transition)
            }
        }
                })
        
        
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullets()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveClouds()
        moveLand()
    }
    
    func fireBullets() {
        //Creates the bullets and adds effects with how it reacts after pressing down on the screen
        self.run(SKAction.playSoundFileNamed("Bullet.mp3", waitForCompletion: false))
        let bulletNode = SKSpriteNode(imageNamed: "bullet")
        bulletNode.size = CGSize(width: 15, height: 90)
        bulletNode.position = CGPoint(x: player.position.x, y: player.position.y + 120)
        bulletNode.position.y += 10
        bulletNode.physicsBody = SKPhysicsBody(circleOfRadius: bulletNode.size.width / 2)
        bulletNode.physicsBody?.isDynamic = true
        bulletNode.physicsBody?.categoryBitMask = bulletCategory
        bulletNode.physicsBody?.contactTestBitMask = enemyCategory
        bulletNode.physicsBody?.collisionBitMask = 0
        bulletNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bulletNode)
        
        let animationDuration: TimeInterval = 0.3
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height), duration: animationDuration))
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
            bulletDidCollideWithEnemy(bulletNode: (firstBody.node as! SKSpriteNode), enemyNode: (secondBody.node as! SKSpriteNode))
            self.score += 5
        }
        if (firstBody.categoryBitMask & enemyCategory) != 0 && (secondBody.categoryBitMask & playerCategory) != 0 {
            
            enemyDidCollideWithPlayer(player: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
            

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
    }
    
    func enemyDidCollideWithPlayer (player: SKSpriteNode, enemyNode: SKSpriteNode){
        let explosion1 = SKEmitterNode(fileNamed: "Explosion")!
        explosion1.position = player.position
        self.addChild(explosion1)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        player.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion1.removeFromParent()
        }
        if self.livesArray.count > 0 {
            let liveNode = self.livesArray.first
            liveNode!.removeFromParent()
            self.livesArray.removeFirst()
            
            if self.livesArray.count == 0 {
                self.backgroundMusicPlayer!.stop()
                let transition = SKTransition.crossFade(withDuration: 0.2)
                let gameOver = GameOverScene(size: (self.view?.bounds.size)!)
                gameOver.finalScore = self.score
                self.view?.presentScene(gameOver, transition: transition)
        }
        }
        
        
    }
    
    func createClouds() {
        //Creates clouds that gets emitted from the clouds.png
        for i in 0...3 {
            let Clouds = SKSpriteNode(imageNamed: "Clouds")
            Clouds.name = "Clouds"
            Clouds.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            Clouds.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            Clouds.position = CGPoint(x: -(self.frame.size.width / 1000), y: CGFloat(i) * Clouds.size.height)
            Clouds.zPosition = -1
            
            self.addChild(Clouds)
        }
    }
    
    func createLand(){
        //Creates waves background
        for i in 0...3 {
            let Land = SKSpriteNode(imageNamed: "Land")
            Land.name = "Land"
            Land.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            Land.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            Land.position = CGPoint(x: -(self.frame.size.width / 1000), y: CGFloat(i) * Land.size.height)
            Land.zPosition = -2
            
            self.addChild(Land)
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
    func moveLand() {
        self.enumerateChildNodes(withName: "Land", using: ({
            (node, error) in
            node.position.y -= 1
            if node.position.y < -((self.scene?.size.height)!) {
                node.position.y += (self.scene?.size.height)! * 3
            }
            
        }))
    }
}
