/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

public enum QYLabelGradient: Int {
    ///水平
    case level                  = 0x00
    ///垂直
    case vertical               = 0x01
    ///左上对角线
    case leftTop_diagonal       = 0x02
    ///左下对角线
    case leftBottom_diagonal    = 0x03
}

public class QYGradientLabel: UILabel {
    static let shared = QYGradientLabel()
    private var textLabel: UILabel?
    private let gradientLayer = CAGradientLayer()
    
    public override var text: String? {
        set {
            textLabel?.text = newValue
        }
        get {
            return textLabel?.text
        }
    }
    
    public override var font: UIFont! {
        set {
            textLabel?.font = newValue
        }
        get {
            return textLabel?.font
        }
    }
    
    public override var textAlignment: NSTextAlignment {
        set {
            textLabel?.textAlignment = newValue
        }
        get {
            return textLabel?.textAlignment ?? .left
        }
    }
    
    public var colors: [UIColor]? {
        didSet {
            var co = [CGColor]()
            colors?.forEach({ (color) in
                co.append(color.cgColor)
            })
            gradientLayer.colors = co
        }
    }

    ///渐变色位置
    public var locationsType: QYLabelGradient? {
        didSet {
            switch locationsType {
                case .level:
                    gradientLayer.startPoint = .init(x: 0, y: 0)
                    gradientLayer.endPoint = .init(x: 1, y: 0)
                case .vertical:
                    gradientLayer.startPoint = .init(x: 0, y: 0)
                    gradientLayer.endPoint = .init(x: 0, y: 1)
                case .leftTop_diagonal:
                    gradientLayer.startPoint = .init(x: 0, y: 0)
                    gradientLayer.endPoint = .init(x: 1, y: 1)
                case .leftBottom_diagonal:
                    gradientLayer.startPoint = .init(x: 1, y: 0)
                    gradientLayer.endPoint = .init(x: 0, y: 1)
                default:
                    break
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //首先分别创建渐变层和文本标签，然后将渐变层的mask设置为文本标签即可。
        let containerView = UIView.init(frame: bounds)
        addSubview(containerView)
                
        textLabel = UILabel.init(frame: bounds)
        addSubview(textLabel!)
                
        gradientLayer.frame = bounds
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.mask = textLabel?.layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

