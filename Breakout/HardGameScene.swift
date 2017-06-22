//
//  HardGameScene.swift
//  Breakout
//
//  Created by Devanshi Chakrabarti on 6/22/17.
//  Copyright © 2017 Sakina Ali. All rights reserved.
//

import UIKit
import SpriteKit

class HardGameScene: SKScene, SKPhysicsContactDelegate
{
    var ball : SKSpriteNode!
    var paddle : SKSpriteNode!
    var loseZone : SKSpriteNode!
    var bricksArray:[SKSpriteNode?] = []
    var numOfBrick = 0
    var ballCount = 3
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  //Makes edge of view part of physics
        createBackground()
        makeBall()
        generatePaddle()
        concieveBrick()
        concieveBrickTwo()
        concieveBrickThree()
        
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
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width / 5, height: frame.height / 25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "Paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
    }
    
    func concieveBrickThree()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 30
        
        for i in 0...14
        {
            print("part 1")
            
            var i = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
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
        
        for i in 0...14
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
    
    func concieveBrick()
    {
        var xPos = frame.minX + 45
        var yPos = frame.maxY - 130
        
        for i in 0...14
        {
            print("part 1")
            
            var i = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width / 6, height: frame.height / 24.5))
            i.name = "Brick"
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
    
    func constructLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "Lose Zone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
    }
}
