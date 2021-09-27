//
//  GameScene.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 22.09.2021.
//

import SpriteKit
import GameplayKit

// создаём числа для битовой маски, чтобы можно было определять, к какой группе объект относится и с чем он может столкнуться
struct CollisionCategory {
    static let Snake: UInt32 = 0x1 << 0     // 0001 // 1
    static let SnakeHead: UInt32 = 0x1 << 1 // 0010 // 2
    static let Apple: UInt32 = 0x1 << 2     // 0100 // 4
    static let EdgeBody: UInt32 = 0x1 << 3  // 1000 // 8
}

class GameScene: SKScene {
    
    var snake: Snake?
    var gameOver: Bool = false // пока не true - ира идёт
    
    var scoreLabel: SKLabelNode!
    var playAgainLabel: SKLabelNode!
    var playAgainRect: SKShapeNode!
    var gameOverScreen: SKShapeNode!
    var gameOverLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
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
        
        // делаем нашу сцену площадкой, на которой могут происходить взаимодействия (столкновения)
        self.physicsWorld.contactDelegate = self
        
        // задаём, с чем может сцена столкнуться
        self.physicsBody?.categoryBitMask = CollisionCategory.EdgeBody
        self.physicsBody?.contactTestBitMask = CollisionCategory.Snake | CollisionCategory.SnakeHead
        
        // Делаем scoreboard
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 28
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: size.width/2, y: 45)
        addChild(scoreLabel)
        

        
        startThegame()
        
    }
    
    // произошло нажатие
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self) // проверяем, куда было нажатие
            
            // Проверяем факт нажатия по кнопкам, а не куда-то ещё
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode , touchNode.name == "counterClockwiseButton" || touchNode.name == "clockwiseButton" || touchNode.name == "playagain" else {
                return
            }
            
            // красим кнопку в красный по нажатию
            touchNode.fillColor = .red
            
            if touchNode.name == "clockwiseButton" {
                snake!.moveClockwise()
            } else if touchNode.name == "counterClockwiseButton" {
                snake!.moveCounterClockwise()
            } else if touchNode.name == "playagain" {
                hideGameOver()
                startThegame()
            }
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
        if !gameOver {
            snake!.move()
        } else {
            showGameOver()
            //self.view?.isPaused = true
        }
        
    }
    
    // Создаём яблоко в рандомной точке на сцене, не за пределами экрана
    func createApple() {
        let randomX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)))
        var randomY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)))
        
        // чтобы не попадалось под кнопки
        while randomY < 100 {
            randomY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)))
        }
        
        let apple = Apple(position: CGPoint(x: randomX, y: randomY))
        
        self.addChild(apple)
    }
    
    // Если игра завершилась, то показываем game over экран
    func showGameOver() {
        
        gameOverScreen = SKShapeNode()
        gameOverScreen.path = UIBezierPath(rect: CGRect(x: CGFloat(view!.scene!.frame.size.width * 0.1), y: CGFloat(view!.scene!.frame.size.height * 0.1), width: CGFloat(view!.scene!.frame.size.width * 0.8), height: CGFloat(view!.scene!.frame.size.height * 0.8))).cgPath
        
        gameOverScreen.name = "gameoverscreen"
        gameOverScreen.fillColor = .white
        gameOverScreen.strokeColor = .gray
        gameOverScreen.lineWidth = 2
        
        self.addChild(gameOverScreen)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = String("Game Over!")
        gameOverLabel.fontColor = .red
        gameOverLabel.fontSize = 30
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 10)
        self.addChild(gameOverLabel)
        
        // Play again?
        playAgainRect = SKShapeNode()
        playAgainRect.path = UIBezierPath(rect: CGRect(x: CGFloat(view!.scene!.frame.size.width * 0.3), y: CGFloat(view!.scene!.frame.size.height * 0.2), width: CGFloat(view!.scene!.frame.size.width * 0.4), height: CGFloat(view!.scene!.frame.size.height * 0.1))).cgPath
        playAgainRect.name = "playagain"
        playAgainRect.fillColor = .green
        playAgainRect.strokeColor = .gray
        playAgainRect.lineWidth = 2
        self.addChild(playAgainRect)
        
        playAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
        playAgainLabel.text = "Play again!"
        playAgainLabel.fontSize = 28
        playAgainLabel.horizontalAlignmentMode = .center
        playAgainLabel.fontColor = .white
        playAgainLabel.position = CGPoint(x: CGFloat(view!.scene!.frame.size.width * 0.5), y: CGFloat(view!.scene!.frame.size.height * 0.23))
        playAgainRect.addChild(playAgainLabel)
        
    }
    
    func hideGameOver() {
        
        playAgainLabel?.removeFromParent()
        playAgainRect?.removeFromParent()
        gameOverScreen?.removeFromParent()
        gameOverLabel?.removeFromParent()
    }
    
    func StopTheGame() {
        gameOver = true
        
        showGameOver()
        stopTheSnake()
        
        self.isPaused = true // Ставлю на паузу, чтобы не плодило Ноды. Дальше игра не пойдёт, увы.
    }
    
    func stopTheSnake() {
        snake?.removeFromParent()
    }
    
    func startThegame() {
        
        self.view?.isPaused = false
        
        if gameOver == true {
            hideGameOver()
        }
        
        snake = Snake(atPoint: CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY))
        self.addChild(snake!)
        
        createApple()
    }
}

// делаем расширение с протоколом SKPhysicsContactDelegate чтобы отслеживать столкновения
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask // складываем битмаски при столкновенни, например 0100 + 0010 = 8 + 4 = 12
        
        let collisionObject = bodies - CollisionCategory.SnakeHead // вычитаем SnakeHead т.к. это единственный объект, который может столкнуться с чем-то
        
        // обрабатываем варианты столкновений, в зависимости от того, с чем столкнулась голова
        switch collisionObject {
        case CollisionCategory.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node // определяем, какой из двух столкнувшихся тел - яблоко и записываем в apple
            
            // Удлинняем змею, удаляем яблоко со сцены, создаём новое
            snake?.addBodyPart()
            score += 1
            apple?.removeFromParent()
            createApple()
        
        case CollisionCategory.EdgeBody:
            StopTheGame()
            
        default:
            break
        }
    }
}
