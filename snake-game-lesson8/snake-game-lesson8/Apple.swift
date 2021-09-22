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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
