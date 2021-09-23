//
//  Apple.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 22.09.2021.
//

import UIKit
import SpriteKit

class Apple: SKShapeNode { // SKShapeNode это чтобы мы могли создавать объекты этого класса и различать их на сцене
    
    init(position: CGPoint) {
        super.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath // создали объект яблока, 10 на 10
        fillColor = .red
        strokeColor = .red
        lineWidth = 5
        
        self.position = position
        
        // задаём яблоку физическое тело и делаем так, чтобы контакт был чуть раньше, чем у нас это отрисовывается
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0, center: CGPoint(x: 5, y: 5))
        self.physicsBody?.categoryBitMask = CollisionCategory.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
