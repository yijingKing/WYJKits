/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/


import Foundation
import Alamofire

public enum WYJUploadFileWay {
    ///图片
    case image
    ///路径
    case path
}

public typealias ErrorBlock = ((WYJJSON)->())?
/// 网络请求
open class WYJAlamofire: NSObject {
    ///主地址
    public var baseURL: String = ""
    ///是否数据输出,默认true
    public var isDataLog: Bool = true
    ///超时时间,默认30秒
    public var timeOut: Double = 30.0
    ///请求头
    public var header: Dictionary<String, String>?
    ///编码
    public var encoding: ParameterEncoding = URLEncoding.default
    ///拦截器
    public var interceptor: RequestInterceptor?
    
    public var successCode: String = "1"
    ///数据获取参数,默认data
    public var data: String = "data"
    ///错误获取参数,默认msg
    public var msg: String = "msg"
    ///code获取参数,默认code
    public var code: Int = 0
    ///code获取参数,默认code
    public var codeS: String = "code"
    
    public var dataRequest: DataRequest?
    ///配置请求参数
    open func configureRequestParameters() { }
}

public extension WYJAlamofire {
    
    //MARK: --- 多方式请求(暂支持get,post)
    ///多方式请求(暂支持get,post)
    final func request(_ httpMethod: HTTPMethod,
                       _ api: String,
                       _ parameters: [String: Any]? = nil,
                       success: ((WYJJSON)->())?,
                       error: ErrorBlock) {
        switch httpMethod {
            case .get:
                get(api, parameters, success: success, error: error)
                break
            case .post:
                post(api, parameters, success: success, error: error)
                break
            default:
                break
        }
    }
    
    //MARK: --- 多方式请求(暂支持get,post)
    ///多方式请求(暂支持get,post)
    final func request<T: WYJCodable>(_ httpMethod: HTTPMethod,
                                      _ api: String,
                                      _ parameters: [String: Any]? = nil,
                                      success: ((T)->())?,
                                      error: ErrorBlock) {
        switch httpMethod {
            case .get:
                get(api, parameters, success: success, error: error)
                break
            case .post:
                post(api, parameters, success: success, error: error)
                break
            default:
                break
        }
    }
    
    /// 通用请求
    /// - Parameters:
    ///   - convertible: 地址
    ///   - method: 方式
    ///   - parameters: 参数
    ///   - headers: 头部
    ///   - encoding: 编码
    ///   - interceptor: 拦截器
    ///   - successB: 成功返回
    ///   - errorB: 失败返回
    final func request(_ convertible: URLConvertible,
                       method: HTTPMethod ,
                       parameters: Parameters? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: HTTPHeaders? = nil,
                       interceptor: RequestInterceptor? = nil,
                       success: ((Any)->())?,
                       error: ((AFError,Data?)->())?) {
        
        let api: String = convertible as? String ?? ""
        dataRequest = AF.request(baseURL + api, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor) { [weak self](URLRequest) in
            guard let strongSelf = self else { return }
            ///超时时间
            URLRequest.timeoutInterval = strongSelf.timeOut
        }
        
        dataRequest?.responseJSON { response in
            
            switch response.result {
                case .success(let result):
                    if self.isDataLog {
                        WYJLog("请求地址--> \(self.baseURL + api)" + "\n请求成功--> \(WYJJSON.init(result).description)")
                    }
                    success?(result)
                    
                case .failure(let err):
                    if self.isDataLog {
                        WYJLog("请求失败 --> error = \(err)")
                        WYJLog("请求地址--> \(self.baseURL + api)" + "\n请求失败 --> --> error = \(err) --> response.data = \(String(describing: response.data))")
                    }
                    error?(err,response.data)
            }
        }
    }
    
