/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import Foundation
import AVFoundation


public enum QYPhotoType {
    ///正常
    case normal
    ///身份证正面
    case front
    ///身份证反面
    case reverse
}
///拍照
open class QYCameraController: QYBaseViewController {
    public var yi_photoType: QYPhotoType?
    public var yi_cameraDidFinishShoot: ((UIImage)->())?
    public var yi_titleText: String?
    
    private var clipImage: UIImage?
    private var isFlashOn: Bool = false
    private lazy var session: AVCaptureSession = {
        let s = AVCaptureSession.init()
        return s
    }()
    private lazy var titleLabel: UILabel = {
        return UILabel().yi_then({
            $0.text = yi_titleText
            $0.textAlignment = .center
            $0.font = QYFont(14)
            $0.textColor = UIColor.white
            $0.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.5)
        })
    }()
    private lazy var device: AVCaptureDevice? = {
        let d = AVCaptureDevice.default(for: AVMediaType.video)
        return d
    }()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let p = AVCaptureVideoPreviewLayer.init(session: session)
        p.frame = UIScreen.main.bounds
        p.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return p
    }()
    private lazy var imageOutput: AVCapturePhotoOutput = {
        let d = AVCapturePhotoOutput.init()
        return d
    }()
    fileprivate lazy var floatingView: QYFloatingView = {
        let v = QYFloatingView(frame: view.bounds)
        v.frame = view.bounds
        v.photoType = yi_photoType
        return v
    }()
    private lazy var photoButton: UIButton = {
        return UIButton().yi_then({
            $0.yi_backgroundImage = QYFloatingView.bundledImage(named: "photo")
            $0.addTarget(self, action: #selector(shutterCamera(btn:)), for: .touchUpInside)
        })
    }()
    private lazy var cancleButton: UIButton = {
        return UIButton().yi_then({
            $0.yi_backgroundImage = QYFloatingView.bundledImage(named: "closeButton")
            $0.addTarget(self, action: #selector(cancleButtonAction(_ :)), for: .touchUpInside)
        })
    }()
    private lazy var flashButton: UIButton = {
        return UIButton().yi_then({
            $0.yi_backgroundImage = QYFloatingView.bundledImage(named: "cameraFlash")
            $0.addTarget(self, action: #selector(flashOn(btn:)), for: .touchUpInside)
        })
    }()
    
    private lazy var bottomView: UIView = {
        let b = UIView.init()
        b.backgroundColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        b.isHidden = true
        do /**重拍**/ {
            let againBtn = UIButton.init(type: UIButton.ButtonType.custom)
            againBtn.setTitle("重拍", for: UIControl.State.normal)
            againBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            againBtn.addTarget(self, action: #selector(takePhotoAgain), for: UIControl.Event.touchUpInside)
            againBtn.titleLabel?.font = QYFont(16)
            againBtn.titleLabel?.textAlignment = .center
            b.addSubview(againBtn)
            againBtn.snp.makeConstraints({
                $0.left.equalTo(QYRatio(27))
                $0.width.equalTo(QYRatio(77))
                $0.top.bottom.equalToSuperview()
            })
        }
        do /**使用照片**/ {
            let userBtn = UIButton.init(type: UIButton.ButtonType.custom)
            userBtn.setTitle("使用照片", for: UIControl.State.normal)
            userBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            userBtn.addTarget(self, action: #selector(usePhoto), for: UIControl.Event.touchUpInside)
            userBtn.titleLabel?.font = QYFont(16)
            userBtn.titleLabel?.textAlignment = .center
            b.addSubview(userBtn)
            userBtn.snp.makeConstraints({
                $0.right.equalTo(QYRatio(-27))
                $0.width.equalTo(QYRatio(77))
                $0.top.bottom.equalToSuperview()
            })
        }
        return b
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        yi_barStyle = .lightContent
        if isCanUseCamera() {
            setupCamera()
            interfaceLayout()
            configuration()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    @objc private func cancleButtonAction(_ btn: UIButton) {
        yi_goBack()
    }
    
    //MARK: --- UI布局
    ///UI布局
    private func interfaceLayout() {
        view.yi_addSubviews([photoButton,cancleButton,flashButton,bottomView,titleLabel])
        photoButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-QYBottomHeight - QYRatio(27))
        })
        cancleButton.snp.makeConstraints({
            $0.centerY.equalTo(photoButton.snp.centerY)
            $0.left.equalTo(photoButton.snp.right).offset(QYRatio(77))
        })
        flashButton.snp.makeConstraints({
            $0.right.equalTo(photoButton.snp.left).offset(QYRatio(-77))
            $0.centerY.equalTo(photoButton.snp.centerY)
        })
        bottomView.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(-QYBottomHeight)
            $0.height.equalTo(QYRatio(55))
        })
        
        titleLabel.snp.makeConstraints({
            $0.centerX.equalTo(QYRatio(27))
            $0.centerY.equalToSuperview()
        })
    }
    
    //MARK: --- 设置相机
    ///设置相机
    private func setupCamera() {
        if session.canSetSessionPreset(AVCaptureSession.Preset.hd1280x720) {
            session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        }
        if let device = device {
            do {
                try device.lockForConfiguration()
                let input = try? AVCaptureDeviceInput.init(device: device)
                
                if let i = input, session.canAddInput(i) {
                    session.addInput(i)
                }
                device.unlockForConfiguration()
            } catch let error {
                print(error)
            }
        }

        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
        }
        // 开始启动
        session.startRunning()
        view.layer.addSublayer(previewLayer)
        view.addSubview(floatingView)
    }
    
    private func configuration() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(focusGesture(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange(notification:)), name: Notification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
    }
    
    // 点击聚焦
    @objc private func focusGesture(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        focusAtPoint(point: point)
    }
    
    @objc private func subjectAreaDidChange(notification: Notification) {
        if let device = device,device.isFocusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
            do {
                try device.lockForConfiguration()
                device.focusMode = .autoFocus
                let bounds = UIScreen.main.bounds
                let point = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
                focusAtPoint(point: point)
                device.unlockForConfiguration()
            } catch let error as NSError   {
                print(error)
            }
        }
    }
    
    @objc private func focusAtPoint(point: CGPoint) {
        let size = view.bounds.size
        let focusPoint = CGPoint.init(x: point.y/size.height, y: 1-point.x/size.width)
        if let device = device {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                }
                if device.isExposureModeSupported(AVCaptureDevice.ExposureMode.autoExpose) {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .autoExpose
                }
                device.unlockForConfiguration()
            } catch let error {
                print(error)
            }
        }
    }
    // MARK: 拍照
    @objc private func shutterCamera(btn: UIButton) {
        let settings = AVCapturePhotoSettings()
        if settings.availablePreviewPhotoPixelFormatTypes.count > 0 {
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : settings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        imageOutput.capturePhoto(with: settings, delegate: self)
        
        cancleButton.isHidden = true
        flashButton.isHidden = true
        photoButton.isHidden = true
        bottomView.isHidden = false
    }
    
    // MARK::闪光灯
    @objc private func flashOn(btn: UIButton) {
        if let device = device {
            if device.hasTorch {
                do {// 请求独占访问硬件设备
                    try device.lockForConfiguration()
                    if (isFlashOn == false) {
                        device.torchMode = AVCaptureDevice.TorchMode.on
                        isFlashOn = true
                    } else {
                        device.torchMode = AVCaptureDevice.TorchMode.off
                        isFlashOn = false
                    }// 请求解除独占访问硬件设备
                    device.unlockForConfiguration()
                } catch let error as NSError {
                    print("TorchError  \(error)")
                }
                
            } else {
                let alert = UIAlertController.init(title: "提示", message: "您的设备没有闪光设备，不能提供手电筒功能，请检查", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: false, completion: nil)
            }
        }
    }
    //MARK: --- 重拍
    ///重拍
    @objc private func takePhotoAgain() {
        session.startRunning()
        clipImage = nil
        
        cancleButton.isHidden = false
        flashButton.isHidden = false
        photoButton.isHidden = false
        bottomView.isHidden = true
    }
    
    // MARK:使用照片
    /// 使用照片
    @objc private func usePhoto() {
        
        if let cgImg = clipImage?.cgImage { // 修改图片方向
            let newImg = UIImage.init(cgImage: cgImg, scale: 1.0, orientation: UIImage.Orientation.up)
            // (726.0, 462.0)
            print(newImg.size)
            yi_cameraDidFinishShoot?(newImg)
            yi_goBack()
        }
    }
    
    //MARK: --- 权限判断
    ///权限判断
    private func isCanUseCamera() -> Bool {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .restricted || authStatus == .denied {
            let alert = UIAlertController.init(title: "请打开相机权限", message: "请到设置中去允许应用访问您的相机: 设置-隐私-相机", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction.init(title: "不需要", style: UIAlertAction.Style.cancel, handler: nil)
            let okAction = UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default) { (action) in
                QYSystem.yi_openSettings()
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            rootVC?.modalPresentationStyle = .fullScreen
            rootVC?.present(alert, animated: false, completion: nil)
            return false
            
        } else {
            return true
        }
    }
}

extension QYCameraController: AVCapturePhotoCaptureDelegate {
    ///获取到照片
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput,  didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,  previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings:  AVCaptureResolvedPhotoSettings, bracketSettings:   AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("-----error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            if let dataProvider = CGDataProvider(data: dataImage as CFData) {
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)!
                let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
                guard let clipImg = image.dx_clipImageInRect(rect: floatingView.WindowLayer.frame) else { return }
                clipImage = clipImg
                session.stopRunning()
            }
            
        } else {
            print("some error here")
        }
    }
}

