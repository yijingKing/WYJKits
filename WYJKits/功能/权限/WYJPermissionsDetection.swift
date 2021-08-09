/*******************************************************************************
Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import Foundation
import Photos
import CoreTelephony
//import CoreLocation
import AVFoundation
//import CoreBluetooth

///权限
open class WYJPermissionsDetection {
//    private var bluetoohTools: WYJCheckBluetooth?
    
    /// 检测是否开启联网
    public class func isOpenEventServiceWithBolck(_ action :@escaping ((Bool)->())) {
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
                action(false)
            } else {
                action(true)
            }
        }
        let state = cellularData.restrictedState
        if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
            action(false)
        } else {
            action(true)
        }
    }

    // MARK: - 检测是否开启摄像头
    /// 检测是否开启摄像头 (可用)
    public class func isOpenCaptureDeviceService(_ action :@escaping ((Bool)->())) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                action(granted)
            }
        } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            action(false)
        } else {
            action(true)
        }
    }
    
    // MARK: - 检测是否开启相册
    /// 检测是否开启相册
    public class func isOpenAlbumService(_ action :@escaping ((Bool)->())) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    action(true)
                } else if status == .denied || status == .restricted {
                    action(false)
                } else {
                    action(false)
                }
            })
        } else if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            action(false)
        } else {
            action(true)
        }
    }
    
    // MARK: - 跳转系统设置界面
    ///跳转系统设置界面
    public class func OpenPermissionsSetting() {
        let alertController = UIAlertController(title: "访问受限",
                                                message: "点击“设置”，允许访问权限",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
            (action) -> Void in
            if let openURL = URL(string: UIApplication.openSettingsURLString) {
                if  UIApplication.shared.canOpenURL(openURL) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(openURL, options: [:],completionHandler: {(success) in})
                    } else {
                        UIApplication.shared.openURL(openURL)
                    }
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
//extension WYJPermissionsDetection {
    // MARK: - 检测是否开启定位
    /// 检测是否开启定位
//    public class func isOpenLocationService() -> Bool {
//        var isOpen = true
//        if CLLocationManager.authorizationStatus() == .denied {
//            let mana = CLLocationManager()
//            mana.requestAlwaysAuthorization()
//            mana.requestWhenInUseAuthorization()
//            mana.startUpdatingLocation()
//        } else {
//            isOpen = false
//        }
//
//        return isOpen
//    }
//}

// MARK: - 检测是否开启麦克风
//extension WYJPermissionsDetection {
//    /// 检测是否开启麦克风
//    public class func openRecordService() -> Bool {
//        var isOpen = false
//        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
//        if permissionStatus == AVAudioSession.RecordPermission.undetermined {
//            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
//                isOpen = granted
//            }
//        } else if permissionStatus == AVAudioSession.RecordPermission.denied || permissionStatus == AVAudioSession.RecordPermission.undetermined{
//            isOpen = false
//        } else {
//            isOpen = true
//        }
//        return isOpen
//    }
//}

//MARK: --- 蓝牙
//extension WYJPermissionsDetection {
//    // MARK: - 检测是否开启蓝牙
//    /// 检测是否开启蓝牙
//    public class func openBluetoothWithBlock(action:@escaping ((Bool,WYJAuthorizationState)->())) {
//        let ble = WYJCheckBluetooth()
//        ble.requestBluetoothAuthorization { (state) in
//            var isOpen = false
//            if state == .poweredOn {
//                isOpen = true
//            } else {
//                isOpen = false
//            }
//            action(isOpen,state)
//        }
//    }
//}

/// 蓝牙权限状态
//public enum WYJAuthorizationState : Int {
//    ///未知状态
//    case unknown = 0
//    ///正在重置，与系统服务暂时丢失
//    case resetting
//    ///不支持蓝牙
//    case unsupported
//    ///未授权
//    case unauthorized
//    ///关闭
//    case poweredOff
//    ///开启并可用
//    case poweredOn
//}
//private class WYJCheckBluetooth: NSObject ,CBCentralManagerDelegate {
//    var completionHandler: ((_ state: WYJAuthorizationState) -> Void)?
//    var cbcManager: CBCentralManager?
//    var bluetoothQueue: DispatchQueue?
//    /// 获取蓝牙权限
//    func requestBluetoothAuthorization(_ completionHandler: @escaping (_ state: WYJAuthorizationState) -> Void) {
//        completionHandler = completionHandler
//        bluetoothQueue = DispatchQueue(label: "ECPrivacyCheckBluetoothQueue")
//        cbcManager = CBCentralManager.init(delegate: self, queue: bluetoothQueue, options: [CBCentralManagerOptionShowPowerAlertKey: NSNumber(value: true)])
//    }
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if completionHandler != nil {
//            if central.state == .resetting {
//                WYJLog("正在重置，与系统服务暂时丢失")
//                completionHandler!(WYJAuthorizationState.resetting)
//            } else if central.state == .unsupported {
//                WYJLog("不支持蓝牙")
//                completionHandler!(WYJAuthorizationState.unsupported)
//            } else if central.state == .unauthorized {
//                WYJLog("未授权")
//                completionHandler!(WYJAuthorizationState.unauthorized)
//            } else if central.state == .poweredOff {
//                WYJLog("关闭")
//                completionHandler!(WYJAuthorizationState.poweredOff)
//            } else if central.state == .poweredOn {
//                WYJLog("开启并可用")
//                completionHandler!(WYJAuthorizationState.poweredOn)
//            } else {
//                WYJLog("未知状态")
//                completionHandler!(WYJAuthorizationState.unknown)
//            }
//        }
//    }
//}
