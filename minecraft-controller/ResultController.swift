//
//  ResultController.swift
//  minecraft-controller
//
//  Created by 赤星宏樹 on 2023/09/14.
//

import UIKit

class ResultController: UIViewController {

    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scoreTime = UserDefaults.standard.integer(forKey: "scoreTime")
        
        result.text = String(scoreTime)

        // Do any additional setup after loading the view.
    }


}
