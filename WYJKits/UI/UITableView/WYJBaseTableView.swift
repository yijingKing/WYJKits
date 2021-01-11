/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit

import DZNEmptyDataSet

public extension WYJProtocol where T: WYJBaseTableView {
    @discardableResult
    func empty_title(_ title: String) -> WYJProtocol {
        obj.empty_title = title
        return self
    }
    @discardableResult
    func empty_titleFont(_ font: UIFont) -> WYJProtocol {
        obj.empty_titleFont = font
        return self
    }
    @discardableResult
    func empty_titleColor(_ color: UIColor) -> WYJProtocol {
        obj.empty_titleColor = color
        return self
    }
    @discardableResult
    func empty_description(_ string: String) -> WYJProtocol {
        obj.empty_description = string
        return self
    }
    @discardableResult
    func empty_descriptionFont(_ font: UIFont) -> WYJProtocol {
        obj.empty_descriptionFont = font
        return self
    }
    @discardableResult
    func empty_descriptionColor(_ color: UIColor) -> WYJProtocol {
        obj.empty_descriptionColor = color
        return self
    }
    @discardableResult
    func empty_image(_ image: UIImage) -> WYJProtocol {
        obj.empty_image = image
        obj.reloadTableView()
        return self
    }
    @discardableResult
    func empty_btn_title(_ string: String) -> WYJProtocol {
        obj.empty_btn_title = string
        return self
    }
    @discardableResult
    func empty_btn_titleFont(_ font: UIFont) -> WYJProtocol {
        obj.empty_btn_titleFont = font
        return self
    }
    @discardableResult
    func empty_btn_titleColor(_ color: UIColor) -> WYJProtocol {
        obj.empty_btn_titleColor = color
        return self
    }
    @discardableResult
    func empty_btn_image (_ image: UIImage) -> WYJProtocol {
        obj.empty_btn_image = image
        obj.reloadTableView()
        return self
    }
    ///图文间距
    @discardableResult
    func empty_spaceHeight(_ float: CGFloat) -> WYJProtocol {
        obj.empty_spaceHeight = float
        return self
    }
    ///偏移
    @discardableResult
    func empty_verticalOffset (_ float: CGFloat) -> WYJProtocol {
        obj.empty_verticalOffset = float
        return self
    }
    @discardableResult
    func empty_backgroundColor(_ color: UIColor) -> WYJProtocol {
        obj.empty_backgroundColor = color
        return self
    }
    ///分页页数
    @discardableResult
    func page(_ i: Int) -> WYJProtocol {
        obj.page = i
        return self
    }
    ///分页每页个数
    @discardableResult
    func pageNumber(_ i: Int) -> WYJProtocol {
        obj.pageNumber = i
        return self
    }
    ///数据个数
    @discardableResult
    func dataCount(_ i: Int) -> WYJProtocol {
        obj.dataCount = i
        return self
    }
    @discardableResult
    func isScrollEnabled(_ b: Bool) -> WYJProtocol {
        obj.isscrollEnabled = b
        return self
    }
    
    @discardableResult
    func empty_button(_ title:String, _ bl: (() -> Void)?) -> WYJProtocol {
        obj.empty_button(title: title, bl)
        return self
    }
    
}

open class WYJBaseTableView: UITableView {
    public var isscrollEnabled         : Bool = true
    public var empty_title             : String?   = "暂无数据"
    public var empty_titleFont         : UIFont    = WYJFont(15)
    public var empty_titleColor        : UIColor   = WYJ33Color
    
    public var empty_description       : String?
    public var empty_descriptionFont   : UIFont    = WYJFont(15)
    public var empty_descriptionColor  : UIColor   = WYJ33Color
    private var _empty_image    : UIImage?
    public var empty_image             : UIImage? {
        set {
            _empty_image = newValue
            reloadTableView()
        }
        get {
            return _empty_image
        }
    }
    
    public var empty_btn_title         : String?
    public var empty_btn_titleFont     : UIFont    = WYJFont(15)
    public var empty_btn_titleColor    : UIColor   = WYJ33Color
    private var _empty_btn_image: UIImage?
    public var empty_btn_image         : UIImage? {
        set {
            _empty_btn_image = newValue
            reloadTableView()
        }
        get {
            return _empty_btn_image
        }
    }
    
    ///图文间距
    public var empty_spaceHeight             : CGFloat   = WYJRatio(10)
    ///偏移
    public var empty_verticalOffset          : CGFloat   = 0
    public var empty_backgroundColor         : UIColor   = WYJF5Color
    
    private var emptyClickBlock         : (() -> Void)? = nil
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                automaticallyAdjustsScrollIndicatorInsets = false
            }
            contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        emptyDataSetSource = self
        emptyDataSetDelegate = self
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    open override func reloadEmptyDataSet() {
        super.reloadEmptyDataSet()
    }
    fileprivate func reloadTableView(){
        reloadEmptyDataSet()
        reloadData()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func reloadData() {
        super.reloadData()
        isScrollEnabled = isscrollEnabled
        endRefreshing()
    }
    func empty_button(title:String , _ bl: (() -> Void)?) {
        empty_title = nil
        empty_btn_title = title
        emptyClickBlock = bl
        reloadTableView()
    }
}


public extension WYJBaseTableView {
    fileprivate func delegateInitialize() {
        if WYJDelegate == nil {
            WYJDelegate = WYJTableViewDelegate()
            dataSource = WYJDelegate
            delegate = WYJDelegate
        }
    }
        
    fileprivate var WYJDelegate: WYJTableViewDelegate? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.WYJDelegateKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, WYJRuntimeKey.WYJDelegateKey!) as? WYJTableViewDelegate
        }
    }
    fileprivate struct WYJRuntimeKey {
        static let WYJDelegateKey = UnsafeRawPointer.init(bitPattern: "WYJDelegateKey".hashValue)
    }
}

