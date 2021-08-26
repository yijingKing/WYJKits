/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

// MARK:- 基本的扩展
public extension Timer {
    
    // MARK: 构造器创建定时器
    /// 构造器创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的block
    convenience init(safeTimerWithTimeInterval timeInterval: TimeInterval, repeats: Bool, block: @escaping ((Timer) -> Void)) {
        if #available(iOS 10.0, *) {
            self.init(timeInterval: timeInterval, repeats: repeats, block: block)
            return
        }
        self.init(timeInterval: timeInterval, target: Timer.self, selector: #selector(Timer.timerCB(timer:)), userInfo: block, repeats: repeats)
    }
    
    // MARK: 类方法创建定时器
    ///  创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - repeats: 是否重复执行
    ///   - block: 执行代码的block
    /// - Returns: 返回 Timer
    @discardableResult
    static func scheduledSafeTimer(timeInterval: TimeInterval, repeats: Bool, block: @escaping ((Timer) -> Void)) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerCB(timer:)), userInfo: block, repeats: repeats)
    }

    // MARK: C语言的形式创建定时器(创建后立即执行一次)
    /// C语言的形式创建定时器
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - handler: 定时器的回调
    /// - Returns: 返回 Timer
    @discardableResult
    static func runThisEvery(timeInterval: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer? {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, timeInterval, 0, 0, handler) else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }
}

// MARK:- 私有的方法
public extension Timer {
    @objc fileprivate class func timerCB(timer: Timer) {
        guard let cb = timer.userInfo as? ((Timer) -> Void) else {
            timer.invalidate()
            return
        }
        cb(timer)
    }
}

public class WYJTimer {
    // MARK: 定时器状态
    public enum State: Int {
        case none = 100
        // 初始化
        case initialization
        // 执行中
        case executing
        // 暂停
        case pause
        // 销毁
        case invalidate
    }
    
    // MARK: - 公开属性
    public var tolerance: TimeInterval? {
        didSet {
            if tolerance != oldValue {
                resetTimerProperties()
            }
        }
    }
    /// 参数
    public var userInfo: Any?
    /// 定时器延迟执行的日期
    public var fireDate: Date? {
        return _fireDate
    }
    /// 定时器的状态
    public var state: State {
        return _state
    }
    /// 当前的定时器的状态
    public var isValid: Bool { return _state == .executing }
    // MARK: - 私有属性
    /// 定时器的状态
    private var _state: State = .none
    /// 定时器延迟执行的日期
    private var _fireDate: Date?
    /// 是否重复执行
    private var isRepeats = false
    /// 时间间隔
    private var timeInterval: TimeInterval = 1.0
    /// 监听对象
    private weak var target: NSObjectProtocol?
    /// 方法
    private var selector: Selector?
    /// 回调
    private var timerCallBack: ((WYJTimer) -> Void)?
    /// 定时器
    private var timer: DispatchSourceTimer?
    private let pointer = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    
    init() {}
    
    deinit {
        invalidate()
    }
}

// MARK: - 公开方法
public extension WYJTimer {
    // MARK: 启动定时器
    /// 启动定时器
    func fire() {
        if let _ = timer, (_state == .initialization || _state == .pause) {
            _fireDate = Date()
            timer?.resume()
            _state = .executing
        }
    }
    
    // MARK: 暂停定时器
    /// 暂停定时器
    func pause() {
        if let _ = timer, _state == .executing {
            _state = .pause
        }
    }
    
    // MARK: 销毁定时器
    /// 销毁定时器
    func invalidate() {
        // 如果它已经失效，原子操作检查。防止dispatch_sync死锁。
        if !OSAtomicTestAndSetBarrier(7, pointer) {
            if let t = timer, _state != .invalidate {
                t.cancel()
                timer = nil
                timerCallBack = nil
                _state = .invalidate
            }
            timerCall()
        }
    }
}

// MARK: - 一、初始化定时器方法(普通方式)
public extension WYJTimer {
    // MARK: 1.1、便利初始化器：初始化定时器
    /// 便利初始化器：初始化定时器
    /// - Parameters:
    ///   - ti: 定时器间隔 默认 1s
    ///   - aTarget: 调用者
    ///   - aSelector: 调用方法
    ///   - userInfo: 调用附加信息 默认 nil
    ///   - yesOrNo: 是否重复 默认  false
    convenience init(timeInterval ti: TimeInterval = 1.0, target aTarget: NSObjectProtocol, selector aSelector: Selector, userInfo: Any? = nil, repeats yesOrNo: Bool = false) {
        self.init()
        timeInterval = ti
        target = aTarget
        selector = aSelector
        self.userInfo = userInfo
        isRepeats = yesOrNo
        initTimer()
    }
    
