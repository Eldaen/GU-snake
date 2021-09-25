//
//  Snake.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 23.09.2021.
//

import UIKit
import SpriteKit

class Snake: SKShapeNode {
    
    var body = [SnakeBodyPart]()
    var moveSpeed: CGFloat = 125.0
    var angle: CGFloat = 0.0
    
    init(atPoint point: CGPoint) {
        super.init()
        
        let head = SnakeHead(atPoint: point)
        body.append(head) // сначала голова, потом уже все части тела
        addChild(head) // кажется, это добавляет на экран.
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBodyPart() {
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x, y: body[0].position.y))
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    func move() {
        guard !body.isEmpty else { // проверяем что змея не пуста
            return
        }
        
        let head = body[0]
        moveHead(head)
        
        // двигаем тело змеи
        for index in (0..<body.count) where index > 0 {
            let previousBodyPart = body[index - 1]
            let currentBodyPart = body[index]
            
            moveBodyPart(p: previousBodyPart, c: currentBodyPart)
        }
    }
    
    func moveHead(_ head: SnakeBodyPart) {
        let dx = moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0) // вот это отвечает за движение змейки, раз в duration, в милисекундах
        head.run(moveAction) // запускаем движение
    }
    
    // этот метод двигает части тела одно за другим, т.е. мы принимаем в параметры 2 SnakeBodyPart и делаем moveAction для позиции первого и отправляем в этот путь второй.
    func moveBodyPart(p: SnakeBodyPart, c: SnakeBodyPart) {
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x, y: p.position.y), duration: 0.1)
        c.run(moveAction)
    }
    
    // метод управления поворотом по часовой стрелке
    func moveClockwise() {
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveCounterClockwise() {
        angle -= CGFloat(Double.pi / 2)
    }

}
