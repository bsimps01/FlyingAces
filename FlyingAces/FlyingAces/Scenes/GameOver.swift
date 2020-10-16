//
//  GameOver.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 3/22/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class GameOver: SKScene {
    
    enum ButtonNodeState {
        case ButtonNodeStateActive, ButtonNodeStateSelected, ButtonNodeStateHidden
    }
    var buttonEnabled = true
    var score: Int = 0
    var scoreLabel:SKLabelNode!
    var gameOverLabel:SKLabelNode!
    var newGameButtonNode:SKSpriteNode!
    var selectedHandler: () -> Void = { print("button not set") }
    var state: ButtonNodeState = .ButtonNodeStateActive {
        didSet {
            if buttonEnabled{
                switch state {
                case .ButtonNodeStateActive:
                    //Enables Touch
                    self.isUserInteractionEnabled = true
                    //Confirms if it's visible
                    self.alpha = 1
                    break
                case .ButtonNodeStateSelected:
                    //Changes the transparency
                    self.alpha = 0.7
                    break
                case .ButtonNodeStateHidden:
                    //Disables the touch
                    self.isUserInteractionEnabled = false
                    //Hides the button
                    self.alpha = 0
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.isUserInteractionEnabled = true
    }
    override func sceneDidLoad() {
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        score = 0
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 1
        scoreLabel.position = CGPoint(x: 100, y: 275)
        gameOverLabel = (self.childNode(withName: "gameOverLabel") as! SKLabelNode)
        gameOverLabel.text = "Game Over"
        gameOverLabel.zPosition = 1
        gameOverLabel.position = CGPoint(x: 175, y: 500)
        newGameButtonNode = (self.childNode(withName: "newGameButton") as! SKSpriteNode)
        
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton")
        
        newGameButtonNode.zPosition = 1
        newGameButtonNode.position = CGPoint(x: 250, y: 300)
        newGameButtonNode.size = CGSize(width: 100, height: 50)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if buttonEnabled {
            state = .ButtonNodeStateSelected
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if buttonEnabled {
            selectedHandler()
            state = .ButtonNodeStateActive
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameStart = SKScene(fileNamed: "GameScene") as! GameScene
            self.view?.presentScene(gameStart, transition: transition)
        }

    }
}
