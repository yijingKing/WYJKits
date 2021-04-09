//
//  MyViewController.swift
//  WYJKitsDemo
//
//  Created by 祎 on 2020/8/28.
//  Copyright © 2020 祎. All rights reserved.
//

import UIKit

class MyViewController: WYJBaseViewController,Protocal1 {
    var name: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barStyle = .lightContent
        WYJLog(getName())
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        WYJHUD.loading("oooolplpl")
    }
}
