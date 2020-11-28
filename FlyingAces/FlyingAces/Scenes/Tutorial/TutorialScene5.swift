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
        
        let flyingAcesLogo = SKSpriteNode(imageNamed: "FlyingAcesLogo")
        flyingAcesLogo.size = CGSize(width: 100, height: 100)
        flyingAcesLogo.zPosition = 3
        flyingAcesLogo.position = CGPoint(x: size.width/2, y: size.height - 50)
        self.addChild(flyingAcesLogo)
        createBackground()
        createHowToPlayLabel()
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
        gamePlayLabel = SKLabelNode(text: "Good Hunting!")
        gamePlayLabel.fontSize = 76
        gamePlayLabel.fontColor = SKColor.systemBlue
        gamePlayLabel.fontName = "Copperplate-Bold"
        gamePlayLabel.zPosition = 5
        gamePlayLabel.verticalAlignmentMode = .center
        gamePlayLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gamePlayLabel.lineBreakMode = .byWordWrapping
        gamePlayLabel.numberOfLines = 0
        gamePlayLabel.preferredMaxLayoutWidth = 360
        self.addChild(gamePlayLabel)
    }
    
    func createButtons(){
        let buttonTexture = SKTexture(imageNamed: "button")
        let buttonSelected = SKTexture(imageNamed: "button2")
        
        let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene5.buttonTap))
        button.setButtonLabel(title: "Main Menu", font: "Copperplate", fontSize: 22)
        button.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY - 290)
        button.size = CGSize(width: 150, height: 50)
        button.zPosition = 4
        self.addChild(button)
        
        let button2 = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
        button2.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(TutorialScene5.buttonTap2))
        button2.setButtonLabel(title: "Let's Play!", font: "Copperplate", fontSize: 22)
        button2.position = CGPoint(x: self.frame.midX + 100, y: self.frame.midY - 290)
        button2.size = CGSize(width: 150, height: 50)
        button2.zPosition = 4
        self.addChild(button2)
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
        
        infoScene.scaleMode = .aspectFill
        let close = SKTransition.doorsOpenHorizontal(withDuration: 0.75)
        if let spriteview = self.view{
            spriteview.presentScene(infoScene, transition: close)
        }
    }
}
