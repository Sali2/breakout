//
//  EasyViewController.swift
//  Breakout
//
//  Created by Devanshi Chakrabarti on 6/22/17.
//  Copyright © 2017 Sakina Ali. All rights reserved.
//

import UIKit
import SpriteKit

class EasyViewController: UIViewController, SKPhysicsContactDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

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


}
