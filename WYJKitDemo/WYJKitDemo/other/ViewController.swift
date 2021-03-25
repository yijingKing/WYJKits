//
//  ViewController.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/2/20.
//  Copyright © 2021 祎. All rights reserved.
//

import UIKit
import Foundation


var RSA_PrivateKey:String = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMLgqFw6BLWl8icHGYJN3imP5WOuKvTsrkk3kAOztuumhGDM+I2dkyxeg9kPBe5s9uU76A+dWZalBd2fu+YGol00YHN8cHlOCEUpxpkfrKkaqeIAQLB9TiLG0ElByI/0AYi2+bavn0mZUQWq/VklY5a+CdOSxJvyiQH/gBf81GMHAgMBAAECgYEAl6FYPpKCMZiSZx2WEpZmA27MbJgLIpG6Nov+CXNfI9Jn9C3oQ8BU0FQmQND4q4CrRsgrE2M6XwW+H6h2+k81KvQ/14FlXi713RE1L+SO6/ciaqPLm6rEJrlPKF5IlOk/OQL8fyP3yUj2Qb5LAWCY2FB+fzS05hVq7CpUyR6NtpkCQQD8HS3rwNam1uNdG+LFJHH6Ug9oimQT3oUY689qupy8J/ZnrJE6Rp6DGtz7fd9jWhBS98ASTH8IK1E91ay3ADGjAkEAxeGg0WNnfgVt33i60B0HhMHSguBqnLGzXqH0H0qzH/kB3/GPdvK9bVsuGYSRXtMyJAymlypZf7Roe6hseI4HTQJAeJ2VLKcTirpgCFmhAmRPS00bJg6flons72FR2GPzPGl6D1uWF2VVzK97ba5ow2WBTdBNyfNjCwt+ULD7conbNQJAHLek5h5d+50AGAlmWyOLXsneKh41eq4TUO2CBzSJEF/L1NsyrdmGgiNUamGh0zglM7QeTRvZRz5AV4nWzBwYlQJBAIykTzvPaISpSZUT5WVb5TDleUN79a9BAjxHaD+EvOaIoqLDI1L+bDkbqpKcqETcFycb5uLjnJ3Hu9iVmQR7Ki0="
var RSA_PublicKey:String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC4KhcOgS1pfInBxmCTd4pj+Vjrir07K5JN5ADs7brpoRgzPiNnZMsXoPZDwXubPblO+gPnVmWpQXdn7vmBqJdNGBzfHB5TghFKcaZH6ypGqniAECwfU4ixtBJQciP9AGItvm2r59JmVEFqv1ZJWOWvgnTksSb8okB/4AX/NRjBwIDAQAB"

class ViewController: WYJBaseViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
//        let d =  0.123
//        WYJLog(d.yi.localized(.percent))
        
//        calculateDifference(startTime: "431025200206054026".yi.index(6, 14), endTime: Date().yi.toString(format: "yyyyMMdd"))
        let s = "431025200206054026"
        let d: String = s.yi.RSAEncrypted(publicKeyBase64: RSA_PublicKey) ?? ""
        let dd = RSA.encryptString(s, publicKey: RSA_PublicKey) ?? ""
        let ss = dd.yi.RSADecrypted(privateBase64: RSA_PrivateKey)
        let sss = d.yi.RSADecrypted(privateBase64: RSA_PrivateKey)
        WYJLog(ss)
        WYJLog(sss)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let d =  0.123
        WYJLog(d.yi.localized(.currencyPlural))
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
