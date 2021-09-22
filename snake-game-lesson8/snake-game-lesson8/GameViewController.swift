//
//  GameViewController.swift
//  snake-game-lesson8
//
//  Created by Денис Сизов on 22.09.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // тут мы размер экрана передали
        let scene = GameScene(size: view.bounds.size)
        
        let skView = view! as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        scene.scaleMode = .resizeFill
        
        // размещаем сцена на вью и отображаем
        skView.presentScene(scene)
    }

}
