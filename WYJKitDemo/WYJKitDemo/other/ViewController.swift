//
//  ViewController.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/2/20.
//  Copyright © 2021 祎. All rights reserved.
//

import UIKit
import Foundation




class ViewController: WYJBaseViewController  {
    var name: String? {
        willSet {
            WYJLog("-->" + (newValue ?? ""))
        }
        didSet {
            WYJLog("------->" + (oldValue ?? " "))
        }
        
    }
    var textf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ListAPI(param: ListAPI.Param.init()).request { _ in
            
        } failure: { _ in
            
        }


        
//
//        NetworkingManager .request(APIManager.register(parameters:"1")) { (obj: ResponseObject)  in
//
//        } failure: { _ in
//
//        }

    }
}

