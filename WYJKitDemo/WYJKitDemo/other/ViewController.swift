//
//  ViewController.swift
//  YJSwiftKit
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 祎. All rights reserved.
//

import UIKit
//import PKHUD
//import WYJKits

//import CaamDauValue
struct Presonewe: WYJCodable {
    
    var name: WYJStrInt?
    var ss: WYJStrDble?
}
struct HomeAPI {
    static let login = "http://192.168.16.98:8011/jjf-api/login"
    static let img = "http://192.168.16.98:8011/jjf-api/api/common/uploadHeadImage"
}

class WYJRequest: WYJAlamofire {

    override func configureRequestParameters() {
        timeOut = 30
        
    }
    
}

class ViewController: WYJBaseViewController {
    var tableView: WYJBaseTableView!
    var lab: UILabel?
    
    var model : Presonewe?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightGray
//        var ss = "123133wqer"
//        let aa = ss.deleteLast()
        
//        WYJLog("\(ss) + \(aa)")
        
        
        let str = "{\"ss\":\"0.003880\",\"name\":null}"
        model = try? Presonewe.init(from: str.yi.toDictionary())
        
        WYJLog(model?.name?.string ?? "123")
        WYJLog(model?.ss?.string ?? "0.0000000")
        WYJLog(model?.ss?.double ?? 0.0000000)
        
