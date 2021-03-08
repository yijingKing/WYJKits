//
//  ViewController.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/2/20.
//  Copyright © 2021 祎. All rights reserved.
//

import UIKit

class ViewController: WYJBaseViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let v = MainInstructions()
        view.addSubview(v)
        v.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}
class MainInstructions: UIView {
    lazy var scrollView: UIScrollView = {
        return UIScrollView().yi.then({
            $0.backgroundColor = .white
            $0.contentSize = .init(width: WYJScreenWidth - WYJRatio(44), height: 2 * WYJScreenWidth)
        })
    }()
    
    lazy var label: UILabel = {
        return UILabel().yi.then({
            $0.backgroundColor = .gray
            $0.numberOfLines = 0
            $0.font = WYJFont(20)
            $0.text = "产品说明/1、设备服务费：298元/台，首笔需支付298元的设备服务费方可激活使用本产品 2、流量卡费：36元/年，激活后第31天的首笔交易扣36元的流量卡费，激活后的396天的首笔交易扣第二年的36元流量卡费用以此类推 3、交易到账时间：DO交易：00:00-22:40、23:05-23:59，到账时间：实时到账小额双免、扫码消费：09:00-22:00，到账时间：实时到账4、交易限额:信用卡：最低10元/笔，最高5万元/笔，单卡单日限5笔储蓄卡：最低10元/笔，最高5000元/笔，单卡单日限2笔云闪付扫码：单笔限额5000元，单日限10笔支付宝扫码：单笔限额1000元，单日限3笔单日刷卡限额50万元，当月刷卡限额300万元。5、认证规则:为了您的资金安全，磁条卡首次大额交易（5000元以上）需进行持卡人四要素（持卡人姓名、身份证号、银行卡号、银行预留手机号码）认证，否则无法完成交易。认证通过后单笔最高5万元。6、声明：使用本产品服务需要真实的交易背景，用户需要自行承担各类交易税费。严禁用户利用本公司产品做违法行为，否则后果自负。"
        })
    }()
    @objc func injected() {
        
    }
    lazy var determineButton: UIButton = {
        return UIButton().yi.then({
            $0.backgroundColor = .blue
            $0.yi.title("确认")
        })
    }()
    lazy var button: UIButton = {
        return UIButton().yi.then({
            $0.backgroundColor = .blue
            $0.yi.title("下次不再提示")
        })
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(scrollView)
        scrollView.snp.makeConstraints({
            $0.left.equalTo(WYJRatio(22))
            $0.right.equalTo(WYJRatio(-22))
            $0.height.equalTo(WYJScreenWidth)
            $0.center.equalToSuperview()
        })
        
        scrollView.addSubview(label)
        
        scrollView.addSubview(determineButton)
        scrollView.addSubview(button)
        
        label.snp.makeConstraints({
            $0.top.left.equalTo(WYJRatio(12))
            
            $0.width.equalTo(WYJScreenWidth - WYJRatio(68))
        })
        
        determineButton.snp.makeConstraints({
            $0.width.equalTo(WYJRatio(240))
            $0.height.equalTo(WYJRatio(40))
            $0.centerX.equalTo(label.snp.centerX)
            $0.top.equalTo(label.snp.bottom).offset(WYJRatio(22))
        })
        button.snp.makeConstraints({
            $0.top.equalTo(determineButton.snp.bottom).offset(WYJRatio(12))
            $0.bottom.equalTo(-WYJRatio(22))
            $0.left.equalTo(WYJRatio(WYJRatio(22)))
        })
        determineButton.yi.cornerRadii(WYJRatio(20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
