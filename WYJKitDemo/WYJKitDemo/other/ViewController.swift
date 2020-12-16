//
//  ViewController.swift
//  YJSwiftKit
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 祎. All rights reserved.
//

import UIKit
//import PKHUD
//import QYKit

//import CaamDauValue
struct Presonewe: QYCodable {
    
    var name: QYStrInt?
    var ss: QYStrDble?
//    init(from decoder: Decoder) throws {
//        name = try TStrInt.init(from: decoder)
//    }
}
struct HomeAPI {
    static let login = "http://192.168.16.98:8011/jjf-api/login"
    static let img = "http://192.168.16.98:8011/jjf-api/api/common/uploadHeadImage"
}

class QYRequest: QYAlamofire {

    override func yi_configureRequestParameters() {
        timeOut = 30
    }
    
}

//Created  on 2018/12/11  by LCD :https://github.com/liucaide .

import Foundation
import UIKit

public protocol CaamDauViewProtocol {
    /// T: UIView、UIGestureRecognizer、NSLayoutConstraint、[NSLayoutConstraint]、、
    func addT<T>(_ t: T?)
    
    func appendView<T:UIView>(_ type:T.Type, _ handler:((T)->Void)?)
}

extension CaamDauViewProtocol {
    public func addT<T>(_ t: T?){
        guard let vv = self as? UIView else { return }
        switch t {
        case let subview as UIView where vv is UIStackView:
            (vv as? UIStackView)?.addArrangedSubview(subview)
        case let subview as UIView :
            vv.addSubview(subview)
        case let ges as UIGestureRecognizer :
            vv.addGestureRecognizer(ges)
        case let lay as NSLayoutConstraint :
            vv.addConstraint(lay)
        case let lays as [NSLayoutConstraint] :
            vv.addConstraints(lays)
        default:
            break
        }
        
    }
    
    public func appendView<T>(_ type: T.Type, _ handler: ((T) -> Void)? = nil) where T : UIView {
        switch self {
        case let stack as UIStackView:
            let v = T()
            handler?(v)
            stack.addArrangedSubview(v)
        case let vv as UIView:
            let v = T()
            handler?(v)
            vv.addSubview(v)
        default:
            break
        }
    }
    
}

public struct CaamDau<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    public var build: Base {
        return base
    }
}

public protocol CaamDauCompatible {
    associatedtype CompatibleType
    var cd: CompatibleType { get }
}
extension CaamDauCompatible {
    public var cd: CaamDau<Self> {
        return CaamDau(self)
    }
}

extension NSObject: CaamDauCompatible {}
extension UIView : CaamDauViewProtocol {}


public extension CaamDau where Base: UIView {
    @discardableResult
    func add<T>(_ t: T?) -> CaamDau {
        base.addT(t)
        return self
    }
    
    @discardableResult
    func append<T:UIView>(_ type:T.Type, _ handler:((T)->Void)?) -> CaamDau {
        base.appendView(type, handler)
        return self
    }
}


extension UIView {
    /*
    public func appendView<T>(_ type: T.Type, _ handler: ((T) -> Void)?) where T : UIView {
        self.cd.append(type, handler)
    }*/
    /*
    public func addT<T>(_ t: T?) {
        switch t {
        case let subview as UIView :
            self.addSubview(subview)
        case let ges as UIGestureRecognizer :
            self.addGestureRecognizer(ges)
        case let lay as NSLayoutConstraint :
            self.addConstraint(lay)
        case let lays as [NSLayoutConstraint] :
            self.addConstraints(lays)
        default:
            break
        }
    }*/
}


public extension CaamDau where Base: UIView {
    @discardableResult
    func frame(_ a: CGRect) -> CaamDau {
        base.frame = a
        return self
    }
    @discardableResult
    func frame(x: CGFloat = 0, y: CGFloat = 0, w: CGFloat = 0, h: CGFloat = 0) -> CaamDau {
        base.frame = CGRect(x: x, y: y, width: w, height: h)
        return self
    }
    @discardableResult
    func bounds(_ a: CGRect) -> CaamDau {
        base.bounds = a
        return self
    }
    @discardableResult
    func bounds(w: CGFloat = 0, h: CGFloat = 0) -> CaamDau {
        base.bounds = CGRect(x: 0, y: 0, width: w, height: h)
        return self
    }
    
    @discardableResult
    func center(_ a: CGPoint) -> CaamDau {
        base.center = a
        return self
    }
    
