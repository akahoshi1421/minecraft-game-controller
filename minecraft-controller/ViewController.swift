//
//  ViewController.swift
//  minecraft-controller
//
//  Created by 赤星宏樹 on 2023/09/14.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var webSocketTask: URLSessionWebSocketTask!
    var socketName = UserDefaults.standard
    
    var rollForward: Double = 0.0
    var roll: Double = 0.0
    
    var directionForward: String = "center"
    var direction: String = "center"
    
    var myMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let urlSession = URLSession(configuration: .default)
        let url = URL.init(string: "ws://localhost:9999")!
        
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
        
        myMotionManager.deviceMotionUpdateInterval = 0.3
        myMotionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion, error) in
            guard let motion = motion, error == nil else { return }
            
            // ピッチ角を代入
            self.roll = round(motion.attitude.pitch * 180 / Double.pi)
            
            // どこにエージェントを置くかを指定
            if(self.roll < 75.0){
                self.direction = "right"
            } else if(self.roll < 105.0){
                self.direction = "center"
            } else{
                self.direction = "left"
            }
            
            
            if(self.direction != self.directionForward){
                //サーバに送るメッセージを作成
                let msg = URLSessionWebSocketTask.Message.string("{\"direction\": \"\(self.direction)\"}")
                
                //送信
                self.webSocketTask.send(msg){error in
                    if let error = error {
                        print(error)
                    }
                }
            }
            
            // ピッチ角を代入
            self.rollForward = round(motion.attitude.pitch * 180 / Double.pi)
            
            // どこにエージェントを置くかを指定
            if(self.rollForward < 75.0){
                self.direction = "right"
            } else if(self.rollForward < 105.0){
                self.direction = "center"
            } else{
                self.direction = "left"
            }
            
        })
        
        
    }


}

