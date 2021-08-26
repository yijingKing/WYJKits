



import UIKit
import LLSegmentViewController

class SimpDemoViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSegmentedConfig()
    }
}

extension SimpDemoViewController{
    func loadSegmentedConfig() {
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }

    func layoutContentView() {
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 44),offset:0)
        self.relayoutSubViews()
    }

    func loadCtls() {
        let titles = ["螃蟹", "麻辣小龙虾", "苹果", "营养胡萝卜", "葡萄", "美味西瓜", "香蕉", "香甜菠萝", "鸡肉", "鱼", "海星"];
        var ctls = [UIViewController]()
        for title in titles {
            let ctl = ViewController()
//            ctl.showTableView = false
            ctl.title = title
            ctls.append(ctl)
        }
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.selectedColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1)
        itemStyle.unSelectedColor = UIColor.init(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
        itemStyle.selectedTitleScale = 1
        itemStyle.titleFontSize = 15
        itemStyle.extraTitleSpace = 10
//        itemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)//如果不指定是自动适配的
        //这里可以继续增加itemStyle的其他配置项... ...
        
//        segmentCtlView.backgroundColor = UIColor.white
//        segmentCtlView.separatorLineShowEnabled = true //间隔线显示，默认不显示
        //还有其他配置项：颜色、宽度、上下的间隔...

        segmentCtlView.bottomSeparatorStyle = (1,UIColor.red) //分割线:默认透明色
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 11)//横杆宽度:有默认值
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 0)//横杆位置:有默认值
        segmentCtlView.indicatorView.shapeStyle = .custom //形状样式:有默认值
        var segmentedCtlStyle = LLSegmentedControlStyle()
        segmentedCtlStyle.itemSpacing = 30
        segmentedCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self  //ItemView和ItemViewStyle要统一对应
        segmentedCtlStyle.itemViewStyle = itemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentedCtlStyle)
    }
}

