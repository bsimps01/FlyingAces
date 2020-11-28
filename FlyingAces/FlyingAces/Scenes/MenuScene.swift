//
//  MenuScene.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 3/20/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    var Clouds = SKSpriteNode()
    public var backgroundMusicPlayer: AVAudioPlayer?
    
    override init(size: CGSize) {
        // do initial configuration work here
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
            moveClouds()
            moveLand()
    }
    
    override func didMove(to view: SKView) {
        let flyingAcesLogo = SKSpriteNode(imageNamed: "FlyingAcesLogo")
        flyingAcesLogo.size = CGSize(width: 350, height: 275)
        flyingAcesLogo.zPosition = 3
        flyingAcesLogo.position = CGPoint(x: size.width/2, y: size.height - 180)
        self.addChild(flyingAcesLogo)
        createButtons()
        createClouds()
        createLand()
        playBackgroundMusic("backgroundMusicMenu.mp3") }
    
    func createButtons(){
        let buttonTexture = SKTexture(imageNamed: "button")
        let buttonSelected = SKTexture(imageNamed: "button2")
        
        let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(MenuScene.buttonTap))
        button.setButtonLabel(title: "Start Game", font: "Copperplate", fontSize: 35)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        button.size = CGSize(width: 300, height: 80)
        button.zPosition = 4
        self.addChild(button)
        
        let button2 = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button2.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(MenuScene.buttonTap2))
        button2.setButtonLabel(title: "How to Play", font: "Copperplate", fontSize: 35)
        button2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 160)
        button2.size = CGSize(width: 300, height: 80)
        button2.zPosition = 4
        self.addChild(button2)
    }
    
    @objc func buttonTap(){
        let gameScene = GameScene(size: (self.view?.bounds.size)!)
        
        gameScene.scaleMode = .aspectFill
        let crossFade = SKTransition.crossFade(withDuration: 0.75)
        backgroundMusicPlayer!.stop()
        if let spriteview = self.view{
            spriteview.presentScene(gameScene, transition: crossFade)
        }
        
    }
    
    @objc func buttonTap2(){
        let infoScene = TutorialScene1(size: (self.view?.bounds.size)!)
        
        infoScene.scaleMode = .aspectFill
        let crossFade = SKTransition.crossFade(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(infoScene, transition: crossFade)
        }
    }
    
    public func playBackgroundMusic(_ filename: String) {
      let url = Bundle.main.url(forResource: "backgroundMusicMenu.mp3", withExtension: nil)
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

