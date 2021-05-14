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
    var textf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        name = "123"
        wqewe1()
        
        textf = UITextField().yi.then({
            $0.keyboardType = .default
            $0.placeholder = "1233333333333333333333"
        })
        
        view.addSubview(textf)
        textf.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.height.equalTo(50)
            $0.top.equalTo(566)
        })
        
        let dec = Decimal.init(0.042330000)
        let model = try? Model(from: ["id": dec])
        
        WYJLog(model?.id)
        WYJLog(model?.toDictionary())
        WYJLog((0.51500 / 100).yi.toDecimal())
        let _: Double = 0.04
        WYJLog("".prefix(4))
        
        WYJLog(HOX().newByteArray(from: "4A6E144E48A24009654150E1E0125D19"))
        textf.isSecureTextEntry = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textf.isSecureTextEntry = !textf.isSecureTextEntry
    }
}
