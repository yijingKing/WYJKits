//
//  ViewController.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/2/20.
//  Copyright © 2021 祎. All rights reserved.
//

import UIKit
import Foundation

public protocol Protocal1 {
    var name: String? { get set }
}
extension Protocal1 {
    func wqewe1() {
        WYJLog(name)
    }
    func getName()->String? {
        return name
    }
}

class Model:WYJCodable {
    var id: Decimal?
}

class ViewController: WYJBaseViewController,Protocal1  {
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        name = "123"
        wqewe1()
        
        let textf = UITextField().yi.then({
            $0.keyboardType = .default
            $0.placeholder = "1233333333333333333333"
        })
        view.addSubview(textf)
        textf.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.height.equalTo(50)
            $0.top.equalTo(577)
        })
        
        let dec = Decimal.init(0.042330000)
        let model = try? Model(from: ["id": dec])
        
        WYJLog(model?.id)
        WYJLog(model?.toDictionary())
        WYJLog((0.51500 / 100).yi.decimal(2))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = MyViewController()
        vc.name = name
        yi.push(vc)
    }
}
