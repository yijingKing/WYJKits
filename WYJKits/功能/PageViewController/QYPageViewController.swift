/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

///分页控制器
open class QYPageViewController: QYBaseViewController {
    private var currentIndex: Int = 0
    public var yi_page_normalColor: UIColor? {
        willSet {
            selectView.normalColor = newValue ?? QY33Color
        }
    }
    public var yi_page_selectColor: UIColor? {
        willSet {
            selectView.selectColor = newValue ?? .blue
        }
    }
    public var yi_page_font: UIFont? {
        willSet {
            selectView.font = newValue ?? QYFont(14)
        }
    }
    public var yi_page_titleHeight: CGFloat? {
        willSet {
            selectView.snp.removeConstraints()
            selectView.snp.makeConstraints({
                $0.top.equalTo(QYStatusAndNavHeight)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(QYRatio(newValue ?? 0))
            })
            pageViewController.view.frame = CGRect(x: 0, y: QYStatusAndNavHeight + QYRatio(newValue ?? 0), width: view.frame.width, height: view.frame.height - QYRatio(newValue ?? 0) - QYStatusAndNavHeight)
        }
    }
    public var yi_page_lineColor: UIColor? {
        willSet {
            selectView.lineView.backgroundColor = newValue ?? .blue
        }
    }
    public var yi_page_lineSpacing: CGFloat? {
        willSet {
            selectView.lineSpacing = newValue
        }
    }
    public var yi_page_lineWidth: CGFloat? {
        willSet {
            selectView.lineWidth = newValue
        }
    }
    
    fileprivate var selectView: QYSelectView!
    ///分页
    fileprivate lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing:0])
        return page.yi_then({
            $0.view.frame = CGRect(x: 0, y: QYStatusAndNavHeight + QYRatio(41), width: view.frame.width, height: view.frame.height - QYRatio(41))
            $0.delegate = self
            $0.dataSource = self
            view.addSubview($0.view)
            addChild($0)
        })
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        selectView = QYSelectView()
        view.addSubview(selectView)
        selectView.snp.makeConstraints({
            $0.top.equalTo(QYStatusAndNavHeight)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(QYRatio(41))
        })
    }
    
    public func yi_createPage(_ titles: Array<String>,_ spacing: Float? = nil,_ uniform: Bool = true,_ block: ((String,Int,UIViewController)->())?) {
        var uni: Float?
        if titles.count < 4 && uniform {
            uni = Float(QYScreenWidth / titles.count)
        }
        selectView.create(titles, spacing ?? 0, uni ?? 0)
        selectView.clickBlock = {[weak self] in
            QYLog($0 + "\($1)")
            if let vc = self?.yi_viewControllers?[$1] {
                if $1 > self?.currentIndex ?? 0 {
                    self?.pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
                } else {
                    self?.pageViewController.setViewControllers([vc], direction: .reverse, animated: false, completion: nil)
                }
                if let bl = block {
                    bl(titles[$1],$1,vc)
                }
            }
        }
    }
    
    public var yi_viewControllers: Array<UIViewController>? {
        willSet {
            if let vc = newValue?.first {
                pageViewController.setViewControllers([vc], direction: .reverse, animated: false, completion: nil)
            }
        }
            
    }
    
}

extension QYPageViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    ///前一页
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let vcs = yi_viewControllers {
            let vs = vcs as NSArray
            var index = vs.index(of: viewController)
            if index == 0 || index == NSNotFound {
                return nil
            }
            index -= 1
            return yi_viewControllers?[index]
        }
        return nil
    }
    ///后一页
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vcs = yi_viewControllers {
            let vs = vcs as NSArray
            var index = vs.index(of: viewController)
            if index == vs.count - 1 || index == NSNotFound {
                return nil
            }
            index += 1
            return yi_viewControllers?[index]
        }
        return nil
        
    }
    ///将要滑动切换的时候
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first,let vcs = yi_viewControllers {
            let vs = vcs as NSArray
            let index = vs.index(of: vc)
            currentIndex = index
            if let btns = selectView.buttons {
                selectView.allClick(btns[currentIndex])
            }
        }
    }
    /// 滑动结束后
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}