    @discardableResult
    func center(x: CGFloat = 0, y: CGFloat = 0) -> CaamDau {
        base.center = CGPoint(x: x, y: y)
        return self
    }
    @discardableResult
    func tag(_ a: Int) -> CaamDau {
        base.tag = a
        return self
    }
    @discardableResult
    func background(_ color: UIColor?) -> CaamDau {
        base.backgroundColor = color
        return self
    }
    
    @discardableResult
    func alpha(_ a: CGFloat) -> CaamDau {
        base.alpha = a
        return self
    }
    
    @discardableResult
    func content(_ mode: UIView.ContentMode) -> CaamDau {
        base.contentMode = mode
        return self
    }
    
    @discardableResult
    func isHidden(_ a: Bool) -> CaamDau {
        base.isHidden = a
        return self
    }
    
    @discardableResult
    func isOpaque(_ a: Bool) -> CaamDau {
        base.isOpaque = a
        return self
    }
    
    @discardableResult
    func isUser(_ interactionEnabled: Bool) -> CaamDau {
        base.isUserInteractionEnabled = interactionEnabled
        return self
    }
    
    @discardableResult
    func tint(_ color: UIColor) -> CaamDau {
        base.tintColor = color
        return self
    }
    
    @discardableResult
    func corner(_ radius: CGFloat) -> CaamDau {
        base.layer.cornerRadius = radius
        return self
    }
    
    @discardableResult
    func clips(_ toBounds: Bool) -> CaamDau {
        base.clipsToBounds = toBounds
        return self
    }
    
    @discardableResult
    func corner(_ radius:CGFloat, clips: Bool = true) -> CaamDau {
        base.layer.cornerRadius = radius
        base.clipsToBounds = clips
        return self
    }
    
    @discardableResult
    func masks(_ toBounds: Bool) -> CaamDau {
        base.layer.masksToBounds = toBounds
        return self
    }
    
    @discardableResult
    func border(_ width: CGFloat) -> CaamDau {
        base.layer.borderWidth = width
        return self
    }
    
