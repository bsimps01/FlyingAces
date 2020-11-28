//
//  TutorialScene4.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 11/27/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit
import AVFoundation

class TutorialScene4: SKScene, SKPhysicsContactDelegate {
    
    var gamePlayLabel: SKLabelNode!
    let player = SKSpriteNode(imageNamed: "player")
    let enemyCategory: UInt32 = 0x1 << 1
    let bulletCategory: UInt32 = 0x1 << 0
    let playerCategory: UInt32 = 0x1 << 0
    enum colliderType: UInt32 {
        case heroPlane = 1
        case enemies = 2
    }
    var gameTimer: Timer!
    var enemyPlanes = ["enemy1", "enemy2", "enemy3", "enemy4", "enemy5"]
    var animationDuration: TimeInterval = 2
    var livesArray: [SKSpriteNode]!
    
    override init(size: CGSize) {
        // do initial configuration work here
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let enemy = Enemy()
        if self.livesArray.count == 0 {
            let gameOverLabel = SKLabelNode(text: "Game Over")
            gameOverLabel.fontSize = 65.0
            gameOverLabel.fontColor = SKColor.red
            gameOverLabel.fontName = "Copperplate-Bold"
            gameOverLabel.zPosition = 5
            gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
            enemy.removeFromParent()
            player.removeFromParent()
            addChild(gameOverLabel)
        }
    }

    override func didMove(to view: SKView) {
        
        let flyingAcesLogo = SKSpriteNode(imageNamed: "FlyingAcesLogo")
        flyingAcesLogo.size = CGSize(width: 100, height: 100)
        flyingAcesLogo.zPosition = 3
        flyingAcesLogo.position = CGPoint(x: size.width/2, y: size.height - 50)
        self.addChild(flyingAcesLogo)
        createBackground()
        createPlayer()
        createHowToPlayLabel()
        createButtons()
        addLives()
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self
        let timeInterval = 2.0
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(addPlane), userInfo:nil, repeats: true)
    }
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "tutorialBackground")
        background.zPosition = -1
        background.size = UIScreen.main.bounds.size
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(background)
    }
    func createPlayer(){
        player.position = CGPoint(x: view!.frame.width / 2, y: view!.frame.height / 2)
        player.size = CGSize(width: 120, height: 170)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.isDynamic = false
        self.addChild(player)
    }
    
    func createHowToPlayLabel(){
        gamePlayLabel = SKLabelNode(text: "You have three lives. If a plane hits you or flies past you then you lose a life. Get the highest score before you lose all lives!")
        gamePlayLabel.fontSize = 28
        gamePlayLabel.fontColor = SKColor.white
        gamePlayLabel.fontName = "Copperplate-Bold"
        gamePlayLabel.zPosition = 5
        gamePlayLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 250)
        gamePlayLabel.lineBreakMode = .byWordWrapping
        gamePlayLabel.numberOfLines = 0
        gamePlayLabel.preferredMaxLayoutWidth = 360
        self.addChild(gamePlayLabel)
    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in (touches) {
//            let location = touch.location(in: self)
//
//            if player.contains(location){
//                player.position = location
//            }
//        }
//    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //get the first touch
//        //move the plane to the touch's x position
//        //leave y the same
//        for touch in touches {
//            let positionInScene = touch.location(in: self)
//            let name = self.player.atPoint(positionInScene).name
//            let nodeFound = self.player.atPoint(positionInScene)
//            
//            if name != nil {
//                nodeFound.removeFromParent()
//            }
//        }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //fireBullets()
    }
    
    func addLives(){
        livesArray = [SKSpriteNode]()
        
        for live in 1...3 {
            let liveNode = SKSpriteNode(imageNamed: "player")
            liveNode.size = CGSize(width: 50, height: 50)
            liveNode.zPosition = 4
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width, y: self.frame.size.height - 40)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    @objc func addPlane() {
        let enemy = Enemy()
        let randomEnemyPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomEnemyPosition.nextInt())
        enemy.zPosition = 3
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height)
        
        self.addChild(enemy)
        
        //var animationDuration: TimeInterval = 2
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -enemy.size.height), duration: animationDuration))
        actionArray.append(SKAction.run {self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))

            
            if self.livesArray.count > 0 {
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                self.livesArray.removeFirst()
                
            }
        })
        
        
        actionArray.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actionArray))
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
            //self.score += 5
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
        }
        
        
    }
    
    func fireBullets() {
        //Creates the bullets and adds effects with how it reacts after pressing down on the screen
        self.run(SKAction.playSoundFileNamed("Bullet.mp3", waitForCompletion: false))
        let bulletNode = SKSpriteNode(imageNamed: "bullet")
        bulletNode.zPosition = 3
        bulletNode.size = CGSize(width: 15, height: 90)
        bulletNode.position = CGPoint(x: player.position.x, y: player.position.y + 120)
        bulletNode.position.y += 5
        bulletNode.physicsBody = SKPhysicsBody(circleOfRadius: bulletNode.size.width / 2)
        bulletNode.physicsBody?.isDynamic = true
        bulletNode.physicsBody?.collisionBitMask = 0
        bulletNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bulletNode)
        
        let animationDuration: TimeInterval = 0.1
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        bulletNode.run(SKAction.sequence(actionArray))
        
    }
    
    func createButtons(){
        let buttonTexture = SKTexture(imageNamed: "button")
        let buttonSelected = SKTexture(imageNamed: "button2")
        
        let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene4.buttonTap))
        button.setButtonLabel(title: "Main Menu", font: "Copperplate", fontSize: 20)
        button.position = CGPoint(x: self.frame.width / 6, y: self.frame.height - 50)
        button.size = CGSize(width: 120, height: 50)
        button.zPosition = 4
        self.addChild(button)
        
        let button2 = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button2.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene4.buttonTap2))
        button2.setButtonLabel(title: "Next", font: "Copperplate", fontSize: 22)
        button2.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY - 290)
        button2.size = CGSize(width: 150, height: 50)
        button2.zPosition = 4
        self.addChild(button2)
        
        let button3 = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button3.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene4.buttonTap3))
        button3.setButtonLabel(title: "Back", font: "Copperplate", fontSize: 22)
        button3.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY - 290)
        button3.size = CGSize(width: 150, height: 50)
        button3.zPosition = 4
        self.addChild(button3)
    }
    
    @objc func buttonTap(){
        let gameScene = MenuScene(size: (self.view?.bounds.size)!)
        
        gameScene.scaleMode = .aspectFill
        let crossFade = SKTransition.crossFade(withDuration: 0.75)
        //backgroundMusicPlayer!.stop()
        if let spriteview = self.view{
            spriteview.presentScene(gameScene, transition: crossFade)
        }
        
    }
    
    @objc func buttonTap2(){
        let infoScene = TutorialScene5(size: (self.view?.bounds.size)!)
        
        infoScene.scaleMode = .aspectFill
        let close = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(infoScene, transition: close)
        }
    }
    
    @objc func buttonTap3(){
        let infoScene = TutorialScene3(size: (self.view?.bounds.size)!)
        
        infoScene.scaleMode = .aspectFill
        let open = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(infoScene, transition: open)
        }
    }
}
