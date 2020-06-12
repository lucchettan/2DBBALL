import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball: SKSpriteNode!
    var onePoint: SKSpriteNode!
    var originalBallPosition: CGPoint!
    var hasGone = false
    var shogun: SKSpriteNode!
    var pointsLabel: SKLabelNode!
    var score: Int = 0
    var timerLabel: SKLabelNode!
    var timer: Int = 10
    var faceSwap: SKSpriteNode!
    var faceKiko: SKSpriteNode!
    var faceRomi: SKSpriteNode!
    var faceFlo: SKSpriteNode!
    var faceMax: SKSpriteNode!
    var gameTimer: Timer?
    var scoreSound = SKAction.playSoundFileNamed("scoreSound.mp3", waitForCompletion: false)

//    two declaration of category to identify the contact between two different object
    let onePointCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1


    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        onePoint = childNode(withName: "onePoint") as? SKSpriteNode
        ball = childNode(withName: "ball") as? SKSpriteNode
        shogun = childNode(withName: "shogun") as? SKSpriteNode
        pointsLabel = childNode(withName: "pointsLabel") as? SKLabelNode
        faceSwap = childNode(withName: "faceSwap") as? SKSpriteNode
        faceKiko = childNode(withName: "faceKiko") as? SKSpriteNode
        faceRomi = childNode(withName: "faceRomi") as? SKSpriteNode
        faceMax = childNode(withName: "faceMax") as? SKSpriteNode
        faceFlo = childNode(withName: "faceFlo") as? SKSpriteNode
        timerLabel = childNode(withName: "timerLabel") as? SKLabelNode
        timerLabel.text! = String(timer)

        
        originalBallPosition = ball.position
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        ball.physicsBody?.categoryBitMask = ballCategory
        onePoint.physicsBody?.categoryBitMask = onePointCategory
        ball.physicsBody?.contactTestBitMask = onePointCategory
        perform(#selector(shogunJump), with: nil, afterDelay: 1.0)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }


//    to lunch action as we touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first{
//                //* allows us to access to all the nodes
                enumerateChildNodes(withName: "//*", using: {(node, stop) in
                    if node.name == "faceKiko" {
                        if node.contains(touch.location(in: self)) {
                            self.faceSwap.texture = self.faceKiko.texture
                        }
                    }
                    else if node.name == "faceRomi" {
                        if node.contains(touch.location(in: self)) {
                            self.faceSwap.texture = self.faceRomi.texture
                        }
                    }
                    else if node.name == "faceFlo" {
                        if node.contains(touch.location(in: self)) {
                            self.faceSwap.texture = self.faceFlo.texture
                        }
                    }
                    else if node.name == "faceMax" {
                        if node.contains(touch.location(in: self)) {
                            self.faceSwap.texture = self.faceMax.texture
                        }
                    }
                })
                
                
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                ball.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)

                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                ball.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !hasGone {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchedWhere = nodes(at: touchLocation)
                
                if !touchedWhere.isEmpty {
                    for node in touchedWhere {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                let dx = -(touchLocation.x - originalBallPosition.x)
                                let dy = -(touchLocation.y - originalBallPosition.y)
                                let impulse = CGVector(dx: dx, dy: dy)
                                print(impulse, "impulse")
                                ball.physicsBody?.affectedByGravity = true
                                ball.physicsBody?.applyImpulse(impulse)
                                ball.physicsBody?.applyAngularImpulse(0.03)
                                perform(#selector(callback), with: nil, afterDelay: 2.5)
                                }
                            }
                        }
                    }
                }
            }
        }
    
    override func update(_ currentTime: TimeInterval) {
                if hasGone {
                ball.physicsBody?.affectedByGravity = false
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ball.physicsBody?.angularVelocity = 0
                ball.zRotation = 0
                ball.position = originalBallPosition
                hasGone = false
            }
    }
    
    @objc func callback() {
        hasGone = true
    }
    @objc func countdown() {
        if timer > 0 {
            timer -= 1
            timerLabel.text! = String(timer)
        } else {
            let sceneGameOVer = GameSceneGameOver(fileNamed: "GameSceneGameOver")
                sceneGameOVer?.scaleMode = .aspectFill
                self.view?.presentScene(sceneGameOVer!, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
    
    @objc func shogunJump() {
        if shogun.position.y >= -11 {
            shogun.position.y -= 45
        } else { shogun.position.y += 45 }
        perform(#selector(shogunJump), with: nil, afterDelay: 1.0)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let onePoint: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if onePoint == ballCategory | onePointCategory {
            run(scoreSound)
            score += 1
            if score == 2 {
                let sceneSaveNapoli = GameSceneSaveNapoli(fileNamed: "GameSceneSaveNapoli")
                sceneSaveNapoli?.scaleMode = .aspectFill
                self.view?.presentScene(sceneSaveNapoli!, transition: SKTransition.fade(withDuration: 0.5))
                
            }
            pointsLabel.text! = String(score)
            hasGone = true
        }
    }
}
