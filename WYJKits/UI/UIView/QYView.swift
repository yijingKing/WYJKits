/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import Foundation
import QuartzCore
//MARK: --- 框线
public extension UIView {
    
    enum ViewSide {
        case top
        case right
        case bottom
        case left
    }
    //MARK: --- 单边边框线
    func yi_addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        layoutIfNeeded()
        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                             y: 0 + topOffset,
                                             width: bounds.size.width - leftOffset - rightOffset,
                                             height: thickness), color: color)
            layer.addSublayer(border)
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: frame.size.width-thickness-rightOffset,
                                             y: 0 + topOffset, width: thickness,
                                             height: bounds.size.height - topOffset - bottomOffset), color: color)
            layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                             y: bounds.size.height-thickness-bottomOffset,
                                             width: bounds.size.width - leftOffset - rightOffset, height: thickness), color: color)
            layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                             y: 0 + topOffset,
                                             width: thickness,
                                             height: bounds.size.height - topOffset - bottomOffset), color: color)
            layer.addSublayer(border)
        }
    }
    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
}

//MARK: --- 渐变色
public extension UIView {
    /// 渐变色方向
    enum GradientDirection {
        ///垂直
        case vertical
        ///水平
        case level
        ///左上到右下
        case leftTop
        ///左下到右上
        case leftBottom
    }
    
    /// 渐变色
    /// - Parameters:
    ///   - direction: 方向
    ///   - locations: 位置
    ///   - colors: 颜色组
    func yi_setGradientLayer (direction: GradientDirection,locations: Array<NSNumber> = [0.0,1.0] ,colors: [UIColor]) {
        layoutIfNeeded()
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = bounds
        var cgColors = [CGColor]()
        colors.forEach { (colo) in
            cgColors.append(colo.cgColor)
        }
        gradientLayer.colors = cgColors
        gradientLayer.locations = locations
        switch direction {
        case .vertical:
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint.init(x: 0, y: 1.0)
            break
        case .level:
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0)
            break
        case .leftTop:
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 1.0)
            break
        case .leftBottom:
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 1.0)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.0)
            break
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
//MARK: --- 跳转
public extension UIView {
    
    func yi_push(_ vc: UIViewController, animated: Bool = true) {
        if let currentC = yi_currentController() {
            if currentC.isKind(of: UINavigationController.self) {
                let nav: UINavigationController = currentC as! UINavigationController
                if nav.viewControllers.count > 0 {
                    vc.hidesBottomBarWhenPushed = true
                }
                nav.pushViewController(vc, animated: animated)
            } else {
                if currentC.navigationController != nil {
                    let nav: UINavigationController = currentC.navigationController!
                    if nav.viewControllers.count > 0 {
                        vc.hidesBottomBarWhenPushed = true
                    }
                    currentC.navigationController!.pushViewController(vc, animated: animated)
                }
            }
        }
    }
    
    func yi_pop(_ animated: Bool = true) {
        if let currentC = yi_currentController() {
            if currentC.isKind(of: UINavigationController.self) {
                ((currentC as? UINavigationController))?.popViewController(animated: animated)
            } else {
                currentC.dismiss(animated: animated, completion: nil)
            }
        }
    }
    
    func yi_popToRootViewController(_ animated: Bool = true) {
        if let currentC = yi_currentController() {
            if currentC.isKind(of: UINavigationController.self) {
                (currentC as! UINavigationController).popToRootViewController(animated: true)
            }
        }
    }
    func yi_present(_ vc: UIViewController, animated: Bool = true) {
        yi_currentController()?.present(vc, animated: animated, completion: nil)
    }
    func yi_dismiss(_ animated: Bool = true) {
        yi_currentController()? .dismiss(animated: animated, completion: nil)
    }
    ///获取父控制器
    func yi_currentController() -> UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UINavigationController.self) {
                    let tab = responder as! UINavigationController
                    return tab.visibleViewController
                } else if responder.isKind(of: UITabBarController.self) {
                    let tab = responder as! UITabBarController
                    return tab.selectedViewController
                } else if responder.isKind(of: UIViewController.self) {
                    let vc = responder as! UIViewController
                    return vc
                }
            }
        }
        return nil
    }
}
//MARK: --- frame
public extension UIView {
    func yi_addSubviews(_ views: [UIView]) {
        views.forEach { [weak self] eachView in
            self?.addSubview(eachView)
        }
    }
    var x: CGFloat {
        get {
            return frame.origin.x
        } set(value) {
            frame = CGRect(x: value, y: y, width: width, height: height)
        }
    }
    var y: CGFloat {
        get {
            return frame.origin.y
        } set(value) {
            frame = CGRect(x: x, y: value, width: width, height: height)
        }
    }
    var width: CGFloat {
        get {
            return frame.size.width
        } set(value) {
            frame = CGRect(x: x, y: y, width: value, height: height)
        }
    }
    var height: CGFloat {
        get {
            return frame.size.height
        } set(value) {
            frame = CGRect(x: x, y: y, width: width, height: value)
        }
    }
    var left: CGFloat {
        get {
            return x
        } set(value) {
            x = value
        }
    }
    var right: CGFloat {
        get {
            return x + width
        } set(value) {
            x = value - width
        }
    }
    var top: CGFloat {
        get {
            return y
        } set(value) {
            y = value
        }
    }
    var bottom: CGFloat {
        get {
            return y + height
        } set(value) {
            y = value - height
        }
    }
    var origin: CGPoint {
        get {
            return frame.origin
        } set(value) {
            frame = CGRect(origin: value, size: frame.size)
        }
    }
    var centerX: CGFloat {
        get {
            return center.x
        } set(value) {
            center.x = value
        }
    }
    var centerY: CGFloat {
        get {
            return center.y
        } set(value) {
            center.y = value
        }
    }
    var size: CGSize {
        get {
            return frame.size
        } set(value) {
            frame = CGRect(origin: frame.origin, size: value)
        }
    }
}

