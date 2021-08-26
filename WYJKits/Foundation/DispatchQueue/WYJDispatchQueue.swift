/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation

public extension WYJProtocol where T: DispatchQueue {
    // MARK: - 延时执行
    typealias Task = (_ cancel: Bool) -> Void
    
    @discardableResult
    ///延迟
    func after(_ time: TimeInterval,_ task: @escaping()->()) ->  Task? {
        
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
    func cancel(_ task: Task?) {
        task?(true)
    }
    
}
public typealias WYJTask = () -> Void
public extension WYJProtocol where T == DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /// 函数只被执行一次
    /// - Parameters:
    ///   - token: 函数标识
    ///   - block: 执行的闭包
    /// - Returns: 一次性函数
    static func once(token: String, block: () -> ()) {
        if _onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        _onceTracker.append(token)
        block()
    }
    
    /// 异步做一些任务
    /// - Parameter JKTask: 任务
    @discardableResult
    static func async(_ task: @escaping WYJTask) -> DispatchWorkItem {
        return _asyncDelay(0, task)
    }
    
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - JKTask: 异步任务
    ///   - mainJKTask: 主线程任务
    @discardableResult
    static func async(_ task: @escaping WYJTask, _ mainTask: @escaping WYJTask) -> DispatchWorkItem{
        return _asyncDelay(0, task, mainTask)
    }
    
    /// 异步延迟(子线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter JKTask: 延迟的block
    @discardableResult
    static func asyncDelay(_ seconds: Double, _ task: @escaping WYJTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter JKTask: 延迟的block
    /// - Parameter mainJKTask: 延迟的主线程block
    @discardableResult
    static func asyncDelay(_ seconds: Double,
                            _ task: @escaping WYJTask,
                        _ mainTask: @escaping WYJTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }
    
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - JKTask: 任务
    ///   - mainJKTask: 任务
    /// - Returns: DispatchWorkItem
    fileprivate static func _asyncDelay(_ seconds: Double,
                                         _ task: @escaping WYJTask,
                                     _ mainTask: WYJTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}

public extension DispatchQueue {
    static var `default`: DispatchQueue { return DispatchQueue.global(qos: .default) }
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
    ///返回主线程
    class func getMainAsync(_ bl: @escaping ()->()) {
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
