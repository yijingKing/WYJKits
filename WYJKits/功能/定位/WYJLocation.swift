/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import CoreLocation
 
typealias PositioningClosure = (CLPlacemark) ->()
typealias PositioningClosureError = (String) ->()

///定位
public class WYJLocation: NSObject {
    static let shared = WYJLocation()
    private var clousre: PositioningClosure?
    private var errors: PositioningClosureError?
    var locationManager: CLLocationManager?
    /// 外部初始化的对象调用，执行定位处理。
    func startPositioning(closu: @escaping PositioningClosure,
                          error: @escaping PositioningClosureError ) {
        clousre = closu
        errors  = error
        requestLocationServicesAuthorization()
    }
    
    //MARK: --- 初始化定位
    ///初始化定位
    private func requestLocationServicesAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            case .authorizedAlways,.authorizedWhenInUse:
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.distanceFilter = 10.0
                locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager?.startUpdatingLocation()
            default:
                reportLocationServicesAuthorizationStatus(status: status)
        }
        
    }
    
    //MARK: --- 获取定位代理返回状态进行处理
    private func reportLocationServicesAuthorizationStatus(status:CLAuthorizationStatus) {
        if status == .notDetermined {
            // 未决定,继续请求授权
            requestLocationServicesAuthorization()
        } else if (status == .restricted) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alterSetting()
        } else if (status == .denied) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alterSetting()
        }
    }
    
    private func alterSetting() {
        let alertVC = UIAlertController.init(title: "定位服务未开启,是否前往开启?", message: "请进入系统[设置]->[隐私]->[定位服务]中打开开关，并允许使用定位服务", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (ale) in
            let url = URL(string: UIApplication.openSettingsURLString)
            if let openURL = url {
                if  UIApplication.shared.canOpenURL(openURL) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(openURL, options: [:],completionHandler: {(success) in})
                    } else {
                        UIApplication.shared.openURL(openURL)
                    }
                }
            }
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (ale) in
            
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        NSObject.init().yi.getTopViewController()?.present(alertVC, animated: true, completion: nil)
    }
}
 
extension WYJLocation: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last ?? CLLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self](placemarks, error) in
            guard let _ = error else {
                if let place = placemarks?[0],let strongSelf = self {
                    strongSelf.locationManager?.stopUpdatingLocation()
                    // 国家 省  市  区  街道  名称  国家编码  邮编
    //                let country = place.country ?? ""
    //                let administrativeArea = place.administrativeArea ?? ""
    //                let locality = place.locality ?? ""
    //                let subLocality = place.subLocality ?? ""
    //                let thoroughfare = place.thoroughfare ?? ""
    //                let name = place.name ?? ""
    //                let isoCountryCode = place.isoCountryCode ?? ""
    //                let postalCode = place.postalCode ?? ""
    //                let addressLines =  administrativeArea + locality + subLocality + thoroughfare + name
                    strongSelf.clousre?(place)
                }
                return
            }
            self?.errors?("No placemarks!")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        reportLocationServicesAuthorizationStatus(status: status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
    }
}

