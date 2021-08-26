/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/

import UIKit


public extension WYJProtocol where T: UITabBarItem {
    @discardableResult
    func addItem(title: String,norImage: UIImage? = nil,seleImage: UIImage? = nil) -> WYJProtocol {
        obj.title = title
        if let img = norImage {
            obj.image = img
        }
        if let simg = seleImage {
            obj.selectedImage = simg
        }
        return self
    }
}

public class WYJTabBarController: UITabBarController {

    private var vs = [UIViewController]()
    private lazy var wTabbar: WYJTabbar = {
        return WYJTabbar().yi.then({
            $0.centerBtn.yi.clickAction {_ in
                self.selectedIndex = self.selectedItem
            }
        })
    }()
    private var selectedItem = 1
    public var totalItemNumber: Int = 0 {
        willSet {
            wTabbar.number = newValue
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tabBar.isTranslucent = false
    }
    
    ///添加中心凸起控制器
    public func addCenterChild(vc: UIViewController,title: String,image: UIImage) {
        addCenterItem()
        vc.tabBarItem.yi.addItem(title: title)
        wTabbar.centerBtn.yi.image(image)
        vs.append(vc)
        selectedItem = vs.count
        viewControllers = vs
        tabBar.tintColor = .black
    }
    ///添加单个控制器
    public func addChild(vc: UIViewController,title: String,
                         image: UIImage,seleImage: UIImage) {
        vc.tabBarItem.yi.addItem(title: title, norImage: image, seleImage: seleImage)
        vs.append(vc)
        viewControllers = vs
        tabBar.tintColor = .black
    }
    ///添加所有控制器
    public func addChilds(vcs:[UIViewController],titles:[String],images:[UIImage],
                          seleImages:[UIImage],centerNum: Int? = nil) {
        if let _ = centerNum {
            addCenterItem()
        }
        
        for (i,vc) in vcs.enumerated() {
            if i == centerNum {
                selectedItem = i
                vc.tabBarItem.yi.addItem(title: titles[i])
                wTabbar.centerBtn.yi.image(images[i])
            } else {
                vc.tabBarItem.yi.addItem(title: titles[i], norImage: images[i],
                                         seleImage: seleImages[i])
            }
            vs.append(vc)
        }
        tabBar.tintColor = .black
    }
}
extension WYJTabBarController {
    private func addCenterItem() {
        setValue(wTabbar, forKey: "tabBar")
    }
}

class WYJTabbar: UITabBar {
    var number = 3
    lazy var centerBtn: UIButton = {
        return UIButton().yi.then({
            let img = #imageLiteral(resourceName: "post_normal")
            $0.frame = .init(x: (WYJScreenWidth - img.size.width) / number,
                             y: -img.size.height / number,
                             width: img.size.width,
                             height: img.size.height)
            
            $0.yi.image(img)
            $0.adjustsImageWhenHighlighted = false
        })
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(centerBtn)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = super.hitTest(point, with: event)
        if v == nil {
            let tempPoint = centerBtn.convert(point, from: self)
            if centerBtn.bounds.contains(tempPoint) {
                return centerBtn
            }
        }
        return v
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
