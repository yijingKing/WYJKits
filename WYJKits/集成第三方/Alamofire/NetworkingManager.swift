//
//  APIProvider.swift
//  ShopProject
//
//  Created by 李霆 on 2020/9/14.
//  Copyright © 2020 mziyuting. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol ParamType: Codable {
    var param: [String: Any]? { get }
}
extension ParamType {
    var param: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data) else { return nil }
        return json as? [String: Any]
    }
}

protocol APIManager: TargetType {
    associatedtype Param: ParamType
    associatedtype ResponseType: Codable
    var param: Param? { get }
}

extension APIManager {
    
// 遵循 TargetType 代理 实现方法
    var headers: [String : String]? {
        return ["phoneType": "ios", "xVersion": "1.0", "xPlatform": "2"];
    }
    
    //服务器地址
    public var baseURL: URL {
         return URL(string: "https://pre-gdw-api.mangdehaowu.com/api/app/")!
    }

    var path: String {
        return "index/get/box/list"
    }

    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: (param?.param)!, encoding: URLEncoding.default)
    }
}

///return ["isIndex": "1"]
struct ListAPI:APIManager {
    
    struct Param: ParamType {
        var param: [String : Any]? {
            return ["isIndex": "1"]
        }
    }
   
    var param: Param?
    
    typealias ResponseType = [BoxModel]
    
}

struct BoxModel: Codable {
    
    /// 天天拆盒子金额
    var daydayOpenBoxPrice: Decimal?
    
    /// 打折金额
    var discount: Decimal?
    
    /// 盒子折后价
    var discountPrice: Decimal?
    
    /// 盒子关联商品图
    var goodsIcons: [String]?
    
    /// 盒子卡片信息
    var hadCardMessage: String?
    
    /// 盒子封面
    var icon: String?
    
    /// 盒子极速版icon
    var iconIos: String?
    
    /// 盒子id
    var id: Int?
    
    /// 该盒子是否能开
    var isCanOpen: Bool?
    
    /// 是否天天拆盒子
    var isDayDayOpenBox: String?
    
    /// 是否特殊（至尊）盒子
    var isSpecialBox: Bool?
    
    var levelList: [BoxLevelModel]?
    
    /// 登记对应返回信息
    var levelReturnMsg: String?
    
    /// 最高折扣
    var maxDiscount: Decimal?
    
    /// 盒子名称
    var name: String?
    
    /// 盒子价格
    var price: Decimal?
    
    /// 盒子产物图
    var productImg: String?
    
}


struct BoxLevelModel: Codable {
    
    /// 展示奖项概率字符串
    var percent: String?
    
    /// 奖项等级
    var prizeRank: String?
    
    /// 级别图标
    var prizeRankIcon: String?
    
    /// 展示奖项概率
    var showProbability: Decimal?
}


struct ResponseObject<T:Codable>: Codable {
    
    var code: Int?
    
    var message: String?
    
    var result: T?
        
    
    var error: String?
    
}

extension APIManager {
    
    func request(success: ((ResponseType)->())?, failure:((Error) -> Void)?) {
        let provider = MoyaProvider<Self>()
        // Moya 提供最原始的请求方式，响应的数据是二进制
        provider.request(self ){ result in
            // do something with the result
            switch result {
            case let .success(response):
                do {
                    let obj = try JSONDecoder().decode(ResponseObject<ResponseType>.self, from: response.data)
                    print("text = \(obj)")
//                    if obj.code == 0 {
//                        completion(.success(obj.result))
//                    }else{
//                        adapter(obj: obj)
//                        completion(.failure(obj))
//                    }
                } catch {
//                    completion(.failure(error))
                }
                   
                break
            case .failure(_):
                print("")
            }
        }
    }
}