public class QYSelectView: UIView {
    public var lineWidth: CGFloat?
    public var lineSpacing: CGFloat?
    public var normalColor: UIColor?
    public var selectColor: UIColor?
    public var font: UIFont?
    public var clickBlock: ((String,Int)->())?
    public var buttons: Array<UIButton>?
    public var topHeight: CGFloat? {
        willSet {
            topScrollView.snp.removeConstraints()
            topScrollView.snp.makeConstraints({
                $0.left.right.top.equalToSuperview()
                $0.height.equalTo(QYRatio(newValue ?? 0))
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttons = []
        addSubview(topScrollView)
        topScrollView.snp.removeConstraints()
        topScrollView.snp.makeConstraints({
            $0.left.right.top.bottom.equalToSuperview()
        })
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func create(_ titles: Array<String>,_ spacing: Float = 0,_ uniform: Float = 0) {
        topScrollView.subviews.forEach { sub in
            sub.removeFromSuperview()
        }
        buttons?.removeAll()
        
        var oldButotn: UIButton?

        for (i,string) in titles.enumerated() {
            var titW = string.yi_getWidth(font ?? QYFont(14))
            let titH = string.yi_getHeight(font ?? QYFont(14), fixedWidth: titW)
            titW = lineWidth ?? titW
            let button = UIButton().yi_then({
                $0.yi_title = string
                $0.yi_titleColor = normalColor ?? QY33Color
                $0.yi_titleFont = font ?? QYFont(14)
                $0.yi_selectedColor = selectColor
                $0.tag = i
                $0.addTarget(self, action: #selector(allClick(_:)), for: .touchUpInside)
                topScrollView.addSubview($0)
            })
            if i == 0 {
                button.isSelected = true
                button.snp.makeConstraints({
                    $0.left.equalTo(spacing)
                    $0.top.bottom.centerY.equalToSuperview()
                    $0.width.equalTo(uniform)
                })
            } else {
                if i == titles.count - 1 {
                    button.snp.makeConstraints({
                        $0.left.equalTo(oldButotn!.snp.right).offset(spacing)
                        $0.right.equalTo(spacing * -1)
                        $0.top.bottom.centerY.equalToSuperview()
                        $0.width.equalTo(uniform)
                    })
                } else {
                    button.snp.makeConstraints({
                        $0.left.equalTo(oldButotn!.snp.right).offset(spacing)
                        $0.top.bottom.centerY.equalToSuperview()
                        $0.width.equalTo(uniform)
                    })
                }
            }
            if i == 0 {
                lineView.snp.makeConstraints({
                    $0.centerX.equalTo(button.snp.centerX)
                    $0.centerY.equalTo(button.snp.centerY).offset(titH / 2 + (lineSpacing ?? 1.5))
                    $0.width.equalTo(titW)
                    $0.height.equalTo(1)
                })
            }
            buttons?.append(button)
            oldButotn = button
        }
        clickBlock?(titles.first ?? "",0)
    }
    @objc func allClick(_ sender: UIButton) {
        var titW = sender.titleLabel?.text?.yi_getWidth(QYFont(14))
        guard let titH = sender.titleLabel?.text?.yi_getHeight(QYFont(14), fixedWidth: titW ?? 100) else { return }
        titW = lineWidth ?? titW
        buttons?.forEach({ btn in
            btn.isSelected = false
        })
        sender.isSelected = true
        lineView.snp.remakeConstraints({
            $0.centerX.equalTo(sender.snp.centerX)
            $0.centerY.equalTo(sender.snp.centerY).offset(titH / 2 + (lineSpacing ?? 1.5))
            $0.width.equalTo(titW!)
            $0.height.equalTo(1)
        })
        let btnCenterX = sender.center.x
        var scrollX = btnCenterX - topScrollView.bounds.width * 0.5
        if scrollX < 0 {
            scrollX = 0
        }
        if scrollX > topScrollView.contentSize.width - topScrollView.bounds.width {
            scrollX = topScrollView.contentSize.width - topScrollView.bounds.width
        }
        topScrollView.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
        clickBlock?(sender.titleLabel?.text ?? "",sender.tag)
    }
    ///标题
    public lazy var topScrollView: UIScrollView = {
        return UIScrollView().yi_then({
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isUserInteractionEnabled = true
            $0.contentSize = .init(width: QYScreenWidth, height: QYRatio(41))
        })
    }()
    
    public lazy var lineView: UIView = {
        return UIView().yi_then({
            $0.backgroundColor = .blue
        })
    }()
}
