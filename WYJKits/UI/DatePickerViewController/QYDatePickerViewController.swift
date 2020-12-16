/*******************************************************************************
Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
public enum QYComponentsType: Int {
    case year = 0
    case month = 1
    case day = 2
} 

///时间选择器
open class QYDatePickerViewController: UIViewController {
    
    private var type: QYComponentsType?
    private var backDate: ((String) -> Void)?
    private var startTime = 2016
    public var picker: UIPickerView!
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())    //日期类型
    public var containV: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - QYRatio(260), width: UIScreen.main.bounds.width, height: QYRatio(260)))
        view.backgroundColor = UIColor.white
        return view
    }()
    public var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Func
    private var cancelBtn: UIButton!
    private var sureBtn: UIButton!
    private func drawMyView() {
        view.insertSubview(backgroundView, at: 0)
        modalPresentationStyle = .custom
        cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: QYRatio(80), height: QYRatio(40)))
        sureBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - QYRatio(80), y: 0, width: QYRatio(80), height: QYRatio(40)))
        cancelBtn.setTitle("取消", for: .normal)
        sureBtn.setTitle("确认", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.setTitleColor(UIColor.init(red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0, alpha: 1), for: .normal)
        sureBtn.setTitleColor(UIColor.init(red: 28 / 255.0, green: 129 / 255.0, blue: 254 / 255.0, alpha: 1), for: .normal)
        cancelBtn.addTarget(self, action: #selector(onClickcancelBtn), for: .touchUpInside)
        sureBtn.addTarget(self, action: #selector(onClicksureBtn), for: .touchUpInside)
        picker = UIPickerView(frame: CGRect(x: 0, y: QYRatio(40), width: UIScreen.main.bounds.width, height: QYRatio(220)))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.clear
        picker.clipsToBounds = true
        containV.addSubview(cancelBtn)
        containV.addSubview(sureBtn)
        containV.addSubview(picker)
        view.addSubview(containV)
    }
    // MARK: on cancelBtn Click
    @objc func onClickcancelBtn() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: on sureBtn Click
    @objc func onClicksureBtn() {
        var dateString = ""
        switch type {
        case .year:
            dateString = String(format: "%02ld",
                                picker.selectedRow(inComponent: 0) + startTime)
        case .month:
            dateString = String(format: "%02ld-%02ld",
                                picker.selectedRow(inComponent: 0) + startTime,
                                picker.selectedRow(inComponent: 1) + 1)
        case .day:
            dateString = String(format: "%02ld-%02ld-%02ld",
                                picker.selectedRow(inComponent: 0) + startTime,
                                picker.selectedRow(inComponent: 1) + 1,
                                picker.selectedRow(inComponent: 2) + 1)
        case .none:
            break
        }
        if backDate != nil {
            backDate!(dateString)
        }
        dismiss(animated: true, completion: nil)
    }
    ///点击任意位置view消失
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let currentPoint = touches.first?.location(in: view)
        if !containV.frame.contains(currentPoint ?? CGPoint()) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: - PickerViewDelegate
extension QYDatePickerViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .year:
            return 1
        case .month:
            return 2
        default:
            break
        }
        return 3
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 10
        } else if component == 1 {
            return 12
        } else {
            let year: Int = pickerView.selectedRow(inComponent: 0) + currentDateCom.year!
            let month: Int = pickerView.selectedRow(inComponent: 1) + 1
            let days: Int = howManyDays(inThisYear: year, withMonth: month)
            return days
        }
    }
    private func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch type {
        case .year:
            return UIScreen.main.bounds.width
        case .month:
            return UIScreen.main.bounds.width / 2
        default:
            break
        }
        return UIScreen.main.bounds.width / 3
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(startTime + row)\("年")"
        } else if component == 1 {
            return "\(row + 1)\("月")"
        } else {
            return "\(row + 1)\("日")"
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .year:break
        case .month:
            if component == 0 {
                pickerView.reloadComponent(1)
            }
        case .day:
            if component == 1 {
                pickerView.reloadComponent(2)
            }
        default:
            break
        }
    }
}
enum DatePickerPresentAnimateType {
    case present//被推出时
    case dismiss//取消时
}
// MARK: - 转场动画delegate
extension QYDatePickerViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = QYDatePickerViewControllerAnimated(type: .present)
        return animated
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = QYDatePickerViewControllerAnimated(type: .dismiss)
        return animated
    }
}
//DatePickerViewController的推出和取消动画
private class QYDatePickerViewControllerAnimated: NSObject,UIViewControllerAnimatedTransitioning {

    var type: DatePickerPresentAnimateType = .present

    init(type: DatePickerPresentAnimateType) {
        self.type = type
    }
    /// 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    /// 动画效果
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        switch type {
        case .present:
            guard let toVC = transitionContext.viewController(forKey: .to) as? QYDatePickerViewController else {
                return
            }
            let toView = toVC.view

            let containerView = transitionContext.containerView
            containerView.addSubview(toView!)

            toVC.containV.transform = CGAffineTransform(translationX: 0, y: (toVC.containV.frame.height))

            UIView.animate(withDuration: 0.25, animations: {
                /// 背景变色
                toVC.backgroundView.alpha = 1.0
                /// datepicker向上推出
                toVC.containV.transform =  CGAffineTransform(translationX: 0, y: -10)
            }) { ( _ ) in
                UIView.animate(withDuration: 0.2, animations: {
                    /// transform初始化
                    toVC.containV.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                })
            }
        case .dismiss:
            guard let toVC = transitionContext.viewController(forKey: .from) as? QYDatePickerViewController else {
                return
            }
            UIView.animate(withDuration: 0.25, animations: {
                toVC.backgroundView.alpha = 0.0
                /// datepicker向下推回
                toVC.containV.transform =  CGAffineTransform(translationX: 0, y: (toVC.containV.frame.height))
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}

//MARK: --- 调用方法
extension QYDatePickerViewController {
    /// 年月日
    /// - Parameters:
    ///   - types: 类型
    ///   - startTimes: 开始时间
    ///   - cancel: 取消文本
    ///   - cancelBtnColor: 颜色
    ///   - cancelBtnFont: 字体
    ///   - sure: 确认文本
    ///   - sureBtnColor: 颜色
    ///   - sureBtnFont: 字体
    ///   - block: 确认回调
    public class func yi_show(_ type: QYComponentsType,
                              _ startTime: Int? = nil,
                              _ cancel: String? = nil,
                              _ cancelBtnColor: UIColor? = nil,
                              _ cancelBtnFont: CGFloat? = nil,
                              _ sure: String? = nil,
                              _ sureBtnColor: UIColor? = nil,
                              _ sureBtnFont: CGFloat? = nil,
                              _ block: @escaping ((String) -> Void)) {
        let vc = QYDatePickerViewController()
        vc.yi_showDatePicker(type, startTime, cancel, cancelBtnColor, cancelBtnFont, sure, sureBtnColor, sureBtnFont, block)
        
    }
    /// 年月日
    /// - Parameters:
    ///   - types: 类型
    ///   - startTimes: 开始时间
    ///   - cancel: 取消文本
    ///   - cancelBtnColor: 颜色
    ///   - cancelBtnFont: 字体
    ///   - sure: 确认文本
    ///   - sureBtnColor: 颜色
    ///   - sureBtnFont: 字体
    ///   - block: 确认回调
    public func yi_showDatePicker(_ types: QYComponentsType,
                                  _ startTimes: Int? = nil,
                                  _ cancel: String? = nil,
                                  _ cancelBtnColor: UIColor? = nil,
                                  _ cancelBtnFont: CGFloat? = nil,
                                  _ sure: String? = nil,
                                  _ sureBtnColor: UIColor? = nil,
                                  _ sureBtnFont: CGFloat? = nil,
                                  _ block: @escaping ((String) -> Void)) {
        modalPresentationStyle = .fullScreen
        type = types
        startTime = startTimes ?? 2016
        backDate = block
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        drawMyView()
        cancelBtn.setTitle(cancel ?? "取消", for: .normal)
        cancelBtn.setTitleColor(cancelBtnColor ?? QY99Color, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: cancelBtnFont ?? 15)
        sureBtn.setTitle(sure ?? "确定", for: .normal)
        sureBtn.setTitleColor(sureBtnColor ?? QYHexColor("#1C81FE"), for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: sureBtnFont ?? 15)
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}


