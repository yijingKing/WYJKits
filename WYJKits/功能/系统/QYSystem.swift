/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

open class QYSystem: NSObject {
    static let shared = QYSystem()
    ///是否编辑,默认false
    public var allowsEditing: Bool?
    
    public var photoBlock: ((UIImage)->())?
    
    //MARK: --- 拨打电话
    ///拨打电话
    public class func yi_openPhone(_ phone: String,
                            _ completion: ((Bool) -> Void)? = nil) {
        if let url = URL(string: "tel://" + phone),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    //MARK: --- 打开设置
    ///打开设置
    public class func yi_openSettings(_ completion: ((Bool) -> Void)? = nil) {
        if let url = URL.init(string: UIApplication.openSettingsURLString),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    ///打开相册
    public func yi_invokeSystemPhoto() -> Void {
        guard QYPermissionsDetection.yi_isOpenAlbumService() else {
            QYPermissionsDetection.yi_OpenPermissionsSetting()
            QYLog("无权限打开相册")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        if let isEdi = allowsEditing {
            imagePickerController.allowsEditing = isEdi
        }
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    ///打开相机
    public func yi_invokeSystemCamera() -> Void {
        guard QYPermissionsDetection.yi_isOpenCaptureDeviceService() else {
            QYPermissionsDetection.yi_OpenPermissionsSetting()
            QYLog("无权限打开相机")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.mediaTypes = ["public.image"]
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }
}
//MARK: ------- 打开相机相册
extension QYSystem: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK: -------UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        ///原图
        let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        ///编辑后的图片
        let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(orignalImg, self, nil, nil)
        }
        picker.dismiss(animated: true) {[weak self] in
            if let block = self?.photoBlock {
                if let img = editedImg {
                    block(img)
                } else {
                    block(orignalImg)
                }
            }
        }
    }
}
