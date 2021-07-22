//
//  ViewController.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/2/20.
//  Copyright © 2021 祎. All rights reserved.
//

import UIKit
import Foundation
import SSKeychain

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

        view.backgroundColor = .red
        name = "123"
        
        wqewe1()
        
        
//        SSKeychain.setPassword(<#T##password: String!##String!#>, forService: <#T##String!#>, account: <#T##String!#>)
//
        WYJLog(WYJFont(10.auto()))
        
        UILabel().yi.font(10.auto())
        
        WYJAuto.set {(value) -> Double in
            let base = 1000
            let screenWidth = Double(UIScreen.main.bounds.width)
            let screenHeight = Double(UIScreen.main.bounds.height)
            let width = min(screenWidth, screenHeight)
            return value * (width / base)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = AnnouncementViewController()
        vc.modalPresentationStyle = .custom
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
}


class AnnouncementViewController: WYJBaseViewController {
    lazy var titleLabel: UILabel = {
        return UILabel().yi.then({
            $0.backgroundColor = .blue
            $0.textAlignment = .center
            $0.font = WYJBoldFont(22)
            $0.textColor = .white
            $0.text = "通知公告"
        })
    }()
    lazy var textView: UITextView = {
        return UITextView().yi.then({
            $0.attributedText = NSAttributedString.init(string: "通知公告通知公告通知公告通知公告通知公告通知公告通知公告通知公告通知公告")
        })
    }()
    lazy var noTipButton: UIButton = {
        return UIButton().yi.then({
            $0.yi.title("总不提示")
            $0.yi.color(.white)
        })
    }()
    lazy var shutDownButton: UIButton = {
        return UIButton().yi.then({
            $0.yi.title("X")
            $0.yi.color(.white)
            $0.yi.font(WYJFont(33))
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.yi.cornerRadii(WYJRatio(12))
        view.addSubview(bgView)
        bgView.snp.makeConstraints({
            $0.left.equalTo(WYJRatio(22))
            $0.right.equalTo(WYJRatio(-22))
            $0.height.equalTo(WYJScreenWidth)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-WYJRatio(32))
        })
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(WYJRatio(66))
        })
        bgView.addSubview(textView)
        textView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(WYJRatio(12))
            $0.left.equalTo(WYJRatio(12))
            $0.right.bottom.equalTo(-WYJRatio(12))
        })
        view.addSubview(noTipButton)
        noTipButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bgView.snp.bottom).offset(WYJRatio(4))
            $0.width.equalTo(WYJRatio(200))
            $0.height.equalTo(WYJRatio(40))
        })
        view.addSubview(shutDownButton)
        shutDownButton.snp.makeConstraints({
            $0.width.height.equalTo(WYJRatio(35))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noTipButton.snp.bottom).offset(WYJRatio(12))
        })
        shutDownButton.yi.cornerRadii(WYJRatio(27.5))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}






