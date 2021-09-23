//
//  SnakeHead.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 23.09.2021.
//

import UIKit
import SpriteKit

class SnakeHead: SnakeBodyPart {
    override init(atPoint point: CGPoint) {
        super.init(atPoint: point)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