    // MARK: 1.2、类方法初始化定时器 - 自动开启定时器
    /// 类方法初始化定时器 - 自动开启定时器
    /// - Parameters:
    ///   - ti: 定时器间隔 默认 1s
    ///   - aTarget: 调用者
    ///   - aSelector: 调用方法
    ///   - userInfo: 调用附加信息 默认 nil
    ///   - yesOrNo: 是否重复 默认 false
    /// - Returns: 已启动的timer
    static func scheduledTimer(timeInterval ti: TimeInterval = 1.0, target aTarget: NSObjectProtocol, selector aSelector: Selector, userInfo: Any? = nil, repeats yesOrNo: Bool = false) -> WYJTimer {
        let timer = WYJTimer()
        timer.timeInterval = ti
        timer.target = aTarget
        timer.selector = aSelector
        timer.userInfo = userInfo
        timer.isRepeats = yesOrNo
        timer.initTimer()
        timer.fire()
        return timer
    }
    
    // MARK: 1.3、便利初始化定时器（有队列）
    /// - Parameters:
    ///   - interval: 定时器间隔 默认 1s
    ///   - repeats: 是否重复 默认 false
    ///   - queue: 调用队列 默认 nil 全局队列
    ///   - block: 回调
    convenience init(timeInterval interval: TimeInterval = 1.0, repeats: Bool = false, queue: DispatchQueue? = nil, block: @escaping (WYJTimer) -> Void) {
        self.init()
        timeInterval = interval
        self.timerCallBack = block
        isRepeats = repeats
        initTimer(queue)
    }
    
    // MARK: 1.4、类方法初始化定时器（有队列）- 自动开启定时器
    /// 类方法初始化定时器（有队列）- 自动开启定时器
    /// - Parameters:
    ///   - interval: 定时器间隔 默认 1s
    ///   - repeats: 是否重复 默认 false
    ///   - queue: 调用队列 默认 nil 全局队列
    ///   - block: 回调
    /// - Returns: 已启动的timer
    static func scheduledTimer(timeInterval interval: TimeInterval = 1.0, repeats: Bool = false, queue: DispatchQueue? = nil, block: @escaping (WYJTimer) -> Void) -> WYJTimer {
        let timer = WYJTimer.init()
        timer.timeInterval = interval
        timer.timerCallBack = block
        timer.isRepeats = repeats
        timer.initTimer(queue)
        timer.fire()
        return timer
    }
}

// MARK:- 二、延迟执行的定时器
public extension WYJTimer {
    
    // MARK: 2.1、便利初始化定时器(可设置延迟执行日期)
    /// 便利初始化定时器(可设置延迟执行日期)
    /// - Parameters:
    ///   - date: 启动时间
    ///   - ti: 定时器间隔 默认 1S
    ///   - t: 调用者
    ///   - s: 调用方法
    ///   - ui: 调用其他信息 默认 nil
    ///   - rep: 是否重复 默认 false
    convenience init(fireAt date: Date, interval ti: TimeInterval = 1.0, target t: NSObjectProtocol, selector s: Selector, userInfo ui: Any? = nil, repeats rep: Bool = false) {
        self.init()
        _fireDate = date
        timeInterval = ti
        isRepeats = rep
        self.target = t
        self.selector = s
        initTimer()
    }
    
    // MARK: 2.2、便利初始化定时器(有队列，可设置延迟执行日期)
    /// 便利初始化定时器(有队列，可设置延迟执行日期)
    /// - Parameters:
    ///   - date: 启动时间
    ///   - interval: 定时器间隔 默认 1s
    ///   - repeats: 是否重复 默认 false
    ///   - queue: 调用队列 默认 nil 全局队列
    ///   - block: 回调
    convenience init(fire date: Date, interval: TimeInterval = 1.0, repeats: Bool, queue: DispatchQueue? = nil, block: @escaping (WYJTimer) -> Void) {
        self.init()
        _fireDate = date
        timeInterval = interval
        isRepeats = repeats
        self.timerCallBack = block
        initTimer(queue)
    }
}

// MARK: - 私有方法
private extension WYJTimer {
    // MARK: 初始化定时器
    /// 初始化定时器
    /// - Parameter queue: 执行队列
     func initTimer(_ queue: DispatchQueue? = nil) {
        timer = DispatchSource.makeTimerSource(queue: queue)
        _state = .initialization
        resetTimerProperties()
        timer?.setEventHandler(handler: {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.timerCall()
        })
        if let f = fireDate {
            (queue ?? DispatchQueue.global()).asyncAfter(deadline: .now() + f.timeIntervalSinceNow) {
                self.fire()
            }
        }
    }
    
    // MARK: 重置定时器属性
    /// 重置定时器属性
    func resetTimerProperties() {
        timer?.schedule(deadline: .now(), repeating: (isRepeats ? .milliseconds(Int(timeInterval * 1000)) : .never), leeway: .milliseconds(Int(tolerance ?? (timeInterval / 2) * 1000)))
    }
    
    // MARK: 定时器回调
    /// 定时器回调
    private func timerCall() {
        // 检查定时器是否已经失效。
        if  OSAtomicAnd32OrigBarrier(1, pointer) != 0 {
            return
        }
        if _state == .pause {
            return
        }
        if timerCallBack != nil {
            timerCallBack?(self)
        } else if let t = target, let s = selector {
            if let u = userInfo {
                DispatchQueue.main.async {
                    t.perform(s, with: u)
                }
            } else {
                DispatchQueue.main.async {
                    t.perform(s)
                }
            }
        }
    }
}
