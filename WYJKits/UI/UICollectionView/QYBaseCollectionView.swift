/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit
import MJRefresh
import DZNEmptyDataSet

open class QYBaseCollectionView: UICollectionView {

    public var yi_empty_title             : String?   = "暂无数据"
    public var yi_empty_titleFont         : UIFont    = QYFont(15)
    public var yi_empty_titleColor        : UIColor   = QY33Color
    
    public var yi_empty_description       : String?
    public var yi_empty_descriptionFont   : UIFont    = QYFont(15)
    public var yi_empty_descriptionColor  : UIColor   = QY33Color
    private var _yi_empty_image           : UIImage?
    public var yi_empty_image             : UIImage? {
        set {
            _yi_empty_image = newValue
            reloadTableView()
        }
        get {
            return _yi_empty_image
        }
    }
    
    public var yi_empty_btn_title         : String?
    public var yi_empty_btn_titleFont     : UIFont    = QYFont(15)
    public var yi_empty_btn_titleColor    : UIColor   = QY33Color
    private var _yi_empty_btn_image       : UIImage?
    public var yi_empty_btn_image         : UIImage? {
        set {
            _yi_empty_btn_image = newValue
            reloadTableView()
        }
        get {
            return _yi_empty_btn_image
        }
    }
    ///图文间距
    public var yi_empty_spaceHeight             : CGFloat   = QYRatio(10)
    ///偏移
    public var yi_empty_verticalOffset          : CGFloat   = 0
    public var yi_empty_backgroundColor         : UIColor   = QYF5Color
    
    private var emptyClickBlock         : (() -> Void)? = nil
    
    ///分页页数
    public var yi_page: Int = 1
    ///分页每页个数
    public var yi_pageNumber: Int = 10
    ///数据个数
    public var yi_dataCount: Int = 0
    public var yi_isScrollEnabled         : Bool?
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                automaticallyAdjustsScrollIndicatorInsets = false
            }
            contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        emptyDataSetSource = self
        emptyDataSetDelegate = self
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
        isScrollEnabled = yi_isScrollEnabled ?? true
        
        yi_endRefreshing()
        if (mj_footer != nil) {
            if yi_page * yi_pageNumber > yi_dataCount {
                yi_endRefreshingWithNoMoreData()
            }
            yi_page += 1
        }
    }
    
}

//MARK: --- MJRefresh 刷新与加载
public extension QYBaseCollectionView {
    ///下拉
    func yi_refreshNormakHeader (_ refreshingBlock: @escaping() -> Void) {
        let header = MJRefreshNormalHeader.init(refreshingBlock: refreshingBlock)
        mj_header = header
    }
    
    ///动画下拉
    func yi_refreshGifHeader (_ refreshingBlock: @escaping() -> Void) {
        let header = MJRefreshGifHeader.init(refreshingBlock: refreshingBlock)
        mj_header = header
    }
    
    ///上拉
    func yi_refreshFooter (_ refreshingBlock: @escaping() -> Void) {
        let footer = MJRefreshBackNormalFooter.init(refreshingBlock: refreshingBlock)
        mj_footer = footer
    }
    
    ///提示没有更多的数据
    func yi_endRefreshingWithNoMoreData(){
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    ///结束刷新状态
    func yi_endRefreshing() {
        mj_header?.endRefreshing()
        mj_footer?.endRefreshing()
    }
    
    func yi_empty_button(title:String , _ bl: (() -> Void)?) {
        yi_empty_title = nil
        yi_empty_btn_title = title
        emptyClickBlock = bl
        reloadTableView()
    }
    
}

//MARK: --- DZNEmptyDataSet  空界面
extension QYBaseCollectionView: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    //MARK: -- DZNEmptyDataSetSource Methods
    ///标题为空的数据集
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: yi_empty_titleFont,
                          NSAttributedString.Key.foregroundColor: yi_empty_titleColor]
        
        if let tit = yi_empty_title {
            return NSAttributedString(string: tit, attributes: attributes)
        }
        
        return  nil
    }
    ///描述
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
       
       let paragraph = NSMutableParagraphStyle()
       paragraph.alignment = .center
       paragraph.lineSpacing = CGFloat(NSLineBreakMode.byWordWrapping.rawValue)
        let attributes = [NSAttributedString.Key.font: yi_empty_descriptionFont,
                          NSAttributedString.Key.foregroundColor: yi_empty_descriptionColor,
                          NSAttributedString.Key.paragraphStyle: paragraph]
        if let des = yi_empty_description {
            return NSAttributedString(string: des, attributes: attributes)
        }
        return nil
    }
    ///图片
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let img = yi_empty_image {
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
        let attributes = [NSAttributedString.Key.font: yi_empty_btn_titleFont,
                          NSAttributedString.Key.foregroundColor: yi_empty_btn_titleColor]
        
        if let tit = yi_empty_btn_title {
            return NSAttributedString(string: tit, attributes: attributes)
        }
        return nil
    }

    ///重新加载按钮背景图片
    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        if let yi_empty_image = yi_empty_image {
            return yi_empty_image
        }
        return nil
       
    }
    ///自定义背景颜色
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return yi_empty_backgroundColor
    }

    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return yi_empty_verticalOffset
    }

    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return yi_empty_spaceHeight
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



