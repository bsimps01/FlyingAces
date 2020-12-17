//
//  TutorialScene5.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 11/27/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class TutorialScene5: SKScene {
    
    var gamePlayLabel: SKLabelNode!
    var gamePlayLabel1: SKLabelNode!
    public var backgroundMusicPlayer: AVAudioPlayer?
    
    enum SKLabelVerticalAlignmentMode {
        case center
    }

    override init(size: CGSize) {
        // do initial configuration work here
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    override func didMove(to view: SKView) {
        
//        let flyingAcesLogo = SKSpriteNode(imageNamed: "FlyingAcesLogo")
//        flyingAcesLogo.size = CGSize(width: 200, height: 150)
//        flyingAcesLogo.zPosition = 3
//        flyingAcesLogo.position = CGPoint(x: size.width/2, y: size.height - 150)
//        self.addChild(flyingAcesLogo)
        let goodHunting = SKSpriteNode(imageNamed: "Good Hunting")
        goodHunting.size = CGSize(width: size.width, height: 250)
        goodHunting.zPosition = 3
        goodHunting.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(goodHunting)
        createBackground()
        //createHowToPlayLabel()
        createButtons()
    }
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "InfoBackgroundImage")
        background.zPosition = -1
        background.size = UIScreen.main.bounds.size
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(background)
    }

    func createHowToPlayLabel(){
        gamePlayLabel = SKLabelNode(text: "Good")
        gamePlayLabel.fontSize = 80
        gamePlayLabel.fontColor = SKColor.systemYellow
        gamePlayLabel.fontName = "Arial rounded mt bold"
        gamePlayLabel.zPosition = 5
        gamePlayLabel.verticalAlignmentMode = .center
        gamePlayLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        gamePlayLabel.lineBreakMode = .byWordWrapping
        gamePlayLabel.numberOfLines = 0
        gamePlayLabel.preferredMaxLayoutWidth = 360
        self.addChild(gamePlayLabel)
        
        gamePlayLabel1 = SKLabelNode(text: "Hunting!")
        gamePlayLabel1.fontSize = 80
        gamePlayLabel1.fontColor = SKColor.systemYellow
        gamePlayLabel1.fontName = "Arial rounded mt bold"
        gamePlayLabel1.zPosition = 5
        gamePlayLabel1.verticalAlignmentMode = .center
        gamePlayLabel1.position = CGPoint(x: size.width / 2, y: size.height / 2 - 40)
        gamePlayLabel1.lineBreakMode = .byWordWrapping
        gamePlayLabel1.numberOfLines = 0
        gamePlayLabel1.preferredMaxLayoutWidth = 360
        self.addChild(gamePlayLabel1)
    }
    
    func createButtons(){
        let buttonTexture = SKTexture(imageNamed: "button")
        let buttonSelected = SKTexture(imageNamed: "button2")
        
        let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene5.buttonTap))
        button.setButtonLabel(title: "Main Menu", font: "Copperplate", fontSize: 20)
        button.position = CGPoint(x: self.frame.width / 6, y: self.frame.height - 50)
        button.size = CGSize(width: 120, height: 50)
        button.zPosition = 4
        self.addChild(button)
        
        let button2 = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button2.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene5.buttonTap2))
        button2.setButtonLabel(title: "Play!", font: "Copperplate", fontSize: 22)
        button2.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY - 290)
        button2.size = CGSize(width: 150, height: 50)
        button2.zPosition = 4
        self.addChild(button2)
        
        let button3 = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button3.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene5.buttonTap3))
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
        let infoScene = GameScene(size: (self.view?.bounds.size)!)
        MyAudioPlayer.stopFile(name: "backgroundMusicMenu", type: "mp3")
        infoScene.scaleMode = .aspectFill
        let close = SKTransition.crossFade(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(infoScene, transition: close)
        }
    }
    
    @objc func buttonTap3(){
        let infoScene = TutorialScene4(size: (self.view?.bounds.size)!)
        infoScene.scaleMode = .aspectFill
        let open = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(infoScene, transition: open)
        }
    }
}