//MARK: --- DZNEmptyDataSet  空界面
extension WYJBaseTableView: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    //MARK: -- DZNEmptyDataSetSource Methods
    ///标题为空的数据集
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: empty_titleFont,
                          NSAttributedString.Key.foregroundColor: empty_titleColor]
        
        if let tit = empty_title {
            return NSAttributedString(string: tit, attributes: attributes)
        }
        
        return  nil
    }
    ///描述
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
       
       let paragraph = NSMutableParagraphStyle()
       paragraph.alignment = .center
       paragraph.lineSpacing = CGFloat(NSLineBreakMode.byWordWrapping.rawValue)
        let attributes = [NSAttributedString.Key.font: empty_descriptionFont,
                          NSAttributedString.Key.foregroundColor: empty_descriptionColor,
                          NSAttributedString.Key.paragraphStyle: paragraph]
        if let des = empty_description {
            return NSAttributedString(string: des, attributes: attributes)
        }
        return nil
    }
    ///图片
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let img = empty_image {
            return img
        }
        return nil
    }
    ///数据集加载动画
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
       let animation = CABasicAnimation(keyPath: "transform")
       animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
       animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 0.0, 1.0))
       animation.duration = 0.25
       animation.isCumulative = true
       animation.repeatCount = MAXFLOAT
       return animation as CAAnimation
    }
    ///按钮标题
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: empty_btn_titleFont,
                          NSAttributedString.Key.foregroundColor: empty_btn_titleColor]
        
        if let tit = empty_btn_title {
            return NSAttributedString(string: tit, attributes: attributes)
        }
        return nil
    }

    ///重新加载按钮背景图片
    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        if let empty_image = empty_image {
            return empty_image
        }
        return nil
       
    }
    ///自定义背景颜色
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return empty_backgroundColor
    }

    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return empty_verticalOffset
    }

    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return empty_spaceHeight
    }

    //MARK: -- DZNEmptyDataSetDelegate
    ///数据源为空时是否渲染和显示 (默认为 YES)
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
       return true
    }
    ///是否允许点击 (默认为 YES)
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
       return true
    }
    ///是否允许滚动(默认为 NO)
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
       return false
    }

    ///是否允许动画(默认为 NO)
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
       return false
    }
    ///视图触发
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        
        if let block = emptyClickBlock {
            block()
        }
    }
    ///按钮触发
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if let block = emptyClickBlock {
            block()
        }
    }
}

//MARK: --- delegate --dataSource
public extension WYJProtocol where T: WYJBaseTableView {
    //MARK: --- 区头
    ///区数
    @discardableResult
    func numberSections(_ number: Int) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.numberSections = number
        return self
    }
    ///区数
    @discardableResult
    func numberOfSections(_ block: @escaping (UITableView)->(Int)) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.numberOfSections = block
        return self
    }
    
    ///区头高
    @discardableResult
    func heightHeaderSection(_ height: CGFloat) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.heightHeaderSection = height
        return self
    }
    ///区头高
    @discardableResult
    func heightForHeaderInSection(_ block: @escaping (UITableView, Int)->(CGFloat)) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.heightForHeaderInSection = block
        return self
    }
    ///区头视图
    @discardableResult
    func viewForHeaderInSection(_ block: @escaping (UITableView, Int)->UIView) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.viewForHeaderInSection = block
        return self
    }
    
    //MARK: --- 区尾
    ///区尾高
    @discardableResult
    func heightFooterSection(_ height: CGFloat) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.heightFooterSection = height
        return self
    }
    ///区尾高
    @discardableResult
    func heightForFooterInSection(_ block: @escaping (UITableView, Int)->(CGFloat)) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.heightForFooterInSection = block
        return self
    }
    ///区尾视图
    @discardableResult
    func viewForFooterInSection(_ block: @escaping (UITableView, Int)->UIView) -> WYJProtocol {
        obj.delegateInitialize()
        obj.WYJDelegate?.viewForFooterInSection = block
        return self
    }
    
    //MARK: --- 单元
    ///单元数(所有区相同)
    @discardableResult
    func numberRows(_ number: Int) -> WYJProtocol  {
        obj.delegateInitialize()
        obj.WYJDelegate?.numberRows = number
        return self
    }
    ///单元数
    @discardableResult
    func numberOfRowsInSection(_ block: @escaping (UITableView, Int)->(Int)) -> WYJProtocol  {
        obj.delegateInitialize()
        obj.WYJDelegate?.numberOfRowsInSection = block
        return self
    }
    ///单元高
    @discardableResult
    func heightRows(_ height: CGFloat) -> WYJProtocol  {
        obj.delegateInitialize()
        obj.WYJDelegate?.heightRows = height
        return self
    }
    ///单元高
    @discardableResult
    func heightForRowAtIndexPath(_ block: @escaping (UITableView, IndexPath)->(CGFloat)) -> WYJProtocol  {
        obj.delegateInitialize()
        obj.WYJDelegate?.heightForRowAtIndexPath = block
        return self
    }
    ///单元
    @discardableResult
    func cellForRowAtIndexPath(_ block: @escaping (UITableView, IndexPath)-> UITableViewCell) -> WYJProtocol  {
        obj.delegateInitialize()
        obj.WYJDelegate?.cellForRowAtIndexPath = block
        return self
    }
    ///单元点击
    @discardableResult
    func didSelectRowAtIndexPath(_ block: @escaping (UITableView, IndexPath)->()) -> WYJProtocol  {
        obj.delegateInitialize()
        obj.WYJDelegate?.didSelectRowAtIndexPath = block
        return self
    }
}
