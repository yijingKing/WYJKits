/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit
import MJRefresh

public extension WYJProtocol where T: UITableView {
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
    ///下拉
    @discardableResult
    func refreshNormakHeader (_ refreshingBlock: @escaping() -> Void) -> WYJProtocol {
        obj.refreshNormakHeader(refreshingBlock)
        return self
    }
    
    ///动画下拉
    @discardableResult
    func refreshGifHeader (_ refreshingBlock: @escaping() -> Void) -> WYJProtocol {
        obj.refreshGifHeader(refreshingBlock)
        return self
    }
    
    ///上拉
    @discardableResult
    func refreshFooter (_ refreshingBlock: @escaping() -> Void) -> WYJProtocol {
        obj.refreshFooter(refreshingBlock)
        return self
    }
    
    ///提示没有更多的数据
    @discardableResult
    func endRefreshingWithNoMoreData() -> WYJProtocol {
        obj.endRefreshingWithNoMoreData()
        return self
    }
    ///结束刷新状态
    @discardableResult
    func endRefreshing() -> WYJProtocol {
        obj.endRefreshing()
        return self
    }
    ///更新数据并结束刷新
    @discardableResult
    func reloadDataAndEndRefreshing() -> WYJProtocol {
        obj.endRefreshing()
        obj.reloadData()
        return self
    }
}

public extension UITableView {
    fileprivate struct WYJRuntimeKey {
        static let WYJPageKey = UnsafeRawPointer.init(bitPattern: "WYJPageKey".hashValue)
        static let WYJPageNumberKey = UnsafeRawPointer.init(bitPattern: "WYJPageNumberKey".hashValue)
        static let WYJDataCountKey = UnsafeRawPointer.init(bitPattern: "WYJDataCountKey".hashValue)
    }
    ///分页页数
    var page: Int {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.WYJPageKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, WYJRuntimeKey.WYJPageKey!) as? Int ?? 0
        }
    }
    ///分页每页个数
    var pageNumber: Int {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.WYJPageNumberKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, WYJRuntimeKey.WYJPageNumberKey!) as? Int ?? 10
        }
    }
    ///数据个数
    var dataCount: Int? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.WYJDataCountKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, WYJRuntimeKey.WYJDataCountKey!) as? Int
        }
    }
}
//MARK: --- MJRefresh 刷新与加载
public extension UITableView {
    
    ///下拉
    func refreshNormakHeader (_ refreshingBlock: @escaping () -> Void) {
        let header = MJRefreshNormalHeader.init(refreshingBlock: refreshingBlock)
        mj_header = header
    }
    
    ///动画下拉
    func refreshGifHeader (_ refreshingBlock: @escaping () -> Void) {
        let header = MJRefreshGifHeader.init(refreshingBlock: refreshingBlock)
        mj_header = header
    }
    
    ///上拉
    func refreshFooter (_ refreshingBlock: @escaping () -> Void) {
        let footer = MJRefreshBackNormalFooter.init(refreshingBlock: refreshingBlock)
        mj_footer = footer
    }
    
    ///提示没有更多的数据
    func endRefreshingWithNoMoreData(){
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    ///结束刷新状态
    func endRefreshing() {
        mj_header?.endRefreshing()
        mj_footer?.endRefreshing()
        if let _ = mj_footer,let dataCount = dataCount {
            if pageNumber > dataCount {
                endRefreshingWithNoMoreData()
            }
        }
    }
}
