//
//  GameScene.swift
//  Breakout
//
//  Created by Sakina Ali on 6/21/17.
//  Copyright © 2017 Sakina Ali. All rights reserved.
// this is a test uhggg

import SpriteKit
import GameplayKit
                          //Add to use contact physics
class GameScene: SKScene, SKPhysicsContactDelegate, Alertable
{
    var ball : SKSpriteNode!
    var paddle : SKSpriteNode!
    var loseZone : SKSpriteNode!
    var bricksArray:[SKSpriteNode?] = []
    var numOfBrick = 0
    var ballCount = 3
    var scoreLabel : SKLabelNode!
    var titleScore : SKLabelNode!
    var ball1 : SKTexture!
    var ball2 : SKTexture!
    var ball3 : SKTexture!
    var score = 0
    var alertLabel :  SKLabelNode!
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  //Makes edge of view part of physics
        createScoreLabel()
        createBackground()
        showLives()
        makeBall()
        generatePaddle()
        constructLoseZone()
        levelOne()
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if ball.physicsBody?.isDynamic == false
        {
            //this will start ball movement
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
        }
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        print("contact func")
        for i in bricksArray
        {
            if (contact.bodyA.node! == ball) && (contact.bodyB.node! ==  i) || (contact.bodyA.node! == i) && (contact.bodyB.node! == ball)
            {
                print("Brick Hit")
                i!.removeFromParent()
                numOfBrick -= 1
                if i?.color == UIColor.red
                {
                    print("red")
                    score += 10
                    scoreLabel.text = "\(score)"
                }
                else if i?.color == UIColor.green
                {                    print("green")

                    score += 20
                    scoreLabel.text = "\(score)"
                }
                else if i?.color == UIColor.blue
                {
                    print("blue")

                    score += 50
                    scoreLabel.text = "\(score)"
                }
            }
            print(numOfBrick)
            if numOfBrick == 0
            {
                ball.physicsBody?.isDynamic == false
                alertLabelPop(text: "Congrats, you won!!")
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.alertLabel.zPosition = -2
                    self.levelTwo()
                }
                
                
            }
            
        }
        print("lost ball and my will to live")
        if (contact.bodyA.node! == ball) && (contact.bodyB.node! == loseZone) || (contact.bodyA.node! == loseZone) && (contact.bodyB.node! == ball)
        {
            print("loseZone hit")
            if ballCount > 1
            {
                
                ballCount -= 1
                alertLabelPop(text: "You lost a life")
                let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                   self.alertLabel.zPosition = -2
                }
                ball.physicsBody?.isDynamic == false
                print(ballCount)
                
            }
            else if ballCount == 0
            {
                ball.physicsBody?.isDynamic == false
                print("total failure")
                alertLabelPop(text: "You lost, try again")
                let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    // Your code with delay
                    self.alertLabel.zPosition = -2
                }
                removeAllChildren()
                DispatchQueue.main.asyncAfter(deadline: when)
                {
                    self.restartGame()
                }
                
            }
        }
    }
    
    func levelOne()
    {
        concieveBrick()
        concieveBrickTwo()
        concieveBrickThree()
    }
    
    func levelTwo()
    {
        concieveBrickLevelOne()
        concieveBrickLevelTwo()
        concieveBrickLevelThree()
    }
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "Deep Blue Space iPhone 5 Wallpaper")
        for i in 0...1                          //Creates 2 stars for seamless transtition
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1      //Set stacking order, makes sure the stars are behind everything
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration:20)   //Animations begin
            let reset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, reset])
            let loop = SKAction.repeatForever(moveLoop)
            starsBackground.run(loop)
        }
    }
    
    func makeBall()
    {
        let ballDiameter = frame.width / 20
        
        ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "Ball"
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        //Applies physics body to ball
        
        ball.physicsBody?.isDynamic = false //Ignores all forces and impulses
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball)
    }
    
    func generatePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width / 4, height: frame.height / 50))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        paddle.name = "Paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
    }
   
    func concieveBrick()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 130
            
        for i in 0...4
        {
            print("part 1")
                
                
            var i = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
            i.name = "i"
            i.physicsBody = SKPhysicsBody(rectangleOf: i.size)
            i.physicsBody?.isDynamic = false
            i.position = CGPoint(x: xPos, y: yPos)
            xPos += frame.maxX - 200 + ((frame.width / 6) + 5)
            bricksArray.append(i)
            addChild(i)
            print("pls")
            numOfBrick += 1
            print("whymbnmb")
         }
    }
    
    func concieveBrickTwo()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 80
            
        for i in 5...9
        {
            print("part 1")
                
            var i = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
            i.name = "i"
            i.physicsBody = SKPhysicsBody(rectangleOf: i.size)
            i.physicsBody?.isDynamic = false
            i.position = CGPoint(x: xPos, y: yPos)
            xPos += frame.maxX - 200 + ((frame.width / 6) + 5)
            bricksArray.append(i)
            addChild(i)
            print("pls")
            numOfBrick += 1
            print("whymbnmb")
        }
    }
        
    func concieveBrickThree()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 30
            
        for i in 10...14
        {
            print("part 1")
                
            var i = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
                //  bricksArray:[0] = "Brick1"
            i.physicsBody = SKPhysicsBody(rectangleOf: i.size)
            i.physicsBody?.isDynamic = false
            i.position = CGPoint(x: xPos, y: yPos)
            xPos += frame.maxX - 200 + ((frame.width / 6) + 5)
            bricksArray.append(i)
            addChild(i)
            print("pls")
            numOfBrick += 1
            print("whymbnmb")
        }
    }
    
    func createScoreLabel ()
    {
    scoreLabel = SKLabelNode(text: "hellow world")
    scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY)
    addChild(scoreLabel)
    }
    
    func showLives ()
    {
        ball1 = SKTexture(image: #imageLiteral(resourceName: "blackBall"))
        ball2 = SKTexture(image: #imageLiteral(resourceName: "blackBall"))
        ball3 = SKTexture(image: #imageLiteral(resourceName: "blackBall"))
        var life1 = SKSpriteNode(texture: ball1, color: UIColor.white, size: CGSize(width: 25, height: 25))
        var life2 = SKSpriteNode(texture: ball2, color: UIColor.white, size: CGSize(width: 25, height: 25))
        var life3 = SKSpriteNode(texture: ball3, color: UIColor.white, size: CGSize(width: 25, height: 25))
        life1.name = "life1"
        life2.name = "life2"
        life3.name = "life3"
        life1.position = CGPoint(x: frame.maxX + 70, y: frame.minY - 10)
        life1.position = CGPoint(x: frame.maxX + 80, y: frame.minY - 10)
        life1.position = CGPoint(x: frame.maxX + 60, y: frame.minY - 10)
        
        addChild(life1)
        addChild(life2)
        addChild(life3)
    
        
    }
    
    func constructLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        loseZone.name = "Lose Zone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
    }
    
    func alertLabelPop(text: String)
    {
        alertLabel = SKLabelNode(fontNamed: "Hiragino Mincho ProN W3")
        alertLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        alertLabel.zPosition = 100
        alertLabel.fontSize = 50.0
        alertLabel.fontColor = UIColor.white
        alertLabel.text = "\(text)"
        addChild(alertLabel)
    }
    
    func concieveBrickLevelOne()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 200
        
        for i in 0...4
        {
            print("part 1")
            
            
            var i = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
            i.name = "i"
            i.physicsBody = SKPhysicsBody(rectangleOf: i.size)
            i.physicsBody?.isDynamic = false
            i.position = CGPoint(x: xPos, y: yPos)
            xPos += frame.maxX - 200 + ((frame.width / 6) + 5)
            bricksArray.append(i)
            addChild(i)
            print("pls")
            numOfBrick += 1
            print("whymbnmb")
        }
    }
    
    func concieveBrickLevelTwo()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 150
        
        for i in 5...9
        {
            print("part 1")
            
            var i = SKSpriteNode(color: UIColor.green, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
            i.name = "i"
            i.physicsBody = SKPhysicsBody(rectangleOf: i.size)
            i.physicsBody?.isDynamic = false
            i.position = CGPoint(x: xPos, y: yPos)
            xPos += frame.maxX - 200 + ((frame.width / 6) + 5)
            bricksArray.append(i)
            addChild(i)
            print("pls")
            numOfBrick += 1
            print("whymbnmb")
        }
    }
    
    func concieveBrickLevelThree()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 50
        
        for i in 10...14
        {
            print("part 1")
            
            var i = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
            //  bricksArray:[0] = "Brick1"
            i.physicsBody = SKPhysicsBody(rectangleOf: i.size)
            i.physicsBody?.isDynamic = false
            i.position = CGPoint(x: xPos, y: yPos)
            xPos += frame.maxX - 200 + ((frame.width / 6) + 5)
            bricksArray.append(i)
            addChild(i)
            print("pls")
            numOfBrick += 1
            print("whymbnmb")
        }
    }
func restartGame()
{
    physicsWorld.contactDelegate = self
    createBackground()
    generatePaddle()
    makeBall()
    constructLoseZone()
    concieveBrick()
    concieveBrickTwo()
    concieveBrickThree()
}

}
