//
//  File.swift
//  WYJKitDemo
//
//  Created by PZ-IMAC-1 on 2021/8/26.
//  Copyright © 2021 祎. All rights reserved.
//

import Foundation
import CoreLocation

// MARK:- 基本的扩展
public extension WYJProtocol where T == CLLocation {
 
    // MARK: 地理信息反编码
    /// 地理信息反编码
    /// - Parameters:
    ///   - latitude: 精度
    ///   - longitude: 纬度
    ///   - completionHandler: 回调函数
    static func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: completionHandler)
    }
    
    // MARK: 地理信息编码
    /// 地理信息编码
    /// - Parameters:
    ///   - address: 地址信息
    ///   - completionHandler: 回调函数
    static func locationEncode(address: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: completionHandler)
    }
}
