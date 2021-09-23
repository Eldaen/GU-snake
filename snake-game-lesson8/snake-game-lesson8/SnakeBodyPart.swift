//
//  SnakeBodyPart.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 22.09.2021.
//

import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    
    let diameter: CGFloat = 10.0
    
    init (atPoint point: CGPoint) {
        super.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter)).cgPath
        fillColor = .green
        strokeColor = .green
        lineWidth = 5
        
        self.position = point
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: diameter, center: CGPoint(x: 5, y: 5))
        self.physicsBody?.isDynamic = true // движется
        self.physicsBody?.categoryBitMask = CollisionCategory.Snake
        self.physicsBody?.contactTestBitMask = CollisionCategory.EdgeBody | CollisionCategory.Apple // это мы тут используем битовое ИЛИ, сравниваем биты одного числа и другого
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
