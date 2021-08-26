/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

// MARK:- 基本的扩展
public extension WYJProtocol where T: UITableViewCell {
    
    // MARK: 返回cell所在的UITableView
    /// 返回cell所在的UITableView
    /// - Returns: cell 所在的UITableView
    func superTableView() -> UITableView? {
        for view in sequence(first: obj.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView  {
                return tableView
            }
        }
        return nil
    }
    
    // MARK: 标识符
    var identifier: String {
        get {
            let classStr = NSStringFromClass(T.self)
            // 获取类名
            return classStr.components(separatedBy: ".").last!
        }
    }
    
}
