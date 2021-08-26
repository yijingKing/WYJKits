/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/

import UIKit
 
public class WYJDrawSignatureView: UIView {
     
    // 公共属性
    public var lineWidth: CGFloat = 1.0 {
        didSet {
            path.lineWidth = lineWidth
        }
    }
    public var strokeColor: UIColor = UIColor.black
    public var signatureBackgroundColor: UIColor = UIColor.white
     
    // 私有属性
    fileprivate var path = UIBezierPath()
    fileprivate var pts = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var ctr = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = signatureBackgroundColor
        path.lineWidth = lineWidth
    }
     
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = signatureBackgroundColor
        path.lineWidth = lineWidth
    }
     
    // Draw
    override open func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        path.stroke()
    }
     
    // 触摸签名相关方法
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first{
            let touchPoint = firstTouch.location(in: self)
            ctr = 0
            pts[0] = touchPoint
        }
    }
     
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first{
            let touchPoint = firstTouch.location(in: self)
            ctr += 1
            pts[ctr] = touchPoint
            if (ctr == 4) {
                pts[3] = CGPoint(x: (pts[2].x + pts[4].x) / 2.0, y: (pts[2].y + pts[4].y) / 2.0)
                path.move(to: pts[0])
                path.addCurve(to: pts[3], controlPoint1:pts[1],
                    controlPoint2:pts[2])
                 
                setNeedsDisplay()
                pts[0] = pts[3]
                pts[1] = pts[4]
                ctr = 1
            }
            setNeedsDisplay()
        }
    }
     
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ctr == 0{
            let touchPoint = pts[0]
            path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
            setNeedsDisplay()
        } else {
            ctr = 0
        }
    }
     
    // 签名视图清空
    public func clearSignature() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
     
    // 将签名保存为UIImage
    public func getSignature() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: bounds.size.width, height: bounds.size.height))
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let signature: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return signature
    }
}