//MARK: --- 圆角
public extension UIView {
    private static var cornerRadiiKey: Void?
    private class Wrapper<T> {
        let value: T?
        init(_ value: T?) {
            self.value = value
        }
    }
    
    var yi_cornerRadii: QYCornerRadii? {
        get {
            let wrapper: Wrapper<QYCornerRadii>? = associated.get(&UIView.cornerRadiiKey)
            return wrapper?.value
        }
        set {
            let wrapper = Wrapper(newValue)
            associated.set(retain: &UIView.cornerRadiiKey, wrapper)
            
            if let value = newValue {
                update(value)
                
            } else {
                layer.mask = nil
            }
            
            UIView.swizzled
        }
    }
    
    private static let swizzled: Void = {
        let originalSelector = #selector(UIView.layoutSubviews)
        let swizzledSelector = #selector(UIView._layoutSubviews)
        
        guard
            let originalMethod = class_getInstanceMethod(UIView.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector) else {
            return
        }
        
        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(
            UIView.self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        // 如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(
                UIView.self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
            
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    } ()
    
    @objc
    private func _layoutSubviews() {
        _layoutSubviews()
        update(yi_cornerRadii)
    }
    
    private func update(_ cornerRadii: QYCornerRadii?) {
        guard let cornerRadii = cornerRadii else {
            return
        }
        
        let lastShapeLayer = layer.mask as? CAShapeLayer
        let lastPath = lastShapeLayer?.path
        let path = QYCornerRadii.path(bounds, cornerRadii)
        // 防止相同路径多次设置
        guard lastPath != path else { return }
        // 移除原有路径动画
        lastShapeLayer?.removeAnimation(forKey: "cornerradii.path")
        // 重置新路径mask
        let mask = CAShapeLayer()
        mask.path = path
        layer.mask = mask
        // 同步视图大小变更动画
        if let temp = layer.animation(forKey: "bounds.size") {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = temp.duration
            animation.fillMode = temp.fillMode
            animation.timingFunction = temp.timingFunction
            animation.fromValue = lastPath
            animation.toValue = path
            mask.add(animation, forKey: "cornerradii.path")
        }
    }
    
    struct QYCornerRadii: Equatable {
        public var topLeft: CGFloat
        public var topRight: CGFloat
        public var bottomLeft: CGFloat
        public var bottomRight: CGFloat
        
        public init(_ radii: CGFloat = 0) {
            self.topLeft = radii
            self.topRight = radii
            self.bottomLeft = radii
            self.bottomRight = radii
        }
        
        public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
        
        public func with(topLeft: CGFloat) -> QYCornerRadii {
            var temp = self
            temp.topLeft = topLeft
            return temp
        }
        
        public func with(topRight: CGFloat) -> QYCornerRadii {
            var temp = self
            temp.topRight = topRight
            return temp
        }
        
        public func with(bottomLeft: CGFloat) -> QYCornerRadii {
            var temp = self
            temp.bottomLeft = bottomLeft
            return temp
        }
        
        public func with(bottomRight: CGFloat) -> QYCornerRadii {
            var temp = self
            temp.bottomRight = bottomRight
            return temp
        }
        
        public static let zero: QYCornerRadii = .init(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        
        static func path(_ bounds: CGRect, _ radii: QYCornerRadii) -> CGPath {
            let minX = bounds.minX
            let minY = bounds.minY
            let maxX = bounds.maxX
            let maxY = bounds.maxY
            
            let topLeftCenter: CGPoint = .init(x: minX + radii.topLeft, y: minY + radii.topLeft)
            let topRightCenter: CGPoint = .init(x: maxX - radii.topRight, y: minY + radii.topRight)
            let bottomLeftCenter: CGPoint = .init(x: minX + radii.bottomLeft, y: maxY - radii.bottomLeft)
            let bottomRightCenter: CGPoint = .init(x: maxX - radii.bottomRight, y: maxY - radii.bottomRight)
            
            let path = CGMutablePath()
            path.addArc(
                center: topLeftCenter,
                radius: radii.topLeft,
                startAngle: .pi,
                endAngle: .pi / 2 * 3,
                clockwise: false
            )
            path.addArc(
                center: topRightCenter,
                radius: radii.topRight,
                startAngle: .pi / 2 * 3,
                endAngle: 0,
                clockwise: false
            )
            path.addArc(
                center: bottomRightCenter,
                radius: radii.bottomRight,
                startAngle: 0,
                endAngle: .pi / 2,
                clockwise: false
            )
            path.addArc(
                center: bottomLeftCenter,
                radius: radii.bottomLeft,
                startAngle: .pi / 2,
                endAngle: .pi,
                clockwise: false
            )
            path.closeSubpath()
            return path
        }
    }
}

//MARK: --- layer
public extension UIView {
    //MARK: --- 连框
    ///连框
    var yi_borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //MARK: --- 圆角
    ///圆角
    var yi_cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    ///圆角
    func yi_cornerRadius(_ corners: UIRectCorner,_ radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    //MARK: --- 阴影
    ///阴影
    func yi_addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float,_ cornerRadius: CGFloat? = nil) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }
    //MARK: ------- 边框
    ///边框
    func yi_addBorder(width: CGFloat, _ color: UIColor = .black) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
    
    ///边框-上
    func yi_addBorderTop(_ size: CGFloat,_ padding: CGFloat = 0,_ color: UIColor = .black) {
        _addBorderUtility(x: padding, y: 0, width: frame.width - padding * 2, height: size, color: color)
    }
    
    ///边框-下
    func yi_addBorderBottom(_ size: CGFloat,_ padding: CGFloat = 0,_ color: UIColor = .black) {
        _addBorderUtility(x: padding, y: frame.height - size, width: frame.width - padding * 2, height: size, color: color)
    }
    
    ///边框-左
    func yi_addBorderLeft(_ size: CGFloat,_ padding: CGFloat = 0,_ color: UIColor = .black) {
        _addBorderUtility(x: 0, y: padding, width: size, height: frame.height - padding * 2, color: color)
    }
    
    ///边框-右
    func yi_addBorderRight(_ size: CGFloat,_ padding: CGFloat = 0,_ color: UIColor = .black) {
        _addBorderUtility(x: frame.width - size, y: padding, width: size, height: frame.height - padding * 2, color: color)
    }
    
    private func _addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    //MARK: --- 绘画
    ///画圆
    func yi_drawCircle(fillColor: UIColor,_ strokeColor: UIColor = .black, strokeWidth: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: width), cornerRadius: width/2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        layer.addSublayer(shapeLayer)
    }
    
