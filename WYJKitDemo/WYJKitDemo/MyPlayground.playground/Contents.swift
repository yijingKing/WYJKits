//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()



//
//  ViewController.swift
//  Secret
//
//  Created by point on 18/1/9.
//  Copyright © 2018年 dacai. All rights reserved.
//
import UIKit
import SnapKit


private let DCWidth = UIScreen.main.bounds.width //全部的宽
private let DCHeight = UIScreen.main.bounds.height //全部的高

/*  配置项 */
private let labelSize:CGFloat = 17 //字体的大小
private let titleViewMargin:CGFloat = 30 //字间距
private let titleViewHeight:CGFloat = 44 //标题高度
private let titles = ["1111", "2222", "bbbb趣", "hhh女", "值jjjj", "hhh女", "值jjjj"]
private let titlesID = ["100","1000","1000","33","33"]
private let normalColor: UIColor = .blue //文字未选中的颜色
private let selectColor: UIColor = .red //文字选中的颜色
private let average:Bool = false //是否平均分配
private let botoomLineViewHeight:CGFloat = 2 //底线的高
private let botoomLineViewWidth:CGFloat = 50 //底线的宽
private let botoomLineViewColor:UIColor = UIColor.blue  //底线的颜色
private var isForbidScroll:Bool = false //点击禁止滚动
private var half:Bool = false //拖动到一半


class ViewController: UIViewController {
    //标题scroolView
    lazy var titleScrollView : UIScrollView = {
        return UIScrollView()
    }()
    //内容scroolView
    lazy var contentScrollView : UIScrollView = {
        return UIScrollView()
    }()
    //底部线条
    lazy var buttomView : UIView = {
        let buttomView = UIView()
        buttomView.backgroundColor = botoomLineViewColor
        return buttomView
    }()
    //当前布局最后一个label
    private var layoutLastLabel:UILabel = UILabel()
    //当前选择的Label
    var selLabel : UILabel = UILabel()
    //标题数组
    private lazy var titleLabels : [UILabel] = [UILabel]()
    //vc的高度
    private let vcHeight = DCHeight - 20 - titleViewHeight
    private var startOffsetX:CGFloat = 0  //拖拽前的偏移量
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupChildViewController()
        setupUI()
        setUpTitleLabel()
    }
}


// MARK:- 设置UI
extension ViewController {
    
    //加载控制器
    fileprivate func setupChildViewController(){
        for (i,val) in titles.enumerated() {
            let workVc = UIViewController()
            workVc.title = val
            addChild(workVc)
            
            //全部加载
            let offsetX = CGFloat(i) * DCWidth;
            let vc:UIViewController = children[i];
            guard !vc.isViewLoaded else {
                return
            }
            vc.view.frame = CGRect(x:offsetX, y:0,width:DCWidth,height: vcHeight);
            contentScrollView.addSubview(vc.view)
            
        }
    }
    
    //加载UI
    fileprivate func setupUI(){
        //头部
        view.addSubview(titleScrollView)
        view.addSubview(contentScrollView)
        titleScrollView.addSubview(buttomView)
        titleScrollView.frame = CGRect(x: 0, y: 20, width: DCWidth, height: titleViewHeight)
        titleScrollView.showsHorizontalScrollIndicator = false
        titleScrollView.backgroundColor = UIColor.white
        
        //底部
        contentScrollView.frame = CGRect(x: 0, y: titleViewHeight + 20, width: DCWidth, height: DCHeight - titleViewHeight)
        contentScrollView.contentSize = CGSize(width:CGFloat(children.count) * DCWidth, height:0);
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.backgroundColor = UIColor.white
        contentScrollView.delegate = self
        
        
        
    }
    
    //设置Label
    fileprivate func setUpTitleLabel () {
        let count = children.count;
        var labelX:CGFloat = 0.0;
        let labelY:CGFloat = 0.0;
        let labelH:CGFloat = titleViewHeight;
        
        for i in 0 ..< count {
            let vc : UIViewController = children[i]
            let label : UILabel = UILabel()
            label.backgroundColor = UIColor.white
            
            //当前文字的宽度
            var width:CGFloat = 0
            if average {
                //取得最后一个Label的最大X值
                labelX = layoutLastLabel.frame.maxX
                width = DCWidth / CGFloat(count)
                label.frame = CGRect(x:labelX,y: labelY,width: width,height: labelH)
            }else {
                //取得最后一个Label的最大X值
                labelX = layoutLastLabel.frame.maxX + titleViewMargin
                width = DCWidth / CGFloat(count)
//                width = vc.title!.calculateRowWidth(labelSize)
                label.frame = CGRect(x:labelX,y: labelY,width: width,height: labelH)
            }
//            label.backgroundColor = UIColor.randomColor()
            label.text = vc.title;
            label.textColor = normalColor
            label.tag = i;
            label.isUserInteractionEnabled = true
            label.textAlignment =  NSTextAlignment.center
            titleLabels.append(label)
            titleScrollView .addSubview(label)
            layoutLastLabel = label
            
            //建立手势识别器
            let gesture = UITapGestureRecognizer(target: self, action: #selector(titleClick(sender:)))
            //附加识别器到视图
            label.addGestureRecognizer(gesture)
            
            if(i==0) {
                selLabel = label
                let buttomwidth = average ? botoomLineViewWidth : selLabel.frame.width
                buttomView.frame = CGRect(x: 0, y: titleViewHeight - botoomLineViewHeight , width: buttomwidth, height: botoomLineViewHeight)
                buttomView.center.x = (selLabel.center.x)
                titleClick(sender: gesture)
            }
            
            titleScrollView.bringSubviewToFront(buttomView)
            
            
            
        }
        if average {
            titleScrollView.contentSize = CGSize(width: layoutLastLabel.frame.maxX, height: titleViewHeight)
        }else {
            titleScrollView.contentSize = CGSize(width: layoutLastLabel.frame.maxX + titleViewMargin, height: titleViewHeight)
        }
    }
}

// MARK:- 点击事件
extension ViewController {
    
