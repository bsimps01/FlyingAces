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
    
    var score: Int = 0
    var scoreLabel:SKLabelNode!
    var newGameButtonNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        scoreLabel.text = "\(score)"
        
        newGameButtonNode = (self.childNode(withName: "newGameButton") as! SKSpriteNode)
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let node = self.nodes(at: location)
            
            if node[0].name == "newGameButton" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene, transition: transition)
            }
        }
    }
}