    @discardableResult
    func border(_ color: UIColor) -> CaamDau {
        base.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func border(_ width:CGFloat, color: UIColor) -> CaamDau {
        base.layer.borderWidth = width
        base.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func shadow(_ path: CGPath) -> CaamDau {
        base.layer.shadowPath = path
        return self
    }
    
    @discardableResult
    func shadow(_ color: UIColor) -> CaamDau {
        base.layer.shadowColor = color.cgColor
        return self
    }
    
    @discardableResult
    func shadow(_ opacity: Float) -> CaamDau {
        base.layer.shadowOpacity = opacity
        return self
    }
    
    @discardableResult
    func shadow(_ offset: CGSize) -> CaamDau {
        base.layer.shadowOffset = offset
        return self
    }
    
    @discardableResult
    func shadow( w:CGFloat = 0, h:CGFloat = 0) -> CaamDau {
        base.layer.shadowOffset = CGSize(width: w, height: h)
        return self
    }
    
    @discardableResult
    func shadow(_ radius: CGFloat) -> CaamDau {
        base.layer.shadowRadius = radius
        return self
    }
    
    @discardableResult
    func shadow(_ path: CGPath?) -> CaamDau {
        base.layer.shadowPath = path
        return self
    }
    /// 阴影
    @discardableResult
    func shadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) -> CaamDau {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowOpacity = opacity
        base.layer.shadowRadius = radius
        return self
    }
    /// 变形属性(平移\缩放\旋转)
    @discardableResult
    func transform(_ a: CGAffineTransform) -> CaamDau {
        base.transform = a
        return self
    }
    /// 自动调整子视图尺寸，默认YES则会根据autoresizingMask属性自动调整子视图尺寸
    @discardableResult
    func autoresizes(_ subviews: Bool) -> CaamDau {
        base.autoresizesSubviews = subviews
        return self
    }
    /// 自动调整子视图与父视图的位置，默认UIViewAutoresizingNone
    @discardableResult
    func autoresizing(_ mask: UIView.AutoresizingMask) -> CaamDau {
        base.autoresizingMask = mask
        return self
    }
    
    /// 圆角
    @discardableResult
    func rounded(_ corners:UIRectCorner, _ radii:CGSize) -> CaamDau {
        return self.rounded(base.bounds, corners, radii)
    }
    
    /// 圆角
    @discardableResult
    func rounded(_ rect:CGRect, _ corners:UIRectCorner, _ radii:CGSize) -> CaamDau {
        let rounded = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        base.layer.mask = shape
        return self
    }
    
    /// 背景线性渐变 默认横向渐变 point -> 0 - 1
    /// let gradients:[(UIColor,Float)] = [(UIColor.red,0),(UIColor.yellow,1)]
    /// view.cd.gradient(layer: gradients)
    /// 文字渐变 view.gradient(layerAxial: ..., then:{ layer in layer.mask = label.layer })
    @discardableResult
    func gradient(layerAxial gradients:[(color:UIColor,location:Float)], point:(start:CGPoint, end:CGPoint) = (start:CGPoint(x: 0, y: 0), end:CGPoint(x: 1, y: 0)), at: UInt32 = 0, updateIndex:Int? = nil, then:((CAGradientLayer)->Void)? = nil) -> CaamDau {
        
        func gradient(_ layer:CAGradientLayer) {
            base.layoutIfNeeded()
            layer.colors = gradients.map{$0.color.cgColor}
            layer.locations = gradients.map{NSNumber(value:$0.location)}
            layer.startPoint = point.start
            layer.endPoint = point.end
            layer.frame = base.bounds
        }
        
        let layers:[CAGradientLayer] = base.layer.sublayers?.filter{$0.isKind(of: CAGradientLayer.self)}.map{$0} as? [CAGradientLayer] ?? []
        if layers.count <= at {
            let layer = CAGradientLayer()
            gradient(layer)
            base.layer.insertSublayer(layer, at: at)
            then?(layer)
        }else{
            let layer = layers[updateIndex ?? 0]
            gradient(layers[updateIndex ?? 0])
            then?(layer)
        }
        return self
    }
    /// 放射性渐变
    class GradientLayer:CALayer {
        open var point: CGPoint = CGPoint.zero
        open var colorSpace = CGColorSpaceCreateDeviceRGB()
        open var locations:[CGFloat] = [0.0, 1.0]
        open var colors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]
        open lazy var radius: CGFloat = {
            return Swift.max(self.bounds.size.width, self.bounds.size.height)
        }()
        override open func draw(in ctx: CGContext) {
            guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: locations.count) else {
                return
            }
            ctx.drawRadialGradient(gradient, startCenter: point, startRadius: 0, endCenter: point, endRadius: radius, options: .drawsAfterEndLocation)
        }
    }
    
    
    ///
    @discardableResult
    func then(_ block:(Base) -> Void) -> CaamDau {
        block(base)
        return self
    }
    
    @discardableResult
    func insert(_ subview:UIView, at index:Int = 0) -> CaamDau {
        base.insertSubview(subview, at: index)
        return self
    }
    
    @discardableResult
    func insert(_ subview:UIView, below view:UIView) -> CaamDau {
        base.insertSubview(subview, belowSubview: view)
        return self
    }
    @discardableResult
    func insert(_ subview:UIView, above view:UIView) -> CaamDau {
        base.insertSubview(subview, aboveSubview: view)
        return self
    }
    
    @discardableResult
    func exchange(_ subview1:Int, _ subview2:Int) -> CaamDau {
        base.exchangeSubview(at: subview1, withSubviewAt: subview2)
        return self
    }
    
    @discardableResult
    func bring(subviewToFront view:UIView) -> CaamDau {
        base.bringSubviewToFront(view)
        return self
    }
    
    @discardableResult
    func send(subviewToBack view:UIView) -> CaamDau {
        base.sendSubviewToBack(view)
        return self
    }
    
    @discardableResult
    func add(toSuperview view:UIView) -> CaamDau {
        view.addSubview(base)
        return self
    }
    
    @discardableResult
    func insert(toSuperview view:UIView, at index:Int) -> CaamDau {
        view.insertSubview(base, at: index)
        return self
    }
    
    @discardableResult
    func insert(toSuperview superview:UIView, below view:UIView) -> CaamDau {
        superview.insertSubview(base, belowSubview: view)
        return self
    }
    @discardableResult
    func insert(toSuperview superview:UIView, above view:UIView) -> CaamDau {
        superview.insertSubview(base, aboveSubview: view)
        return self
    }
    
    @discardableResult
    func exchange(_ view:UIView) -> CaamDau {
        guard let idx1 = base.superview?.subviews.firstIndex(of: base),
            let idx2 = base.superview?.subviews.firstIndex(of: view) else {
            return self
        }
        base.superview?.exchangeSubview(at: idx1, withSubviewAt: idx2)
        return self
    }
    
    @discardableResult
    func bringToFront() -> CaamDau {
        base.superview?.bringSubviewToFront(base)
        return self
    }
    
    @discardableResult
    func sendToBack() -> CaamDau {
        base.superview?.sendSubviewToBack(base)
        return self
    }
    
    @discardableResult
    func add(toSuperstack stack:UIStackView) -> CaamDau {
        stack.addArrangedSubview(base)
        return self
    }
    @discardableResult
    func insert(toSuperstack stack:UIStackView, at index:Int) -> CaamDau {
        stack.insertArrangedSubview(base, at: index)
        return self
    }
    
    @discardableResult
    func removeFromSuperview() -> CaamDau {
        base.removeFromSuperview()
        return self
    }
    
    @discardableResult
    func remove(subview view:UIView) -> CaamDau {
        base.subviews
            .filter{ $0 == view }
            .forEach{ $0.removeFromSuperview() }
        return self
    }
    
    @discardableResult
    func remove(subviews views:[UIView]) -> CaamDau {
        base.subviews
            .filter{ views.contains($0)}
            .forEach{ $0.removeFromSuperview() }
        return self
    }
}

