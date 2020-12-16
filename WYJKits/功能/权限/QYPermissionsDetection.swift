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
open class QYPermissionsDetection {
//    private var bluetoohTools: QYCheckBluetooth?
    
    /// 检测是否开启联网
    public class func yi_openEventServiceWithBolck(_ action :@escaping ((Bool)->())) {
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
    public class func yi_isOpenCaptureDeviceService() -> Bool {
        var isOpen = true
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                isOpen = granted
            }
        } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            isOpen = false
        }
        return isOpen
    }
    
    // MARK: - 检测是否开启相册
    /// 检测是否开启相册
    public class func yi_isOpenAlbumService() -> Bool {
        var isOpen = true
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    isOpen = true
                } else if status == .denied || status == .restricted {
                    isOpen = false
                } else {
                    isOpen = false
                }
            })
        } else if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            isOpen = false
        }
        
        return isOpen
    }
    
    // MARK: - 跳转系统设置界面
    ///跳转系统设置界面
    public class func yi_OpenPermissionsSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)
        let alertController = UIAlertController(title: "访问受限",
                                                message: "点击“设置”，允许访问权限",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
            (action) -> Void in
            if let openURL = url {
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
//extension QYPermissionsDetection {
    // MARK: - 检测是否开启定位
    /// 检测是否开启定位
//    public class func yi_isOpenLocationService() -> Bool {
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
//extension QYPermissionsDetection {
//    /// 检测是否开启麦克风
//    public class func yi_openRecordService() -> Bool {
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
//extension QYPermissionsDetection {
//    // MARK: - 检测是否开启蓝牙
//    /// 检测是否开启蓝牙
//    public class func yi_openBluetoothWithBlock(action:@escaping ((Bool,QYAuthorizationState)->())) {
//        let ble = QYCheckBluetooth()
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
//public enum QYAuthorizationState : Int {
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
//private class QYCheckBluetooth: NSObject ,CBCentralManagerDelegate {
//    var completionHandler: ((_ state: QYAuthorizationState) -> Void)?
//    var cbcManager: CBCentralManager?
//    var bluetoothQueue: DispatchQueue?
//    /// 获取蓝牙权限
//    func requestBluetoothAuthorization(_ completionHandler: @escaping (_ state: QYAuthorizationState) -> Void) {
//        completionHandler = completionHandler
//        bluetoothQueue = DispatchQueue(label: "ECPrivacyCheckBluetoothQueue")
//        cbcManager = CBCentralManager.init(delegate: self, queue: bluetoothQueue, options: [CBCentralManagerOptionShowPowerAlertKey: NSNumber(value: true)])
//    }
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if completionHandler != nil {
//            if central.state == .resetting {
//                QYLog("正在重置，与系统服务暂时丢失")
//                completionHandler!(QYAuthorizationState.resetting)
//            } else if central.state == .unsupported {
//                QYLog("不支持蓝牙")
//                completionHandler!(QYAuthorizationState.unsupported)
//            } else if central.state == .unauthorized {
//                QYLog("未授权")
//                completionHandler!(QYAuthorizationState.unauthorized)
//            } else if central.state == .poweredOff {
//                QYLog("关闭")
//                completionHandler!(QYAuthorizationState.poweredOff)
//            } else if central.state == .poweredOn {
//                QYLog("开启并可用")
//                completionHandler!(QYAuthorizationState.poweredOn)
//            } else {
//                QYLog("未知状态")
//                completionHandler!(QYAuthorizationState.unknown)
//            }
//        }
//    }
//}
