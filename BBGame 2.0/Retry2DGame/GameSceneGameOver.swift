//
//  SceneGameOver.swift
//  Retry2DGame
//
//  Created by Massimo Di Guida on 21/10/2019.
//  Copyright © 2019 Nicolas Lucchetta. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation


class GameSceneGameOver : SKScene {
    var music : AVAudioPlayer!
    var retryBtn: SKSpriteNode!
    var gameOver = SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false)

    override func didMove(to view: SKView) {
        retryBtn = childNode(withName: "retryBtn") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first{
                enumerateChildNodes(withName: "//*", using: {(node, stop) in
                    if node.name == "retryBtn" {
                        if node.contains(touch.location(in: self)) {
                            let sceneGame = GameSceneSaveNapoli(fileNamed: "GameScene")
                            sceneGame?.scaleMode = .aspectFill
                            self.view?.presentScene(sceneGame!, transition: SKTransition.fade(withDuration: 0.5))
                    }
                }
            })
        }
    }
}