    @objc func titleClick(sender: UITapGestureRecognizer){
        isForbidScroll = true //点击的就不需执行滚动
        half = false
        contentScrollView.isScrollEnabled =  false
        let time: TimeInterval = 0.25
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            contentScrollView.isScrollEnabled =  true
        }
        let selLabel:UILabel = sender.view as! UILabel
        let index = selLabel.tag
        showVc(index: index , selLabel:selLabel)
        selectLabel(label: selLabel)
        let offsetX:CGFloat = CGFloat(index)*DCWidth;
        contentScrollView.contentOffset = CGPoint(x:offsetX,y: 0);
        setupTitleCenter(centerLabel: selLabel)
        resetLabel(index:index)
        let dc = children[index] as! ViewController
//        dc.dcViewWillAppear()
    }
    
    
    func showVc(index:Int , selLabel:UILabel){
        let buttomwidth = average ? botoomLineViewWidth : selLabel.frame.width
        UIView.animate(withDuration: 0.15) {
            buttomView.frame = CGRect(x: 0, y: titleViewHeight - botoomLineViewHeight , width: buttomwidth, height: botoomLineViewHeight)
            buttomView.center.x = selLabel.center.x
        }
    }
    
    
    func selectLabel(label:UILabel){
        selLabel = label;
    }
    
}

// MARK:- 代理事件
extension ViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard startOffsetX != scrollView.contentOffset.x else {
            return
        }
        
        if (isForbidScroll) {
            return
        }
        
        // 1.定义targetIndex/progress
        var targetIndex = 0
        var progress : CGFloat = 0.0
        
        // 2.给targetIndex/progress赋值
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x { // 左滑动
            targetIndex = currentIndex + 1
            if targetIndex > titles.count - 1 {
                targetIndex = titles.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
            if (!half) {
                if scrollView.contentOffset.x >= ( CGFloat(currentIndex) * DCWidth ) +  (DCWidth * 0.5) {
                    let vc = children[currentIndex + 1] as! UIViewController
//                    vc.didViewWillAppear()
                    half = true
                }
            }
        } else { // 右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
            
            if (!half) {
                if scrollView.contentOffset.x <= ( CGFloat(currentIndex - 1) * DCWidth ) +  (DCWidth * 0.5) {
                    let vc = children[currentIndex - 1] as! UIViewController
//                    vc.dc2ViewWillAppear()
                    half = true
                }
            }
            
        }
        
        let targetLabel = titleLabels[targetIndex]
        
        // 2.颜色渐变
//        let deltaRGB = UIColor.getRGBDelta(selectColor,normalColor)
//        let selectRGB = selectColor.getRGB()
//        let normalRGB = normalColor.getRGB()
//        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
//        selLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        //改变下划线
        buttomView.frame.origin.x =   selLabel.frame.minX + (targetLabel.frame.minX - selLabel.frame.minX) * progress
        var ld_frame: CGRect = buttomView.frame
        ld_frame.size.width = selLabel.frame.width + (targetLabel.frame.width - selLabel.frame.width) * progress
        buttomView.frame = ld_frame
        
        
        
        
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { //减速停止
        //点击的时候 并不会走此方法
        if !decelerate { //真正的停下来
            endScrool(scrollView)
        } else {
            scrollView.isScrollEnabled =  false     //松手及执行
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { //将要拖拽的时候
        isForbidScroll = false //开始拖的时候起
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { //已经停止
        //点击的时候 并不会走此方法
        endScrool(scrollView)
        
    }
    
    /* 结束滚动所做的事情 */
    func endScrool(_ scrollView:UIScrollView) {
        
        // 计算滚动到哪一页
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width);
        // 2.把对应的标题选中
        selLabel = titleLabels[index];
        selectLabel(label: selLabel)
        //showVc(index: index ,selLabel: selLabel)
        setupTitleCenter(centerLabel: selLabel)
        resetLabel(index: index)
        scrollView.isScrollEnabled =  true
        half = false
        
    }
    
    func setupTitleCenter(centerLabel:UILabel) {
        // 计算偏移量
        var offsetX = centerLabel.center.x - DCWidth * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        // 获取最大滚动范围
        let maxOffsetX = titleScrollView.contentSize.width - DCWidth;
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        titleScrollView.setContentOffset(CGPoint(x:offsetX, y:0), animated: true)
    }
    
    /* 重置所有按钮 */
    func resetLabel(index:Int) {
        for (i , val)in titleLabels.enumerated() {
            let label = val
            if ( i == index) {
                label.textColor = selectColor;
            }else {
                label.textColor = normalColor;
            }
        }
    }
}
