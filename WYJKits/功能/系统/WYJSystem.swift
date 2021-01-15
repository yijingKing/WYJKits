/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

open class WYJSystem: NSObject {
    ///是否编辑,默认false
    public var allowsEditing: Bool?
    
    public var photoBlock: ((UIImage)->())?
    
    //MARK: --- 拨打电话
    ///拨打电话
    public class func openPhone(_ phone: String,
                            _ completion: ((Bool) -> Void)? = nil) {
        if let url = URL(string: "tel://" + phone),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    //MARK: --- 打开设置
    ///打开设置
    public class func openSettings(_ completion: ((Bool) -> Void)? = nil) {
        if let openURL = URL(string: UIApplication.openSettingsURLString) {
            if  UIApplication.shared.canOpenURL(openURL) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(openURL, options: [:],completionHandler: {(success) in})
                } else {
                    UIApplication.shared.openURL(openURL)
                }
            }
        }
    }
    
    ///打开相册
    public func invokeSystemPhoto() -> Void {
        WYJPermissionsDetection.isOpenAlbumService { [weak self](b) in
            if b {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                if let isEdi = self?.allowsEditing {
                    imagePickerController.allowsEditing = isEdi
                }
                if #available(iOS 11.0, *) {
                    UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
                }
                UIApplication.shared.keyWindow?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
            } else {
                WYJPermissionsDetection.OpenPermissionsSetting()
                WYJLog("无权限打开相册")
            }
        }
        
    }
    ///打开相机
    public func invokeSystemCamera() -> Void {
        WYJPermissionsDetection.isOpenCaptureDeviceService { [weak self](b) in
            
            if b {
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
            } else {
                WYJPermissionsDetection.OpenPermissionsSetting()
                WYJLog("无权限打开相机")
            }
        }
    }
}
//MARK: ------- 打开相机相册
extension WYJSystem: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK: -------UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        ///原图
        guard let orignalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        ///编辑后的图片
        let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(orignalImg, self, nil, nil)
        }
        picker.dismiss(animated: true) {
            if let block = self.photoBlock {
                if let img = editedImg {
                    block(img)
                } else {
                    block(orignalImg)
                }
            }
        }
    }
}