//MARK:--- 返回非 self 将中断链式 ----------
public extension CaamDau where Base: UIView{
    func vc() -> UIViewController? {
        var next:UIResponder? = base
        repeat {
            next = next?.next
            if let vc = next as? UIViewController {
                return vc
            }
        }while next != nil
        return nil
    }
    
    /// 截图
    var cutImage:UIImage? {
        base.layoutIfNeeded()
        UIGraphicsBeginImageContextWithOptions(base.frame.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        base.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}


public extension CaamDau where Base: UIScrollView {
    /// 截长图
    var cutImageLong:UIImage? {
        base.layoutIfNeeded()
        let savedContentOffset = base.contentOffset
        let savedFrame = base.frame
        base.contentOffset = .zero
        base.frame = CGRect(x: 0, y: 0, width: base.contentSize.width, height: base.contentSize.height)
        guard let image = base.cd.cutImage else {
            base.contentOffset = savedContentOffset
            base.frame = savedFrame
            return nil
        }
        base.contentOffset = savedContentOffset
        base.frame = savedFrame
        return image
    }
}


class ViewController: QYBaseViewController {
    var tableView: QYBaseTableView!
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
//        let aa = ss.yi_deleteLast()
        
//        QYLog("\(ss) + \(aa)")
        
        let str = "{\"ss\":\"0.003880\",\"name\":null}"
        model = try? Presonewe.yi_init(str.yi_toDictionary())
        
//        QYLog(model?.name?.string ?? "123")
//        QYLog(model?.ss?.string ?? "0.0000000")
//        QYLog(model?.ss?.double ?? 0.0000000)
        
        QYLog("1234567890".yi_index(after: 3))
        
        ceshi3()
    }
    func ceshi3() {
        let brn = UIButton.init().yi_then({
            $0.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            $0.frame = view.bounds
            view.addSubview($0)
        })
        
        brn.yi_clickAction = {
//            "https://beifuqi.sandpay.com.cn/jjf-api/login"
            var para = [String: Any]()
            para["username"] = "18250808695"
            para["password"] = "123456"
            para["rememberMe"] = "false"
            QYRequest().post(HomeAPI.login, para) { (model: MyInfo_Data) in

                QYLog(model.id)
                QYHUD.yi_show(model.id) {
                    self.yi_push(MyViewController())
                }
                
            } error: { (err) in
                QYLog(err)
            }

//            QYHUD.shared.locationStatus = .top
//            QYHUD.yi_show("这下吧发是这下吧发是这下吧发是这下吧发是") {
//                QYLog("12333333333333333333")
//                yi_push(MyViewController())
//            }
//            QYSystem.yi_invokeCameraPhoto(nil)
            
//            QYAlert.yi_show {
//                QYHUD.yi_show("这下吧发是这下吧发是这下吧发是这下吧发是") {
//                    QYLog("12333333333333333333")
//                    yi_push(MyViewController())
//                }
//            }
            
            
//            QYHUD.showProgress()
//            let cam = QYCameraController()
//            yi_push(cam)
//            yi_present(cam.yi_then({
////                $0.titleText = "213hndnsajif"
//                $0.modalPresentationStyle = .fullScreen
////                $0.photoType = .reverse
//            }))
//            cam.yi_cameraDidFinishShoot = {
//                brn.yi_backgroundImage = $0
//            }
            
        }
    }
    func ceshi2() {
//        let page = QYPageView().yi_then({
//            $0.lineColor = .red
//            $0.lineSpacing = 9
//            $0.lineWidth = 20
//            $0.backgroundColor = .blue
//            view.addSubview($0)
//            $0.yi_viewControllers = [MyViewController(),MyViewController(),MyViewController(),MyViewController(),MyViewController(),MyViewController()]
//        })
//        page.snp.makeConstraints({
//            $0.top.equalTo(QYStatusHeight)
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalTo(-QYBottomHeight)
//        })
//        page.yi_createPage(["都是","无去的啊","无去的","㡒豆捞坊什么","㡒经济法可什么","为福克斯的从自行车"]) { (str, i) in
//            QYLog("\(str)" + "\(i)")
//        }
    }
    func ceshi1() {
        
        tableView = QYBaseTableView(frame: view.bounds)
        tableView.yi_empty_title = "123"
        tableView.backgroundColor = .blue
        tableView.yi_isScrollEnabled = true
        view.addSubview(tableView)
        tableView.yi_dataCount = 18
        tableView.yi_cellForRowAtIndexPath { (tab, index) -> UITableViewCell in
            return UITableViewCell()
        }.yi_numberOfRowsInSection { (tab, int) -> (Int) in
            return self.tableView.yi_page * self.tableView.yi_pageNumber
        }
        
        tableView.yi_didSelectRowAtIndexPath { (tab, indexPath) in
            QYLog(indexPath)
        }
        
        tableView.yi_refreshFooter {
            DispatchQueue.main.yi_after(1) {
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
//        la.yi_setGradientLayer(direction: .leftBottom, colors: [.blue,.red])
//        la.yi_configRectCorner(radii: .init(width: 30, height: 30))
//        la.layer.masksToBounds = true
//        let img = UIImageView().Yi_init {
//            view.addSubview($0)
//            $0.backgroundColor = .blue
//            $0.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
//        }
        
        
//        img.image = UIImage.initGradient(size: .init(width: 100, height: 100), direction: .leftTop, colors: [.blue,.red])
//        img.yi_addBorderTop(size: 10, color: .blue)
        view.backgroundColor = .blue
//        let string = "adcfb425723432".yi_xor("213871248dbcaf")
//        yPrintLog(string.yi_hexToString())
//        QYLog("text=text".yi_toURLEncode("="))
        let lab = QYCountDownButton().yi_then {
            $0.frame = .init(x: 100, y: 100, width: 100, height: 100)
            $0.yi_title = "获取验证码"
            $0.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        }
        view.addSubview(lab)
        
        _ = CGSize.init(width: 1, height: 1) + CGSize.init(width: 1, height: 1)
    }
    
    @objc func click (_ btn: QYCountDownButton) {
//        QYAlert.yi_show(message: "打", titleArr: ["123","qwe"], highlighted: 1, handler: { (alert,action,i) in
//            if i == 0 {
//                action.setValue(QY99Color, forKey: "titleTextColor")
//            }
//            alert.yi_titleColor = .cyan
//            alert.yi_titleFont = QYFont_23
//            alert.yi_messageColor = .green
//            alert.yi_messageFont = QYFont_22
//            action.yi_titleColor = .red
//            QYLog(action.yi_get_class_copyPropertyList())
//            QYLog(action.yi_get_class_copyMethodList())
//            action.yi_image = UIImage.init(named: "矩形 490")
//            
//        }) { (i, s) -> (Void) in
//            
//        }
//        QYLog(["12","34","56","78"][[0,3,7]])
    }
}


struct MyInfo_Data: QYCodable {
    var vipOverTime: QYStrDble?
    var activateTime: QYStrDble?
    var creator: String?
    var recStatus: String?
    var isTwiceMonthReach: String?
    var creditCardNo: String?
    var isVipFirst: QYStrInt?
    var id: String?
    var vipOpenTime: QYStrDble?
    var password: String?
    var nextMonthReachTime: QYStrDble?
    var merchantCode: String?
    var unbindTime: QYStrDble?
    var twiceMonthReachTime: QYStrDble?
    var realName: String?
    var isNextMonthReach: String?
    var salt: String?
    var mobilePhone: String?
    var modifyTime: QYStrDble?
    var merchantStatus: String?
    var isVip: Bool?
    var reachTime: QYStrDble?
    var bindTime: QYStrDble
    var identityNo: String?
    var debitCardNo: String?
    var modifier: String?
    var merchantName: String?
    var merchantType : String?
    var avatar: String?
    var createTime: QYStrDble?
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