        WYJLog("1234567890".yi.index(after: 3))
        ceshi3()
        
    }
    func ceshi3() {
        let brn = UIButton.init().yi.then({
            $0.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            $0.frame = view.bounds
            view.addSubview($0)
        })
        brn.yi.clickAction {

            #imageLiteral(resourceName: "矩形 490").yi.savedPhotosAlbum { (b) in
                
            }
            
            let img = UIImage.init(gradient: CGSize.init(width: 10, height: 10), direction: .leftBottom, colors: [.red,.blue])
            let image = UIImageView.init(image: img)
            image.frame = self.view.bounds
            
            self.view.addSubview(image)
            
//            "https://beifuqi.sandpay.com.cn/jjf-api/login"
            var para = [String: Any]()
            para["username"] = "18250808695"
            para["password"] = "123456"
            para["rememberMe"] = "false"
            WYJRequest().post(HomeAPI.login, para) { (model: MyInfo_Data) in

                WYJLog(model.id)
                WYJHUD.show(model.id) {
                    self.yi.push(MyViewController())
                }
                
            } error: { (err) in
                WYJLog(err)
            }

//            WYJHUD.shared.locationStatus = .top
//            WYJHUD.show("这下吧发是这下吧发是这下吧发是这下吧发是") {
//                WYJLog("12333333333333333333")
//                push(MyViewController())
//            }
//            WYJSystem.invokeCameraPhoto(nil)
            
//            WYJAlert.show {
//                WYJHUD.show("这下吧发是这下吧发是这下吧发是这下吧发是") {
//                    WYJLog("12333333333333333333")
//                    push(MyViewController())
//                }
//            }
            
            
//            WYJHUD.showProgress()
//            let cam = WYJCameraController()
//            push(cam)
//            present(cam.yi.then({
////                $0.titleText = "213hndnsajif"
//                $0.modalPresentationStyle = .fullScreen
////                $0.photoType = .reverse
//            }))
//            cam.cameraDidFinishShoot = {
//                brn.backgroundImage = $0
//            }
            
        }
    }
    func ceshi2() {
//        let page = WYJPageView().yi.then({
//            $0.lineColor = .red
//            $0.lineSpacing = 9
//            $0.lineWidth = 20
//            $0.backgroundColor = .blue
//            view.addSubview($0)
//            $0.viewControllers = [MyViewController(),MyViewController(),MyViewController(),MyViewController(),MyViewController(),MyViewController()]
//        })
//        page.snp.makeConstraints({
//            $0.top.equalTo(WYJStatusHeight)
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalTo(-WYJBottomHeight)
//        })
//        page.createPage(["都是","无去的啊","无去的","㡒豆捞坊什么","㡒经济法可什么","为福克斯的从自行车"]) { (str, i) in
//            WYJLog("\(str)" + "\(i)")
//        }
    }
    func ceshi1() {
        
        tableView = WYJBaseTableView(frame: view.bounds)
        tableView.empty_title = "123"
        tableView.backgroundColor = .blue
        tableView.isScrollEnabled = true
        view.addSubview(tableView)
        tableView.dataCount = 18
        tableView.yi.cellForRowAtIndexPath { (tab, index) -> UITableViewCell in
            return UITableViewCell()
        }.numberOfRowsInSection { (tab, int) -> (Int) in
            return self.tableView.page * self.tableView.pageNumber
        }
        
        tableView.yi.didSelectRowAtIndexPath { (tab, indexPath) in
            WYJLog(indexPath)
        }
        
        tableView.refreshFooter {
            DispatchQueue.main.yi.after(1) {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func ceshi() {
//        la.frame = .init(x: 0, y: 0, width: 200, height: 200)
//        la.center = view.center
//        la.text = "创建来到测试世界"
//        view.addSubview(la)
//
//        la.setGradientLayer(direction: .leftBottom, colors: [.blue,.red])
//        la.configRectCorner(radii: .init(width: 30, height: 30))
//        la.layer.masksToBounds = true
//        let img = UIImageView().init {
//            view.addSubview($0)
//            $0.backgroundColor = .blue
//            $0.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
//        }
        
        
//        img.image = UIImage.initGradient(size: .init(width: 100, height: 100), direction: .leftTop, colors: [.blue,.red])
//        img.addBorderTop(size: 10, color: .blue)
        view.backgroundColor = .blue
//        let string = "adcfb425723432".xor("213871248dbcaf")
//        yPrintLog(string.hexToString())
//        WYJLog("text=text".toURLEncode("="))
        let lab = WYJCountDownButton().yi.then {
            $0.frame = .init(x: 100, y: 100, width: 100, height: 100)
            $0.yi.title("获取验证码")
            $0.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        }
        view.addSubview(lab)
        
        _ = CGSize.init(width: 1, height: 1) + CGSize.init(width: 1, height: 1)
    }
    
    @objc func click (_ btn: WYJCountDownButton) {
//        WYJAlert.show(message: "打", titleArr: ["123","qwe"], highlighted: 1, handler: { (alert,action,i) in
//            if i == 0 {
//                action.setValue(WYJ99Color, forKey: "titleTextColor")
//            }
//            alert.titleColor = .cyan
//            alert.titleFont = WYJFont_23
//            alert.messageColor = .green
//            alert.messageFont = WYJFont_22
//            action.titleColor = .red
//            WYJLog(action.get_class_copyPropertyList())
//            WYJLog(action.get_class_copyMethodList())
//            action.image = UIImage.init(named: "矩形 490")
//            
//        }) { (i, s) -> (Void) in
//            
//        }
//        WYJLog(["12","34","56","78"][[0,3,7]])
    }
}


struct MyInfo_Data: WYJCodable {
    var activateTime: WYJStrInt?
    var creator: String?
    var recStatus: String?
    var isTwiceMonthReach: String?
    var creditCardNo: String?
    var isVipFirst: WYJStrInt?
    var id: String?
    var vipOpenTime: WYJStrInt?
    var password: String?
    var nextMonthReachTime: WYJStrInt?
    var merchantCode: String?
    var unbindTime: WYJStrInt?
    var twiceMonthReachTime: WYJStrInt?
    var realName: String?
    var isNextMonthReach: String?
    var salt: String?
    var mobilePhone: String?
    var modifyTime: WYJStrInt?
    var merchantStatus: String?
    var isVip: Bool?
    var reachTime: WYJStrInt?
    var bindTime: WYJStrInt
    var identityNo: String?
    var debitCardNo: String?
    var modifier: String?
    var merchantName: String?
    var merchantType : String?
    var avatar: String?
    var createTime: WYJStrInt?
    var authStatus: String?
    var version  : String?
    var sumScore : String?
    
}


func dealWithRequestByParams(params:[String:Any]) -> [String:Any]  {
    if params.count == 0 {
        return [:]
    }
    var bodyStr:String = ""
    for key in params.keys {
        bodyStr += String.init(format: "%@=%@&", key,params[key] as! CVarArg)
    }
    
    let encWithPubKey = RSA.encryptString(bodyStr, publicKey: RSA_PublicKey)
    var para:[String:Any] = [:]
    para["data"] = encWithPubKey
    para["encrypted"] = "Y"
    para["pos"] = "bpos"
    return para
}

var RSA_PrivateKey:String = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIgz14Bw7f1RjJOvcwOJQ/B+zB2GeJPBVwaGzwZSGroGQ9HNkTs1BnUnd3zF7PaUr7bXI+a+HXc4DG+b2UW2nIY1QtbtHWlpyhgrtuwpBPL1g9j9Ltk2zcSixyWLcs9bKgj5C0NuTlpnLyg4nMYKTXmSl3lk4NMzP+4wXSVaz9/nAgMBAAECgYBXdhLYY6wvkwJWg7+zcZ2y/XlNLGCZYPnlMwQV5vtKoWNDgmHUR0SSTnmoIeD8ppX/Lz/amBKLz+4MbWOkJJN1me2bvOvM5SLgSpOjbIPTlZHzOgR2qUyVJnbUxGVweAmMJUTQDSfYQHvnRYdgCLgsjpF4Nk3YDz0Fyj1bQubAwQJBAM+Mc9WkVHqzgxWruJZd5OjkcE38fRVK40nWxYiv1WEKt/WQUiJk1Reih+pUNJm1jl6CuBCqmLJNL4F4n0ALGmkCQQCn/5fBdg2zmN+CfkG1gD6I+cYxi/J+ZGa+KVE4sWED6n1tXlgWpkH7NnFV9NTKf/4LViS6TC+rVBeS0YLd5r3PAkAe/PB6kHuQimbjAG2h/cjkwN7HthAS8sh2yNtbai1ovMn0nyS0P+vVCI5UfVgRLxtfnxLOYjpEPOP/57uXO1EpAkBLZSXSKQ0VIPKOOeN7dUabap1L9yapGp4RkbFl5BVKEJ6hysl1wL+z4kcS8IHfL3nv1IU/JpnuJhs+RNCajcd5AkEAjwnuP5xJVHB4GIE297Ku7b/0bxF69EnytTacnSO4OjmitsUd4UDaSn1A6vfb9TnIWWozeCTrGAHf2FenciopyQ=="
var RSA_PublicKey:String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCIM9eAcO39UYyTr3MDiUPwfswdhniTwVcGhs8GUhq6BkPRzZE7NQZ1J3d8xez2lK+21yPmvh13OAxvm9lFtpyGNULW7R1pacoYK7bsKQTy9YPY/S7ZNs3Eoscli3LPWyoI+QtDbk5aZy8oOJzGCk15kpd5ZODTMz/uMF0lWs/f5wIDAQAB"
