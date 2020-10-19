//
//  InfoScene.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 10/15/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import AVFoundation

class InfoScene: SKScene {
    
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
        flyingAcesLogo.size = CGSize(width: 350, height: 200)
        flyingAcesLogo.zPosition = 3
        flyingAcesLogo.position = CGPoint(x: size.width/2, y: 575)
        self.addChild(flyingAcesLogo)
        createButton()
        createBackground()
        createHowToPlayLabel()
    
    }
    
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "InfoBackgroundImage")
        background.zPosition = -1
        background.size = UIScreen.main.bounds.size
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(background)
    }
    
    func createHowToPlayLabel(){
        gamePlayLabel = SKLabelNode(text: "Invasion! Fleets of enemy planes are looking to invade our country! Tap and drag the plane to move it and tap it again to fire your weapon! Make sure you don't let any planes pass you or you'll lose lives! If you get hit by a plane then you lose a life too. Good Luck!")
        gamePlayLabel.fontSize = 24
        gamePlayLabel.fontColor = SKColor.red
        gamePlayLabel.fontName = "Copperplate"
        gamePlayLabel.zPosition = 5
        gamePlayLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 120)
        gamePlayLabel.lineBreakMode = .byWordWrapping
        gamePlayLabel.numberOfLines = 0
        gamePlayLabel.preferredMaxLayoutWidth = 350
        self.addChild(gamePlayLabel)
    }
    

        func createButton(){
            //Button
            let buttonTexture = SKTexture(imageNamed: "button")
            let buttonSelected = SKTexture(imageNamed: "button2")
            
            let button = ButtonNode(normalTexture: buttonTexture, selectedTexture: buttonSelected, disabledTexture: buttonTexture)
            button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(MenuScene.buttonTap))
            button.setButtonLabel(title: "Back", font: "Copperplate", fontSize: 20)
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
            button.size = CGSize(width: 300, height: 100)
            button.zPosition = 4
            self.addChild(button)
            
        }
        
        @objc func buttonTap(){
            let gameScene = MenuScene(size: (self.view?.bounds.size)!)

            gameScene.scaleMode = .aspectFill
            let crossFade = SKTransition.crossFade(withDuration: 0.75)
            if let spriteview = self.view{
                spriteview.presentScene(gameScene, transition: crossFade)
            }
        }
}

