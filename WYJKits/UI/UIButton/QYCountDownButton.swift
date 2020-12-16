/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

///倒计时按钮
open class QYCountDownButton: UIButton {
    /// 最大倒计时
    public var yi_maxSecond = 60
    /// 判断是否处于倒计时状态(默认false)
    public var yi_isCountDown = false {
        didSet {
            oldValue ? startCountdown() : stopCountdown()
        }
    }
    static  let shared = QYCountDownButton()
    private var second = 0
    private var timer: Timer?
    private var timeLabel = UILabel()
    private var normalText: String!
    private var normalTextColor: UIColor!
    private var disabledText: String!
    private var disabledTextColor: UIColor!
    
    deinit {
        yi_isCountDown = false
    }
    
    private func startCountdown() {
        setupLabel()
        second = yi_maxSecond
        updateDisabled()
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        updateNormal()
    }
    private func setupLabel() {
        guard timeLabel.superview == nil else { return }
        normalText = title(for: .normal) ?? ""
        disabledText = title(for: .disabled) ?? ""
        normalTextColor = titleColor(for: .normal) ?? .white
        disabledTextColor = titleColor(for: .disabled) ?? normalTextColor
        setTitle("", for: .normal)
        setTitle("", for: .disabled)
        timeLabel.frame = bounds
        timeLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        timeLabel.textAlignment = .center
        timeLabel.font = titleLabel?.font
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
        addSubview(timeLabel)
    }
    private func updateDisabled() {
        isEnabled = false
        timeLabel.textColor = disabledTextColor
        timeLabel.text = disabledText.replacingOccurrences(of: disabledText, with: "\(second)")
    }
    private func updateNormal() {
        isEnabled = true
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
    }
    @objc private func updateCountdown() {
        second -= 1
        if second <= 0 {
            yi_isCountDown = false
        } else {
            updateDisabled()
        }
    }
}