    //MARK: --- 上传图片文件
    /// 上传图片文件
    /// - Parameters:
    ///   - api: 地址
    ///   - parameters: 参数
    ///   - fileParam: 文件参数
    ///   - files: 文件数组---->image,path,data
    ///   - progressHandler: 进度
    final func uploadImage(_ api: String,_ parameters: [String: Any]? = nil,
                           fileParam: String,files: [Any],
                           progressHandler: ((Progress) -> ())? = nil,
                           success: ((WYJJSON)->())?,error: ErrorBlock) {
        
        var headers: HTTPHeaders?
        if let h = header {
            headers = HTTPHeaders(h)
        }
        getNerworkingReachability {
            if $0 {
                self.dataRequest = AF.upload(multipartFormData: { multipartFormData in
                    for file in files {
                        switch file {
                            case let image as UIImage:
                                if let data = image.pngData() {
                                    multipartFormData.append(data, withName: fileParam, fileName: Date().yi.toString() + ".jpg", mimeType: "image/jpg/png/jpeg")
                                }
                            case let data as Data:
                                multipartFormData.append(data, withName: fileParam, fileName: Date().yi.toString() + ".jpg", mimeType: "image/jpg/png/jpeg")
                            case let path as String:
                                if let url = URL.init(string: path) {
                                    multipartFormData.append(url, withName: fileParam, fileName: Date().yi.toString() + ".jpg", mimeType: "image/jpg/png/jpeg")
                                }
                            default:
                                break
                        }
                    }
                    if let params = parameters {
                        for key in params.keys {
                            if key == fileParam { break }
                            if let value = params[key] as? String, let data = value.yi.toData() {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                }, to: api, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: self.interceptor, fileManager: FileManager()) { [weak self](URLRequest) in
                    guard let strongSelf = self else { return }
                    ///超时时间
                    URLRequest.timeoutInterval = strongSelf.timeOut
                }.uploadProgress { (progress) in
                    if let b = progressHandler {
                        b(progress)
                    }
                }
                self.dataRequest?.responseJSON { (response) in
                    switch response.result {
                        case .success(let result):
                            let json = WYJJSON.init(result)
                            success?(json)
                        case .failure(let err):
                            self.errorMethod(err, error,response.data)
                    }
                }
            } else {
                self.nerworkingError(error)
            }
        }
    }
    
}

///私有
extension WYJAlamofire {
    ///获取当前网络状态
    private final func getNerworkingReachability(_ block: ((Bool)->())?) {
        let manager = NetworkReachabilityManager.init(host: "www.baidu.com")
        manager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                block?(false)
            case .unknown:
                block?(false)
            case .reachable(.cellular):
                block?(true)
            case .reachable(.ethernetOrWiFi):
                block?(true)
            }
        })
    }
    //MARK: --- get
    ///get
    private func get(_ api: String,
                   _ parameters: [String: Any]? = nil,
                   success: ((WYJJSON)->())?,
                   error: ErrorBlock) {
        
        configureRequestParameters()
        var headers: HTTPHeaders?
        if let h = header {
            headers = HTTPHeaders(h)
        }
        getNerworkingReachability {
            if $0 {
                self.request(api, method: .get, parameters: parameters,
                             encoding: self.encoding, headers: headers,
                             interceptor: self.interceptor) { (result) in
                    let json = WYJJSON.init(result)
                    success?(json)
                } error: { (afError,data) in
                    self.errorMethod(afError, error,data)
                }
            } else {
                self.nerworkingError(error)
            }
        }
    }
    
    ///get
    private func get<T: WYJCodable>(_ api: String,_ parameters: [String: Any]? = nil,
                                  success: ((T)->())?,error: ErrorBlock) {
        configureRequestParameters()
        var headers: HTTPHeaders?
        if let h = header {
            headers = HTTPHeaders(h)
        }
        getNerworkingReachability {
            if $0 {
                self.request(api, method: .get, parameters: parameters,
                             encoding: self.encoding, headers: headers,
                             interceptor: self.interceptor) { (result) in
                    let json = WYJJSON.init(result)
                    if let model = try? T(from: json.description) {
                        success?(model)
                    } else {
                        error?(json)
                    }
                } error: { (afError,data) in
                    self.errorMethod(afError, error,data)
                }
            } else {
                self.nerworkingError(error)
            }
        }
    }
    
    //MARK: --- post
    ///post
    private func post(_ api: String,_ parameters: [String: Any]? = nil,
                    success: ((WYJJSON)->())?,error: ErrorBlock) {
        configureRequestParameters()
        var headers: HTTPHeaders?
        if let h = header {
            headers = HTTPHeaders(h)
        }
        getNerworkingReachability {
            if $0 {
                self.request(api, method: .post, parameters: parameters,
                             encoding: self.encoding, headers: headers,
                             interceptor: self.interceptor) { (result) in
                    let json = WYJJSON.init(result)
                    if json[self.codeS].int == self.code {
                        success?(json)
                    } else {
                        error?(json)
                    }
                } error: { (afError,data) in
                    self.errorMethod(afError, error,data)
                }
            } else {
                self.nerworkingError(error)
            }
        }
    }
    
    ///post
    private func post<T:WYJCodable>(_ api: String,_ parameters: [String: Any]? = nil,
                                  success: ((T)->())?,error: ErrorBlock) {
        configureRequestParameters()
        var headers: HTTPHeaders?
        if let h = header {
            headers = HTTPHeaders(h)
        }
        getNerworkingReachability {
            if $0 {
                self.request(api, method: .post, parameters: parameters,
                             encoding: self.encoding, headers: headers,
                             interceptor: self.interceptor) { [weak self](result) in
                    guard let strongSelf = self else { return }
                    let json = WYJJSON.init(result)
                    if json[strongSelf.codeS].int == strongSelf.code {
                        if let model = try? T(from: json.description) {
                            success?(model)
                        } else {
                            error?(json)
                        }
                    } else {
                        error?(json)
                    }
                } error: { (afError,data) in
                    self.errorMethod(afError, error,data)
                }
            } else {
                self.nerworkingError(error)
            }
        }
    }
    //MARK: --- 错误处理
    ///返回错误处理
    private func errorMethod(_ afError: AFError,_ errorB: ErrorBlock,_ data:Data?) {
        var dec : String?
        switch afError._code {
        case -1009: dec = "网络异常,请检查网络后重试"
        case -1001: dec = "请求超时"
        case -1004: dec = "无法连接到服务器"
        case 13: dec = "无法连接到服务器"
        default:
            if let da = data {
                dec = da.yi.toEncodingString()
            } else {
                dec = afError.errorDescription
            }
        }
        var dic = [String: Any]()
        dic["code"] = afError._code
        dic[msg] = dec
        errorB?(WYJJSON.init(dic))
    }
    
    ///网络错误处理
    private func nerworkingError(_ errorB: ErrorBlock) {
        var dic = [String: Any]()
        dic["code"] = -99999
        dic[msg] = "网络异常,请检查网络后重试"
        if self.isDataLog {
            WYJLog(WYJJSON.init(dic))
        }
        errorB?(WYJJSON.init(dic))
    }
}


