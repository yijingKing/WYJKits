/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation

public extension DispatchQueue {
    static var `default`: DispatchQueue { return DispatchQueue.global(qos: .`default`) }
    static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }
    
    private static var _onceTracker = [String]()
    class func once(block:()->Void) {
        let token = UUID().uuidString
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    // MARK: - 延时执行
    typealias Task = (_ cancel: Bool) -> Void
    
    @discardableResult
    ///延迟
    func yi_after(_ time: TimeInterval,_ task: @escaping()->()) ->  Task? {
        
        func dispatch_later(block: @escaping()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }

        var closure: (()->Void)? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result;
        
    }
    // MARK: 取消延时执行
    func yi_cancel(_ task: Task?) {
        task?(true)
    }
    ///返回主线程
    class func yi_getMainAsync(_ bl: @escaping ()->()) {
        if Thread.isMainThread {
            bl()
        } else {
            DispatchQueue.main.async(execute: bl)
        }
    }
    
    convenience init(_ str: String) {
        self.init(label: str)
    }
    
}