    ///画中空圆
    func yi_drawStroke(width: CGFloat,_ color: UIColor = .black) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: width), cornerRadius: width / 2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        layer.addSublayer(shapeLayer)
    }
    
    ///画虚线
    func yi_drawDashLine(lineLength: Int ,lineSpacing: Int,lineColor: UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        //        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        
        shapeLayer.lineWidth = bounds.size.height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: 0))
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    ///移除layer
    func yi_removeLayer() {
        layer.mask = nil
        layer.borderWidth = 0
    }
}

//MARK: --- 转换
public extension UIView {
    ///转换成图片
    func yi_toImage(_ size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage.init()
    }
    ///转换成图片
    func yi_toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
        
}

//MARK: --- 手势
public extension UIView {
    ///多击
    func yi_addTapGesture(_ tapNumber: Int,
                          _ target: AnyObject,
                          _ action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    ///单击
    func yi_addTapGesture(_ action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: 1, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    ///滑动
    func yi_addSwipeGesture(_ direction: UISwipeGestureRecognizer.Direction,
                            _ numberOfTouches: Int = 1,
                            _ target: AnyObject,
                            _ action: Selector) {
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    ///滑动
    func yi_addSwipeGesture(_ direction: UISwipeGestureRecognizer.Direction,
                            _ numberOfTouches: Int = 1,
                            _ action: ((UISwipeGestureRecognizer) -> Void)?) {
        let swipe = BlockSwipe(direction: direction, fingerCount: numberOfTouches, action: action)
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    ///拖动
    func yi_addPanGesture(_ target: AnyObject,_ action: Selector) {
        let pan = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
    ///拖动
    func yi_addPanGesture(_ action: ((UIPanGestureRecognizer) -> Void)?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
    ///长按
    func yi_addLongPressGesture(_ target: AnyObject,_ action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
    ///长按
    func yi_addLongPressGesture(_ action: ((UILongPressGestureRecognizer) -> Void)?) {
        let longPress = BlockLongPress(action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
}