fileprivate class QYFloatingView: UIView {
    var photoType: QYPhotoType? {
        willSet {
            switch newValue {
                case .normal:
                    frontImage.isHidden = true
                    reverseImage.isHidden = true
                case .front:
                    frontImage.isHidden = false
                    reverseImage.isHidden = true
                case .reverse:
                    frontImage.isHidden = true
                    reverseImage.isHidden = false
                default:
                break
            }
        }
    }
    lazy var WindowLayer: CAShapeLayer = {
        let windowLayer = CAShapeLayer.init()
        windowLayer.position = layer.position
        windowLayer.cornerRadius = 15
        windowLayer.borderColor = UIColor.white.cgColor
        windowLayer.borderWidth = 2
        return windowLayer
    }()
    
    lazy var frontImage: UIImageView = {
        return UIImageView().yi_then({
            $0.image = QYFloatingView.bundledImage(named: "xuxian")
            $0.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.5)
            $0.contentMode = .scaleAspectFill
        })
    }()
    
    lazy var reverseImage: UIImageView = {
        return UIImageView().yi_then({
            $0.image = QYFloatingView.bundledImage(named: "Page")
            $0.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 0.5)
            $0.contentMode = .scaleAspectFill
        })
    }()
    
    internal class func bundledImage(named name: String) -> UIImage {
        let primaryBundle = Bundle(for: QYCameraController.self)
        if let image = UIImage(named: name, in: primaryBundle, compatibleWith: nil) {
            return image
        } else if
            let subBundleUrl = primaryBundle.url(forResource: "QYResources", withExtension: "bundle"),
            let subBundle = Bundle(url: subBundleUrl),
            let image = UIImage(named: name, in: subBundle, compatibleWith: nil) {
            return image
        }

        return UIImage()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let width: CGFloat = QYRatio(270)
        let height: CGFloat = width * 1.574
        WindowLayer.bounds = CGRect.init(x: 0, y: 0, width: width , height: height)
        layer.addSublayer(WindowLayer)
        // 最里层镂空
        let transparentRoundedRectPath: UIBezierPath = UIBezierPath.init(roundedRect: WindowLayer.frame, cornerRadius: WindowLayer.cornerRadius)
        
        // 最外层背景
        let path = UIBezierPath.init(rect: UIScreen.main.bounds)
        path.append(transparentRoundedRectPath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer.init()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.6
        layer.addSublayer(fillLayer)
        frontImage.isHidden = true
        reverseImage.isHidden = true
        yi_addSubviews([frontImage,reverseImage])
        reverseImage.snp.makeConstraints({
            $0.centerY.equalToSuperview().offset(-height / 2 + QYRatio(72))
            $0.centerX.equalToSuperview().offset(width / 4)
            $0.width.height.equalTo(QYRatio(92))
        })
        frontImage.snp.makeConstraints({
            $0.centerY.equalToSuperview().offset(height / 2 - QYRatio(92))
            $0.centerX.equalToSuperview().offset(QYRatio(20))
            $0.width.equalTo(QYRatio(145))
            $0.height.equalTo(QYRatio(130))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImage {
    
    public func dx_clipImageInRect(rect: CGRect) -> UIImage?{
       
        let widthScale: CGFloat = size.width / QYScreenWidth
        let heightScale: CGFloat = size.height / QYScreenHeight
        
        //其实是横屏的
        let originWidth: CGFloat = rect.size.width
        let originHeight: CGFloat = rect.size.height
        
        let x: CGFloat = (QYScreenHeight - originHeight) * 0.5 * heightScale
        let y: CGFloat = (QYScreenWidth - originWidth) * 0.5 * widthScale
        let width: CGFloat = originHeight * heightScale
        let height: CGFloat = originWidth * widthScale
        
        let r: CGRect = CGRect.init(x: x, y: y, width: width, height: height)
        if let cgImg = cgImage?.cropping(to: r) {
            return UIImage.init(cgImage: cgImg, scale: 1.0, orientation: UIImage.Orientation.right)
        }

        return nil
    }
}
