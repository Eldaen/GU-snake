//
//  GameScene.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 22.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    // Всегда запускается первым, тут нужно сначала создавать объекты, а потом где-то ещё
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // задали какую-то гравитацию
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false // запрещаем поворот экрана
        
        view.showsPhysics = true
        
        
        // кнопки управления змейкой
        
        //1
        let counterClockwiseButton = SKShapeNode()
        
        // задаём форму круга, .cgPatch как-то подтверждает создание
        counterClockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30)
        
        counterClockwiseButton.fillColor = .magenta
        counterClockwiseButton.strokeColor = .magenta // рамка
        counterClockwiseButton.lineWidth = 10 // размер рамки
        counterClockwiseButton.name = "counterClockwiseButton" // кнопке нужно имя, для проверок
        
        self.addChild(counterClockwiseButton) // отправили кнопку на сцену
        
        
        //2
        let clockwiseButton = SKShapeNode()
        
        clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        clockwiseButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30)
        
        clockwiseButton.fillColor = .magenta
        clockwiseButton.strokeColor = .magenta // рамка
        clockwiseButton.lineWidth = 10 // размер рамки
        clockwiseButton.name = "clockwiseButton" // кнопке нужно имя, для проверок
        
        self.addChild(clockwiseButton) // отправили кнопку на сцену
        
        
        
        
    }
    
    // произошло нажатие
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self) // проверяем, куда было нажатие
            
            // Проверяем факт нажатия по кнопкам, а не куда-то ещё
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockwiseButton" || touchNode.name == "clockwiseButton" else {
                return
            }
            
            // красим кнопку в красный по нажатию
            touchNode.fillColor = .red
        }
        
    }
    
    // убрал палец с экрана
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self) // проверяем, куда было нажатие
            
            // Проверяем факт нажатия по кнопкам, а не куда-то ещё
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockwiseButton" || touchNode.name == "clockwiseButton" else {
                return
            }
            
            // красим кнопку в красный по нажатию
            touchNode.fillColor = .magenta // Кнопку отпустили? Красим обратно
        }
        
    }
    
    // внезапное прекращение нажатие, например звонок на телефон или ещё что-то такое
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // обновление кадров, запускается каждый раз перед отрисовкой след. кадра
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
