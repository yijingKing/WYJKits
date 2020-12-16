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
open class QYLocation: NSObject {
    
    public static let shared = QYLocation()
    private var clousre: PositioningClosure?
    private var errors: PositioningClosureError?
    private var locationManager: CLLocationManager?
    private var viewController: UIViewController?
    public var isFirst: Bool = true
    
    /// 外部初始化的对象调用，执行定位处理。
    func startPositioning(_ vc:UIViewController,
                          closu: @escaping PositioningClosure,
                          error: @escaping PositioningClosureError ) {
        self.isFirst = true
        clousre = closu
        errors  = error
        viewController = vc
        if (self.locationManager != nil) && (CLLocationManager.authorizationStatus() == .denied) {
            // 定位提示
            alter(viewController: viewController!)
        } else {
            requestLocationServicesAuthorization()
        }
    }
    
    //MARK: --- 初始化定位
    ///初始化定位
    private func requestLocationServicesAuthorization() {
        
        if (self.locationManager == nil) {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
        }
        
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            let distance: CLLocationDistance = 10.0
            locationManager?.distanceFilter = distance
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    
    //MARK: --- 获取定位代理返回状态进行处理
    private func reportLocationServicesAuthorizationStatus(status:CLAuthorizationStatus) {
        
        if status == .notDetermined {
            // 未决定,继续请求授权
            requestLocationServicesAuthorization()
        } else if (status == .restricted) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alter(viewController: viewController!)
        } else if (status == .denied) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alter(viewController: viewController!)
        }
    }
    
    private func alter(viewController:UIViewController) {
        let alertVC = UIAlertController.init(title: "定位服务未开启,是否前往开启?", message: "请进入系统[设置]->[隐私]->[定位服务]中打开开关，并允许使用定位服务", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (ale) in
            QYPermissionsDetection.yi_OpenPermissionsSetting()
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (ale) in
            
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.viewController?.present(alertVC, animated: true, completion: nil)
    }
}
 
extension QYLocation:  CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        let location = locations.last ?? CLLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
                if self.errors != nil {
                    self.errors!(error?.localizedDescription ?? "")
                    QYLog(error?.localizedDescription)
                }
                return
            }
            if let place = placemarks?[0] {
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
                if self.isFirst {
                    QYLog(place)
                    self.isFirst = false
                    self.clousre!(place)
                }
            } else {
                if self.errors != nil {
                    self.errors!("No placemarks!")
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        reportLocationServicesAuthorizationStatus(status: status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager?.stopUpdatingLocation()
    }
}

