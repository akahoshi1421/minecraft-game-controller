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
    
    @IBOutlet weak var agent: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let urlSession = URLSession(configuration: .default)
        let url = URL.init(string: "ws://localhost:9999")!
        
        
        let screenHight = UIScreen.main.bounds.size.width
        let split = (screenHight / 3) / 2
        
        let leftPosition = split
        let centerPosition = split * 3
        let rightPosition = split * 5
        
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
        
        myMotionManager.deviceMotionUpdateInterval = 0.3
        myMotionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion, error) in
            guard let motion = motion, error == nil else { return }
            
            // ピッチ角を代入
            self.roll = round(motion.attitude.pitch * 180 / Double.pi)
            
            // どこにエージェントを置くかを指定
            if(self.roll > 10.0){
                self.direction = "left"
                self.agent.center.x = leftPosition
                
            } else if(self.roll > -10.0){
                self.direction = "center"
                self.agent.center.x = centerPosition
                
            } else{
                self.direction = "right"
                self.agent.center.x = rightPosition
                
            }
            
            
            if(self.direction != self.directionForward){
                print(self.direction)
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
            if(self.rollForward > 10.0){
                self.direction = "left"
            } else if(self.rollForward > -10.0){
                self.direction = "center"
            } else{
                self.direction = "right"
            }
            
        })
        
        
    }
    
    
    // 受信処理
    func receiveMessage() {
      webSocketTask.receive { [weak self] result in
        switch result {
          case .success(let message):
            switch message {
              case .string(let text):
                print("Received! text: \(text)")
              case .data(let data):
                print("Received! binary: \(data)")
              @unknown default:
                fatalError()
            }
            self?.receiveMessage()  // <- 継続して受信するために再帰的に呼び出す
          case .failure(let error):
            print("Failed! error: \(error)")
        }
      }
    }



}

