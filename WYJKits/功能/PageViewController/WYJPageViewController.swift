/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

///分页控制器
open class WYJPageViewController: WYJBaseViewController {
    private var currentIndex: Int = 0
    public var page_normalColor: UIColor? {
        willSet {
            selectView.normalColor = newValue ?? WYJ33Color
        }
    }
    public var page_selectColor: UIColor? {
        willSet {
            selectView.selectColor = newValue ?? .blue
        }
    }
    public var page_font: UIFont? {
        willSet {
            selectView.font = newValue ?? WYJFont(14)
        }
    }
    public var page_titleHeight: CGFloat? {
        willSet {
            selectView.snp.removeConstraints()
            selectView.snp.makeConstraints({
                $0.top.equalTo(WYJStatusAndNavHeight)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(WYJRatio(newValue ?? 0))
            })
            pageViewController.view.frame = CGRect(x: 0, y: WYJStatusAndNavHeight + WYJRatio(newValue ?? 0), width: view.frame.width, height: view.frame.height - WYJRatio(newValue ?? 0) - WYJStatusAndNavHeight)
        }
    }
    public var page_lineColor: UIColor? {
        willSet {
            selectView.lineView.backgroundColor = newValue ?? .blue
        }
    }
    public var page_lineSpacing: CGFloat? {
        willSet {
            selectView.lineSpacing = newValue
        }
    }
    public var page_lineWidth: CGFloat? {
        willSet {
            selectView.lineWidth = newValue
        }
    }
    
    fileprivate var selectView: WYJSelectView!
    ///分页
    fileprivate lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing:0])
        return page.yi.then({
            $0.view.frame = CGRect(x: 0, y: WYJStatusAndNavHeight + WYJRatio(41), width: view.frame.width, height: view.frame.height - WYJRatio(41) - WYJStatusAndNavHeight)
            $0.delegate = self
            $0.dataSource = self
            view.addSubview($0.view)
            addChild($0)
        })
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        selectView = WYJSelectView()
        view.addSubview(selectView)
        selectView.snp.makeConstraints({
            $0.top.equalTo(WYJStatusAndNavHeight)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(WYJRatio(41))
        })
    }
    
    public func createPage(_ titles: Array<String>,_ spacing: Float? = nil,_ uniform: Bool = true,_ block: ((String,Int,UIViewController)->())?) {
        var uni: Float?
        if titles.count < 4 && uniform {
            uni = Float(WYJScreenWidth / titles.count)
        }
        selectView.create(titles, spacing ?? 0, uni ?? 0)
        selectView.clickBlock = {[weak self] in
            WYJLog($0 + "\($1)")
            if let vc = self?.viewControllers?[$1] {
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
    
    public var viewControllers: Array<UIViewController>? {
        willSet {
            if let vc = newValue?.first {
                pageViewController.setViewControllers([vc], direction: .reverse, animated: false, completion: nil)
            }
        }
            
    }
    
}

extension WYJPageViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    ///前一页
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let vcs = viewControllers {
            let vs = vcs as NSArray
            var index = vs.index(of: viewController)
            if index == 0 || index == NSNotFound {
                return nil
            }
            index -= 1
            return viewControllers?[index]
        }
        return nil
    }
    ///后一页
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vcs = viewControllers {
            let vs = vcs as NSArray
            var index = vs.index(of: viewController)
            if index == vs.count - 1 || index == NSNotFound {
                return nil
            }
            index += 1
            return viewControllers?[index]
        }
        return nil
        
    }
    ///将要滑动切换的时候
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first,let vcs = viewControllers {
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

public class WYJSelectView: UIView {
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
                $0.height.equalTo(WYJRatio(newValue ?? 0))
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
            var titW = string.yi.getWidth(font ?? WYJFont(14))
            let titH = string.yi.getHeight(font ?? WYJFont(14), fixedWidth: titW)
            titW = lineWidth ?? titW
            let button = UIButton().yi.then({
                $0.yi.title(string)
                $0.yi.titleColor(normalColor ?? WYJ33Color)
                $0.yi.titleFont(font ?? WYJFont(14))
                $0.yi.selectedColor(selectColor)
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
        var titW = sender.titleLabel?.text?.yi.getWidth(WYJFont(14))
        guard let titH = sender.titleLabel?.text?.yi.getHeight(WYJFont(14), fixedWidth: titW ?? 100) else { return }
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
        return UIScrollView().yi.then({
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isUserInteractionEnabled = true
            $0.contentSize = .init(width: WYJScreenWidth, height: WYJRatio(41))
        })
    }()
    
    public lazy var lineView: UIView = {
        return UIView().yi.then({
            $0.backgroundColor = .blue
        })
    }()
}
