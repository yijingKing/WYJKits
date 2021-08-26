/*******************************************************************************
 Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 ********************************************************************************/


import Foundation
import UIKit
import QuartzCore
import CoreGraphics
import Accelerate
import Photos

// MARK:--- 基本的扩展
public extension WYJProtocol where T: UIImage {
    ///保存到相册
    @discardableResult
    func savedPhotosAlbum(_ result: ((Bool)->())?) -> WYJProtocol {
        WYJPermissionsDetection.isOpenAlbumService({
            if $0 {
                obj.savedPhotosAlbum(result)
            } else {
                result?(false)
            }
        })
        return self
    }
    ///保存到相册
    @discardableResult
    func savedPhotosAlbum(completion: @escaping ((Bool, Error?) -> Void)) -> WYJProtocol {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: obj)
        } completionHandler: { (isSuccess: Bool, error: Error?) in
            completion(isSuccess, error)
        }
        return self
    }
}

//MARK: --- 图片转换
public extension WYJProtocol where T: UIImage {
    
    ///image --> base64
    func toBase64 (_ options: Data.Base64EncodingOptions = []) -> String {
        // 将图片转化成Data
        let imageData = self.quality()?.jpegData(compressionQuality: 1)
        // 将Data转化成 base64的字符串
        let imageBase64String = imageData?.base64EncodedString(options: options) ?? ""
        return imageBase64String
    }
    
    ///image --> color
    func toColor() -> UIColor? {
        return UIColor.init(patternImage: obj)
    }
    
    ///image --> data
    func toData() -> Data? {
        obj.pngData()
        return obj.jpegData(compressionQuality: 1)
    }
}

//MARK: --- 图片初始化
public extension UIImage {
    /// 根据url 生成image
    convenience init?(url: String) {
        guard let u = URL.init(string: url) else {
            return nil
        }
        guard let data = try? Data(contentsOf: u) else {
            return nil
        }
        guard let image = UIImage.init(data: data) else {
            return nil
        }
        guard let cgImage = image.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    ///根据颜色生成图片
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
    /// 根据view 生成image
    convenience init?(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    /// 根据字符串生成二维码图片
    convenience init?(QRCode QRCodeString: String,_ logo: UIImage?,_ size: CGSize = CGSize(width: 200, height: 200)) {
        
        guard let data = QRCodeString.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        let imageFilter = CIFilter(name: "CIQRCodeGenerator")
        imageFilter?.setValue(data, forKey: "inputMessage")
        imageFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let ciImage = imageFilter?.outputImage
        // 创建颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码图片
        let qrImage = UIImage(ciImage: (colorFilter?.outputImage)!)
        let imageRect = size.width > size.height ?
            CGRect(x: (size.width - size.height) / 2, y: 0, width: size.height, height: size.height) :
            CGRect(x: 0, y: (size.height - size.width) / 2, width: size.width, height: size.width)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        qrImage.draw(in: imageRect)
        if let log = logo {
            let logoSize = size.width > size.height ?
                CGSize(width: size.height * 0.25, height: size.height * 0.25) :
                CGSize(width: size.width * 0.25, height: size.width * 0.25)
            log.draw(in: CGRect(x: (imageRect.size.width - logoSize.width) / 2, y: (imageRect.size.height - logoSize.height) / 2, width: logoSize.width, height: logoSize.height))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    ///生成条形码
    convenience init?(BarCode text: String, _ size: CGSize,_ color: UIColor? = nil) {
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setDefaults()
            filter.setValue(data, forKey: "inputMessage")
            //获取生成的条形码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            // 设置条形码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            //获取带颜色的条形码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            let scaleX:CGFloat = size.width/newOutPutImage.extent.width
            let scaleY:CGFloat = size.height/newOutPutImage.extent.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let output = newOutPutImage.transformed(by: transform)
            let image = UIImage(ciImage: output)
            guard let cgImage = image.cgImage else {
                return nil
            }
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    // MARK: Image with Text
    /**
     创建一个文本标签图像。
     
     - Parameter text: The text to use in the label.
     - Parameter font: The font (default: System font of size 18)
     - Parameter color: The text color (default: White)
     - Parameter backgroundColor: The background color (default:Gray).
     - Parameter size: Image size (default: 10x10)
     - Parameter offset: Center offset (default: 0x0)
     
     - Returns A new image
     */
    convenience init?(text: String, font: UIFont = UIFont.systemFont(ofSize: 18), color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.gray, size: CGSize = CGSize(width: 100, height: 100), offset: CGPoint = CGPoint(x: 0, y: 0)) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = backgroundColor
        
        let image = UIImage(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: Image from UIView
    /**
     从UIView创建一个图像。
     
     - Parameter fromView: The source view.
     
     - Returns A new image
     */
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    /**
     创建一个径向梯度。
     
     - Parameter startColor: The start color
     - Parameter endColor: The end color
     - Parameter radialGradientCenter: The gradient center (default:0.5,0.5).
     - Parameter radius: Radius size (default: 0.5)
     - Parameter size: Image size (default: 100x100)
     
     - Returns A new image
     */
    convenience init?(startColor: UIColor, endColor: UIColor, radialGradientCenter: CGPoint = CGPoint(x: 0.5, y: 0.5), radius: Float = 0.5, size: CGSize = CGSize(width: 100, height: 100)) {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        let num_locations: Int = 2
        let locations: [CGFloat] = [0.0, 1.0] as [CGFloat]
        
        let startComponents = startColor.cgColor.components!
        let endComponents = endColor.cgColor.components!
        
        let components: [CGFloat] = [startComponents[0], startComponents[1], startComponents[2], startComponents[3], endComponents[0], endComponents[1], endComponents[2], endComponents[3]]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: num_locations)
        
        // Normalize the 0-1 ranged inputs to the width of the image
        let aCenter = CGPoint(x: radialGradientCenter.x * size.width, y: radialGradientCenter.y * size.height)
        let aRadius = CGFloat(min(size.width, size.height)) * CGFloat(radius)
        
        // Draw it
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!, startCenter: aCenter, startRadius: 0, endCenter: aCenter, endRadius: aRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        
        // Clean up
        UIGraphicsEndImageContext()
    }
}

//MARK: --- 保存
public extension UIImage {
    
    ///保存到相册
    func savedPhotosAlbum(_ result: ((Bool)->())?) {
        saveBlock = result
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let _ = error {
            print("保存失败")
            saveBlock?(false)
        } else {
            print("保存成功")
            saveBlock?(true)
        }
    }
}

//MARK: --- 渐变
public extension UIImage {
    /// 渐变色方向
    enum Direction {
        ///垂直
        case vertical
        ///水平
        case level
        ///左上到右下
        case leftTop
        ///左下到右上
        case leftBottom
    }
    ///线性渐变
    convenience init?(gradient size: CGSize,
                      direction: Direction,
                      locations: Array<CGFloat> = [0.0,1.0] ,
                      colors: [UIColor]) {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var cgColors = [CGColor]()
        colors.forEach { (colo) in
            cgColors.append(colo.cgColor)
        }
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations)!
        
        var start = CGPoint()
        var end = CGPoint()
        switch direction {
            case .vertical:
                start = CGPoint.init(x: 0, y: 0)
                end = CGPoint.init(x: 0, y: size.height)
                break
            case .level:
                start = CGPoint.init(x: 0, y: 0)
                end = CGPoint.init(x: size.width, y: 0)
                break
            case .leftTop:
                start = CGPoint.init(x: 0, y: 0)
                end = CGPoint.init(x: size.width, y: size.height)
                break
            case .leftBottom:
                start = CGPoint.init(x: size.width, y: 0)
                end = CGPoint.init(x: 0, y: size.height)
                break
        }
        
        context.drawLinearGradient(gradient, start: start, end: end, options: .drawsBeforeStartLocation)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let cgImage = image.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    ///放射性渐变
    convenience init?(RadialGradients size: CGSize,
                      locations: Array<CGFloat> = [0.0,1.0],
                      colors: [UIColor]) {
        
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var cgColors = [CGColor]()
        colors.forEach { (colo) in
            cgColors.append(colo.cgColor)
        }
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations)!
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        //外圆半径
        let endRadius = min(size.width, size.height) / 2
        //内圆半径
        let startRadius = endRadius / 3
        //绘制渐变
        context.drawRadialGradient(gradient,
                                   startCenter: center, startRadius: startRadius,
                                   endCenter: center, endRadius: endRadius,
                                   options: .drawsBeforeStartLocation)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let cgImage = image.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
}

//MARK: --- 图片处理
public extension WYJProtocol where T: UIImage {
    ///改变画质
    func quality(_ quality: CGFloat = 1) -> UIImage? {
        guard let imageData = obj.jpegData(compressionQuality: quality) else { return nil }
        return UIImage.init(data: imageData)
    }
    /// 截取指定Image的rect
    func croping(_ rect: CGRect) -> UIImage {
        guard rect.size.height < obj.size.height && rect.size.height < obj.size.height else { return obj }
        guard let image: CGImage = obj.cgImage?.cropping(to: rect) else { return obj }
        return UIImage(cgImage: image)
    }
    
    /// 旋转指定角度
    func rotate(_ radians: Float) -> UIImage {
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: obj.size.width, height: obj.size.height))
        let transformation: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(radians))
        rotatedViewBox.transform = transformation
        let rotatedSize: CGSize = CGSize(width: Int(rotatedViewBox.frame.size.width), height: Int(rotatedViewBox.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, 0)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return obj
        }
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: CGFloat(radians))
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(obj.cgImage!, in: CGRect(x: -obj.size.width / 2, y: -obj.size.height / 2, width: obj.size.width, height: obj.size.height))
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return obj
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    ///图片压缩
    func reset(_ maxSizeKB : CGFloat,_ maxWidth : CGFloat? = nil) -> UIImage? {
        let maxSize = maxSizeKB
        let maxImageSize = maxWidth ?? obj.size.width
        //先调整分辨率
        var newSize = CGSize.init(width: obj.size.width, height: obj.size.height)
        let tempHeight = newSize.height / maxImageSize
        let tempWidth = newSize.width / maxImageSize
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: obj.size.width / tempWidth, height: obj.size.height / tempWidth)
        }
        else if (tempHeight > 1.0 && tempWidth < tempHeight) {
            newSize = CGSize.init(width: obj.size.width / tempHeight, height: obj.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        obj.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            if let imageData = newImage.jpegData(compressionQuality: 1.0) {
                var sizeOriginKB : CGFloat = CGFloat((imageData.count)) / 1024.0
                //调整大小
                var resizeRate = 0.9
                while (sizeOriginKB > maxSize && resizeRate > 0.1) {
                    if let data = newImage.jpegData(compressionQuality: CGFloat(resizeRate)) {
                        sizeOriginKB = CGFloat((data.count)) / 1024.0
                        resizeRate -= 0.1
                        WYJLog("压缩后图片--大小:\(sizeOriginKB)--size:\(newSize)")
                        return UIImage.init(data: data)
                    }
                }
            }
        }
        return nil
    }
    
    ///将图片绘制成制定大小
    func scale(_ w: CGFloat,_ h: CGFloat) -> UIImage? {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        obj.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    /**
     *  重设图片大小
     */
    func resetSizeImage(_ reSize:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        obj.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        guard let reSizeImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(_ scaleSize:CGFloat) -> UIImage? {
        let reSize = CGSize(width: obj.size.width * scaleSize, height: obj.size.height * scaleSize)
        
        return resetSizeImage(reSize)
    }
    ///点九拉伸     Stretch 拉伸模式   Tile 平铺模式
    func resizableImage(insets: UIEdgeInsets,resizingMode: UIImage.ResizingMode) -> UIImage {
        return obj.resizableImage(withCapInsets: insets, resizingMode: resizingMode)
    }
    
    // MARK: 图片的模糊效果（高斯模糊滤镜）
    /// 图片的模糊效果（高斯模糊滤镜）
    /// - Parameter fuzzyValue: 设置模糊半径值（越大越模糊）
    /// - Returns: 返回模糊后的图片
    func getGaussianBlurImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        // 生成的高斯模糊滤镜图片
        return blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIGaussianBlur")
    }
    
    // MARK: 像素化后的图片
    ///像素化后的图片
    /// - Parameter fuzzyValue: 设置模糊半径值（越大越模糊）
    /// - Returns: 返回像素化后的图片
    func getPixellateImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        // 生成的高斯模糊滤镜图片
        return blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIPixellate")
    }
    
    /// 图片模糊
    /// - Parameters:
    ///   - fuzzyValue: 设置模糊半径值（越大越模糊）
    ///   - filterName: 模糊类型
    /// - Returns: 返回模糊后的图片
    private func blurredPicture(fuzzyValue: CGFloat, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: obj) else { return nil }
        // 创建高斯模糊滤镜类
        guard let blurFilter = CIFilter(name: filterName) else { return nil }
        // 设置图片
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        // 设置模糊半径值（越大越模糊）
        blurFilter.setValue(fuzzyValue, forKey: filterName == "CIPixellate" ? kCIInputScaleKey : kCIInputRadiusKey)
        // 从滤镜中 取出图片
        guard let outputImage = blurFilter.outputImage else { return nil }
        // 创建上下文
        let context = CIContext(options: nil)
        // 根据滤镜中的图片 创建CGImage
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        // 生成的模糊图片
        return UIImage(cgImage: cgImage)
    }
}

public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}

public extension UIImage {
    /**
     共享NSURL缓存用于URL中的图像
     */
    static var shared: NSCache<AnyObject, AnyObject>! {
        struct StaticSharedCache {
            static var shared: NSCache<AnyObject, AnyObject>? = NSCache()
        }
        
        return StaticSharedCache.shared!
    }
    
    // MARK: Alpha
    /**
     Returns true if the image has an alpha layer.
     */
    var hasAlpha: Bool {
        let alpha: CGImageAlphaInfo = self.cgImage!.alphaInfo
        switch alpha {
            case .first, .last, .premultipliedFirst, .premultipliedLast:
                return true
            default:
                return false
        }
    }
    
    /**
     返回给定图像的副本，如果还没有alpha通道，则添加一个alpha通道。
     */
    func applyAlpha() -> UIImage? {
        if hasAlpha {
            return self
        }
        
        let imageRef = self.cgImage;
        let width = imageRef?.width;
        let height = imageRef?.height;
        let colorSpace = imageRef?.colorSpace
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let offscreenContext = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        let rect: CGRect = CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!))
        offscreenContext?.draw(imageRef!, in: rect)
        let imageWithAlpha = UIImage(cgImage: (offscreenContext?.makeImage()!)!)
        return imageWithAlpha
    }
    
    /**
     返回图像的副本，并在其边缘周围添加给定大小的透明边框。例如，旋转图像而不产生锯齿状边缘。
     
     - Parameter padding: The padding amount.
     
     - Returns A new image.
     */
    func apply(_ padding: CGFloat) -> UIImage? {
        // If the image does not have an alpha layer, add one
        let image = self.applyAlpha()
        if image == nil {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width + padding * 2, height: size.height + padding * 2)
        
        // Build a context that's the same dimensions as the new size
        let colorSpace = self.cgImage?.colorSpace
        let bitmapInfo = self.cgImage?.bitmapInfo
        let bitsPerComponent = self.cgImage?.bitsPerComponent
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: bitsPerComponent!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        
        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation = CGRect(x: padding, y: padding, width: image!.size.width, height: image!.size.height)
        context?.draw(self.cgImage!, in: imageLocation)
        
        // Create a mask to make the border transparent, and combine it with the image
        let transparentImage = UIImage(cgImage: (context?.makeImage()?.masking(imageRef(withPadding: padding, size: rect.size))!)!)
        return transparentImage
    }
    
    /**
     创建一个遮罩，使外部边缘透明，其他一切不透明。大小必须包括整个遮罩(不透明部分+透明边框)。
     
     - Parameter padding: The padding amount.
     - Parameter size: The size of the image.
     
     - Returns A Core Graphics Image Ref
     */
    fileprivate func imageRef(withPadding padding: CGFloat, size: CGSize) -> CGImage {
        // Build a context that's the same dimensions as the new size
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        // Start with a mask that's entirely transparent
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Make the inner part (within the border) opaque
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(x: padding, y: padding, width: size.width - padding * 2, height: size.height - padding * 2))
        
        // Get an image of the context
        let maskImageRef = context?.makeImage()
        return maskImageRef!
    }
    
    
    // MARK: Crop
    
    /**
     创建图像的裁剪副本。
     
     - Parameter bounds: The bounds of the rectangle inside the image.
     
     - Returns A new image
     */
    func crop(bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    func cropToSquare() -> UIImage? {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        
        let left: CGFloat = (size.width > shortest) ? (size.width - shortest) / 2 : 0
        let top: CGFloat = (size.height > shortest) ? (size.height - shortest) / 2 : 0
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)
        
        return crop(bounds: insetRect)
    }
    
    // MARK: Resize
    
    /**
     创建图像的调整大小的副本。
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     
     - Returns A new image
     */
    func resize(toSize: CGSize, contentMode: UIImageContentMode = .scaleToFill) -> UIImage? {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
            case .scaleToFill:
                ratio = 1
            case .scaleAspectFill:
                ratio = max(horizontalRatio, verticalRatio)
            case .scaleAspectFit:
                ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let transform = CGAffineTransform.identity
        
        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    
    // MARK: Corner Radius
    
    /**
     创建一个带有圆角的新图像。
     
     - Parameter cornerRadius: The corner radius.
     
     - Returns A new image
     */
    func roundCorners(_ cornerRadius: CGFloat) -> UIImage? {
        // If the image does not have an alpha layer, add one
        let imageWithAlpha = applyAlpha()
        if imageWithAlpha == nil {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = imageWithAlpha?.cgImage?.width
        let height = imageWithAlpha?.cgImage?.height
        let bits = imageWithAlpha?.cgImage?.bitsPerComponent
        let colorSpace = imageWithAlpha?.cgImage?.colorSpace
        let bitmapInfo = imageWithAlpha?.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!)*scale, height: CGFloat(height!)*scale)
        
        context?.beginPath()
        if (cornerRadius == 0) {
            context?.addRect(rect)
        } else {
            context?.saveGState()
            context?.translateBy(x: rect.minX, y: rect.minY)
            context?.scaleBy(x: cornerRadius, y: cornerRadius)
            let fw = rect.size.width / cornerRadius
            let fh = rect.size.height / cornerRadius
            context?.move(to: CGPoint(x: fw, y: fh/2))
            context?.addArc(tangent1End: CGPoint(x: fw, y: fh), tangent2End: CGPoint(x: fw/2, y: fh), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: 0, y: fh), tangent2End: CGPoint(x: 0, y: fh/2), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: fw/2, y: 0), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: fw, y: 0), tangent2End: CGPoint(x: fw, y: fh/2), radius: 1)
            context?.restoreGState()
        }
        context?.closePath()
        context?.clip()
        
        context?.draw(imageWithAlpha!.cgImage!, in: rect)
        let image = UIImage(cgImage: (context?.makeImage()!)!, scale:scale, orientation: .up)
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     创建一个带有圆角和边框的新图像。
     
     - Parameter cornerRadius: The corner radius.
     - Parameter border: The size of the border.
     - Parameter color: The color of the border.
     
     - Returns A new image
     */
    func roundCorners(cornerRadius: CGFloat, border: CGFloat, color: UIColor) -> UIImage? {
        return roundCorners(cornerRadius)?.apply(border: border, color: color)
    }
    
    /**
     创建一个新的圆图像。
     
     - Returns A new image
     */
    func roundCornersToCircle() -> UIImage? {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(shortest/2)
    }
    
    /**
     创建一个带有边框的新圆形图像。
     
     - Parameter border :CGFloat The size of the border.
     - Parameter color :UIColor The color of the border.
     
     - Returns UIImage?
     */
    func roundCornersToCircle(withBorder border: CGFloat, color: UIColor) -> UIImage? {
        let shortest = min(size.width, size.height)
        return cropToSquare()?.roundCorners(cornerRadius: shortest/2, border: border, color: color)
    }
    
    // MARK: Border
    
    /**
     创建一个带有边框的新图像。
     
     - Parameter border: The size of the border.
     - Parameter color: The color of the border.
     
     - Returns A new image
     */
    func apply(border: CGFloat, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = self.cgImage?.width
        let height = self.cgImage?.height
        let bits = self.cgImage?.bitsPerComponent
        let colorSpace = self.cgImage?.colorSpace
        let bitmapInfo = self.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
        context?.setLineWidth(border)
        
        let rect = CGRect(x: 0, y: 0, width: size.width*scale, height: size.height*scale)
        let inset = rect.insetBy(dx: border*scale, dy: border*scale)
        
        context?.strokeEllipse(in: inset)
        context?.draw(self.cgImage!, in: inset)
        
        let image = UIImage(cgImage: (context?.makeImage()!)!)
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: Image Effects
    /**
     对图像应用光模糊效果
     - Returns New image or nil
     */
    func applyLightEffect(_ radius: CGFloat? = nil) -> UIImage? {
        return applyBlur(withRadius: radius ?? 0, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    /**
     应用额外的光模糊效果的图像
     - Returns New image or nil
     */
    func applyExtraLightEffect(_ radius: CGFloat? = nil) -> UIImage? {
        return applyBlur(withRadius: radius ?? 0, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    /**
     对图像应用暗模糊效果
     - Returns New image or nil
     */
    func applyDarkEffect(_ radius: CGFloat? = nil) -> UIImage? {
        return applyBlur(withRadius: radius ?? 0, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }
    
    /**
     对图像应用颜色色调
     - Parameter color: The tint color
     
     - Returns New image or nil
     */
    func applyTintEffect(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.numberOfComponents
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        return applyBlur(withRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0)
    }
    
    /**
     根据指定的半径、色彩饱和度和遮罩对图像应用模糊
     - Parameter blurRadius: The radius of the blur.
     - Parameter tintColor: The optional tint color.
     - Parameter saturationDeltaFactor: The detla for saturation.
     - Parameter maskImage: The optional image for masking.
     - Returns New image or nil
     */
    func applyBlur(withRadius blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        
        guard size.width > 0 && size.height > 0 && cgImage != nil else {
            return nil
        }
        guard let maskI = maskImage,maskI.cgImage != nil else {
            return nil
        }
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        let hasBlur = blurRadius > CGFloat(Float.ulpOfOne)
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > CGFloat(Float.ulpOfOne)
        if (hasBlur || hasSaturationChange) {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let effectInContext = UIGraphicsGetCurrentContext()
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(cgImage!, in: imageRect)
            
            var effectInBuffer = vImage_Buffer(
                data: effectInContext?.data,
                height: UInt((effectInContext?.height)!),
                width: UInt((effectInContext?.width)!),
                rowBytes: (effectInContext?.bytesPerRow)!)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = vImage_Buffer(
                data: effectOutContext?.data,
                height: UInt((effectOutContext?.height)!),
                width: UInt((effectOutContext?.width)!),
                rowBytes: (effectOutContext?.bytesPerRow)!)
            
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.main.scale
                let sqrtPi: CGFloat = CGFloat(sqrt(Double.pi * 2.0))
                var radius = UInt32(floor(inputRadius * 3.0 * sqrtPi / 4.0 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    
    // MARK: Image From URL
    
    /**
     使用可选的缓存从URL创建新映像。如果缓存，则返回缓存的映像。否则，将使用占位符，直到闭包返回来自web的图像为止。
     
     - Parameter url: image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter shouldCacheImage: Weather or not we should cache the NSURL response (default: true)
     - Parameter closure: Returns the image from the web the first time is fetched.
     
     - Returns A new image
     */
    class func image(fromURL url: String, placeholder: UIImage, shouldCacheImage: Bool = true, closure: @escaping (_ image: UIImage?) -> ()) -> UIImage? {
        // From Cache
        if shouldCacheImage {
            if let image = UIImage.shared.object(forKey: url as AnyObject) as? UIImage {
                closure(nil)
                return image
            }
        }
        // Fetch Image
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let nsURL = URL(string: url) {
            session.dataTask(with: nsURL, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    DispatchQueue.main.async {
                        closure(nil)
                    }
                }
                if let data = data, let image = UIImage(data: data) {
                    if shouldCacheImage {
                        UIImage.shared.setObject(image, forKey: url as AnyObject)
                    }
                    DispatchQueue.main.async {
                        closure(image)
                    }
                }
                session.finishTasksAndInvalidate()
            }).resume()
        }
        return placeholder
    }
}

public extension WYJProtocol where T == UIImage {
    
    // MARK: 设置图片透明度
    /// 设置图片透明度
    /// alpha: 透明度
    /// - Returns: newImage
    func alpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(obj.size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: obj.size.width, height: obj.size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(obj.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? obj
    }
}

// MARK:- UIImage 压缩相关
public extension WYJProtocol where T: UIImage {
    
    // MARK: 压缩图片
    /// 压缩图片
    /// - Parameter mode: 压缩模式
    /// - Returns: 压缩后图片
    func compress(mode: CompressionMode = .medium) -> UIImage? {
        guard let data = resizeIO(resizeSize: mode.resize(obj.size))?.yi.compressDataSize(maxSize: mode.maxDataSize) else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: 异步图片压缩
    /// 异步图片压缩
    /// - Parameters:
    ///   - mode: 压缩模式
    ///   - queue: 压缩队列
    ///   - complete: 完成回调(压缩后图片, 调整后分辨率)
    func asyncCompress(mode: CompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete:@escaping (UIImage?, CGSize) -> Void) {
        queue.async {
            
            DispatchQueue.main.async {
                if let data = resizeIO(resizeSize: mode.resize(obj.size))?.yi.compressDataSize(maxSize: mode.maxDataSize) {
                    complete(UIImage(data: data), mode.resize(obj.size))
                } else {
                    complete(nil, mode.resize(obj.size))
                }
                
            }
        }
    }
    
    // MARK: 压缩图片质量
    /// 压缩图片质量
    /// - Parameter maxSize: 最大数据大小
    /// - Returns: 压缩后图片
    func comoress(maxSize: Int) -> UIImage? {
        guard let data = compressDataSize(maxSize: maxSize) else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: 压缩图片质量
    /// 压缩图片质量
    /// - Parameter maxSize: 最大数据大小
    /// - Returns: 压缩后数据
    func compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
        let maxSize = maxSize
        var quality: CGFloat = 0.8
        var data = obj.jpegData(compressionQuality: quality)
        var dataCount = data?.count ?? 0
        
        while (data?.count ?? 0) > maxSize {
            if quality <= 0.6 {
                break
            }
            quality  = quality - 0.05
            data = obj.jpegData(compressionQuality: quality)
            if (data?.count ?? 0) <= dataCount {
                break
            }
            dataCount = data?.count ?? 0
        }
        return data
    }
    
    // MARK: ImageIO 方式调整图片大小 性能很好
    /// ImageIO 方式调整图片大小 性能很好
    /// - Parameter resizeSize: 图片调整Size
    /// - Returns: 调整后图片
    func resizeIO(resizeSize: CGSize) -> UIImage? {
        if obj.size == resizeSize {
            return obj
        }
        guard let imageData = obj.pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        
        let maxPixelSize = max(obj.size.width, obj.size.height)
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                       kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                       kCGImageSourceThumbnailMaxPixelSize: maxPixelSize]  as CFDictionary
        
        let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap{
            UIImage(cgImage: $0)
        }
        
        return resizedImage
    }
    
    // MARK: CoreGraphics 方式调整图片大小 性能很好
    /// CoreGraphics 方式调整图片大小 性能很好
    /// - Parameter resizeSize: 图片调整Size
    /// - Returns: 调整后图片
    func resizeCG(resizeSize: CGSize) -> UIImage? {
        if obj.size == resizeSize {
            return obj
        }
        guard  let cgImage = obj.cgImage else { return nil }
        guard  let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                      width: Int(resizeSize.width),
                                      height: Int(resizeSize.height),
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: cgImage.bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = context.makeImage().flatMap {
            UIImage(cgImage: $0)
        }
        return resizedImage
    }
}

// MARK: 压缩模式
public enum CompressionMode {
    /// 分辨率规则
    private static let resolutionRule: (min: CGFloat, max: CGFloat, low: CGFloat, default: CGFloat, high: CGFloat) = (10, 4096, 512, 1024, 2048)
    /// 数据大小规则
    private static let  dataSizeRule: (min: Int, max: Int, low: Int, default: Int, high: Int) = (1024 * 10, 1024 * 1024 * 20, 1024 * 512, 1024 * 1024 * 2, 1024 * 1024 * 10)
    // 低质量
    case low
    // 中等质量 默认
    case medium
    // 高质量
    case high
    // 自定义(最大分辨率, 最大输出数据大小)
    case other(CGFloat, Int)
    
    fileprivate var maxDataSize: Int {
        switch self {
        case .low:
            return CompressionMode.dataSizeRule.low
        case .medium:
            return CompressionMode.dataSizeRule.default
        case .high:
            return CompressionMode.dataSizeRule.high
        case .other(_, let dataSize):
            if dataSize < CompressionMode.dataSizeRule.min {
                return CompressionMode.dataSizeRule.default
            }
            if dataSize > CompressionMode.dataSizeRule.max {
                return CompressionMode.dataSizeRule.max
            }
            return dataSize
        }
    }
    
    fileprivate func resize(_ size: CGSize) -> CGSize {
        if size.width < CompressionMode.resolutionRule.min || size.height < CompressionMode.resolutionRule.min {
            return size
        }
        let maxResolution = maxSize
        let aspectRatio = max(size.width, size.height) / maxResolution
        if aspectRatio <= 1.0 {
            return size
        } else {
            let resizeWidth = size.width / aspectRatio
            let resizeHeighth = size.height / aspectRatio
            if resizeHeighth < CompressionMode.resolutionRule.min || resizeWidth < CompressionMode.resolutionRule.min {
                return size
            } else {
                return CGSize.init(width: resizeWidth, height: resizeHeighth)
            }
        }
    }
    
    fileprivate var maxSize: CGFloat {
        switch self {
        case .low:
            return CompressionMode.resolutionRule.low
        case .medium:
            return CompressionMode.resolutionRule.default
        case .high:
            return CompressionMode.resolutionRule.high
        case .other(let size, _):
            if size < CompressionMode.resolutionRule.min {
                return CompressionMode.resolutionRule.default
            }
            if size > CompressionMode.resolutionRule.max {
                return CompressionMode.resolutionRule.max
            }
            return size
        }
    }
}

// MARK:- gif 加载
public enum WYJLogDataType: String {
    case gif    = "gif"
    case png    = "png"
    case jpeg   = "jpeg"
    case tiff   = "tiff"
    case defaultType
}
public extension WYJProtocol where T: UIImage {
    
    // MARK: 验证资源的格式，返回资源格式（png/gif/jpeg...）
    /// 验证资源的格式，返回资源格式（png/gif/jpeg...）
    /// - Parameter data: 资源
    /// - Returns: 返回资源格式（png/gif/jpeg...）
    static func checkImageWYJLogDataType(data: Data?) -> WYJLogDataType {
        guard data != nil else {
            return .defaultType
        }
        let c = data![0]
        switch (c) {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        default:
            return .defaultType
        }
    }
    
    // MARK: 加载 data 数据的 gif 图片
    /// 加载 data 数据的 gif 图片
    /// - Parameter data: data 数据
    static func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            WYJLog("SwiftGif: Source for the image does not exist")
            return nil
        }
        return animatedImageWithSource(source)
    }
    
    // MARK: 加载网络 url 的 gif 图片
    /// 加载网络 url 的 gif 图片
    /// - Parameter url: gif图片的网络地址
    static func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            WYJLog("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            WYJLog("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    // MARK: 加载本地的gif图片
    /// 加载本地的gif图片
    /// - Parameter name:图片的名字
    static func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            WYJLog("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            WYJLog("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    // MARK: 加载 asset 里面的gif图片
    /// 加载 asset 里面的gif图片
    /// - Parameter asset: asset 里面的图片名字
    @available(iOS 9.0, *)
    static func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            WYJLog("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        return gif(data: dataAsset.data)
    }
    
    // MARK: 获取 asset 里面的gif图片的信息：包含分解后的图片和gif时间
    /// 获取 asset 里面的gif图片的信息：包含分解后的图片和gif时间
    /// - Parameter asset: asset 里面的图片名字
    /// - Returns: 分解后的图片和gif时间
    static func gifImages(asset: String) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            WYJLog("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return (nil, nil)
        }
        // Create source from data
        guard let source = CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else {
            WYJLog("SwiftGif: Source for the image does not exist")
            return (nil, nil)
        }
        return animatedImageSources(source)
    }
    
    // MARK: 获取 加载本地的 的gif图片的信息：包含分解后的图片和gif时间
    /// 获取 加载本地的 的gif图片的信息：包含分解后的图片和gif时间
    /// - Parameter name:图片的名字
    /// - Returns: 分解后的图片和gif时间
    static func gifImages(name: String) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            WYJLog("SwiftGif: This image named \"\(name)\" does not exist")
            return (nil, nil)
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            WYJLog("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return (nil, nil)
        }
        // Create source from data
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            WYJLog("SwiftGif: Source for the image does not exist")
            return (nil, nil)
        }
        return animatedImageSources(source)
    }
    
    // MARK: 获取 网络 url 的 gif 图片的信息：包含分解后的图片和gif时间
    /// 获取 网络 url 的 gif 图片的信息：包含分解后的图片和gif时间
    /// - Parameter url: gif图片的网络地址
    /// - Returns: 分解后的图片和gif时间
    static func gifImages(url: String) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            WYJLog("SwiftGif: This image named \"\(url)\" does not exist")
            return (nil, nil)
        }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            WYJLog("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return (nil, nil)
        }
        // Create source from data
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            WYJLog("SwiftGif: Source for the image does not exist")
            return (nil, nil)
        }
        return animatedImageSources(source)
    }
    
    // MARK: 获取gif图片转化为动画的Image
    private static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let info = animatedImageSources(source)
        guard let frames = info.gifImages, let duration = info.duration else {
            return nil
        }
        let animation = UIImage.animatedImage(with: frames, duration: duration)
        return animation
    }
    
    // MARK: 获取gif图片的信息
    /// 获取gif图片的信息
    /// - Parameter source: CGImageSource 资源
    /// - Returns: gif信息
    private static func animatedImageSources(_ source: CGImageSource) -> (gifImages: [UIImage]?, duration: TimeInterval?) {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            // At it's delay in cs
            let delaySeconds = delayForImageAtIndex(Int(index), source: source)
            // Seconds to ms
            delays.append(Int(delaySeconds * 1000.0))
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        return (frames, Double(duration) / 1000.0)
    }
    
    private static func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            // Make sure they're not too fast
            delay = 0.1
        }
        return delay
    }
    
    private static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = gcdForPair(val, gcd)
        }
        return gcd
    }
    
    private static func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            if rest == 0 {
                return rhs!
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
}

// MARK:- 图片旋转的一些操作
public extension WYJProtocol where T: UIImage {
    
    // MARK: 图片旋转 (角度)
    /// 图片旋转 (角度)
    /// - Parameter degree: 角度 0 -- 360
    /// - Returns: 旋转后的图片
    func imageRotated(degree: CGFloat) -> UIImage? {
        let radians = Double(degree) / 180 * Double.pi
        return imageRotated(radians: CGFloat(radians))
    }
    
    // MARK: 图片旋转 (弧度)
    /// 图片旋转 (弧度)
    /// - Parameter radians: 弧度 0 -- 2π
    /// - Returns: 旋转后的图片
    func imageRotated(radians: CGFloat) -> UIImage? {
        guard let weakCGImage = obj.cgImage else {
            return nil
        }
        let rotateViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: obj.size))
        let transform: CGAffineTransform = CGAffineTransform(rotationAngle: radians)
        rotateViewBox.transform = transform
        UIGraphicsBeginImageContext(rotateViewBox.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.translateBy(x: rotateViewBox.frame.width / 2, y: rotateViewBox.frame.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(x: -obj.size.width / 2, y: -obj.size.height / 2, width: obj.size.width, height: obj.size.height)
        context.draw(weakCGImage, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: 水平翻转
    /// 水平翻转
    /// - Returns: 返回水平翻转的图片
    func flipHorizontal() -> UIImage? {
        return self.rotate(orientation: .upMirrored)
    }
    
    // MARK: 垂直翻转
    /// 垂直翻转
    /// - Returns: 返回垂直翻转的图片
    func flipVertical() -> UIImage? {
        return self.rotate(orientation: .downMirrored)
    }
    
    // MARK: 向下翻转
    /// 向下翻转
    /// - Returns: 向下翻转后的图片
    func flipDown() -> UIImage? {
        return self.rotate(orientation: .down)
    }
    
    // MARK: 向左翻转
    /// 向左翻转
    /// - Returns: 向左翻转后的图片
    func flipLeft() -> UIImage? {
        return self.rotate(orientation: .left)
    }
    
    // MARK: 镜像向左翻转
    /// 镜像向左翻转
    /// - Returns: 镜像向左翻转后的图片
    func flipLeftMirrored() -> UIImage? {
        return self.rotate(orientation: .leftMirrored)
    }
    
    // MARK: 向右翻转
    /// 向右翻转
    /// - Returns: 向右翻转后的图片
    func flipRight() -> UIImage? {
        return self.rotate(orientation: .right)
    }
    
    // MARK: 镜像向右翻转
    /// 镜像向右翻转
    /// - Returns: 镜像向右翻转后的图片
    func flipRightMirrored() -> UIImage? {
        return self.rotate(orientation: .rightMirrored)
    }
    
    // MARK: 图片平铺区域
    /// 图片平铺区域
    /// - Parameter size: 平铺区域的大小
    /// - Returns: 平铺后的图片
    func imageTile(size: CGSize) -> UIImage? {
        let tempView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        tempView.backgroundColor = UIColor(patternImage: obj)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        tempView.layer.render(in: context)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return bgImage
    }
    
    // MARK: 图片翻转(base)
    /// 图片翻转(base)
    /// - Parameter orientation: 翻转类型
    /// - Returns: 翻转后的图片
    private func rotate(orientation: UIImage.Orientation) -> UIImage? {
        guard let imageRef = obj.cgImage else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        var bounds = rect
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch orientation {
        case .up:
            return obj
        case .upMirrored:
            // 图片左平移width个像素
            transform = CGAffineTransform(translationX: rect.size.width, y: 0)
            // 缩放
            transform = transform.scaledBy(x: -1, y: 1)
        case .down:
            transform = CGAffineTransform(translationX: rect.size.width, y: rect.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: rect.size.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left:
            swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX:0 , y: rect.size.width)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .leftMirrored:
            swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX:rect.size.height , y: rect.size.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .right:
            swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX:rect.size.height , y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .rightMirrored:
            swapWidthAndHeight(rect: &bounds)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        default:
            return nil
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        //图片绘制时进行图片修正
        switch orientation {
        case .left:
            fallthrough
        case .leftMirrored:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -bounds.size.width, y: 0.0)
        default:
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -rect.size.height)
        }
        context.concatenate(transform)
        context.draw(imageRef, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 交换宽高
    /// - Parameter rect: image 的 frame
    private func swapWidthAndHeight(rect: inout CGRect) {
        let swap = rect.size.width
        rect.size.width = rect.size.height
        rect.size.height = swap
    }
}

// MARK:- 给图片添加滤镜效果（棕褐色老照片滤镜，黑白滤镜）
/**
 Core Image 是一个强大的滤镜处理框架。它除了可以直接给图片添加各种内置滤镜，还能精确地修改鲜艳程度, 色泽, 曝光等，下面通过两个样例演示如何给 UIImage 添加滤镜
 */
public extension WYJProtocol where T: UIImage {
    /// 滤镜类型
    enum WYJImageFilterType: String {
        /// 棕褐色复古滤镜（老照片效果），有点复古老照片发黄的效果）
        case CISepiaTone = "CISepiaTone"
        /// 黑白效果滤镜
        case CIPhotoEffectNoir = "CIPhotoEffectNoir"
    }
    
    // MARK: 8.1、图片加滤镜
    /// 图片加滤镜
    /// - Parameters:
    ///   - filterType: 滤镜类型
    ///   - alpha: 透明度
    /// - Returns: 添加滤镜后的图片
    func filter(filterType: WYJImageFilterType, alpha: CGFloat?) -> UIImage? {
        guard let imageData = obj.pngData() else {
            return nil
        }
        let inputImage = CoreImage.CIImage(data: imageData)
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: filterType.rawValue) else {
            return nil
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if alpha != nil {
            filter.setValue(alpha, forKey: "inputIntensity")
        }
        guard let outputImage = filter.outputImage, let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: outImage)
    }
    
    // MARK: 全图马赛克
    /// 全图马赛克
    /// - Parameter value: 值越大马赛克就越大(使用默认)
    /// - Returns: 全图马赛克的图片
    func pixAll(value: Int? = nil) -> UIImage? {
        guard let filter = CIFilter(name: "CIPixellate") else {
            return nil
        }
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: obj)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if value != nil {
            // 值越大马赛克就越大(使用默认)
            filter.setValue(value, forKey: kCIInputScaleKey)
        }
        let fullPixellatedImage = filter.outputImage
        let cgImage = context.createCGImage(fullPixellatedImage!, from: fullPixellatedImage!.extent)
        return UIImage(cgImage: cgImage!)
    }
    
    // MARK: 检测人脸的frame
    // 检测人脸的frame
    func detectFace() -> [CGRect]? {
        guard let inputImage = CIImage(image: obj) else {
            return nil
        }
        let context = CIContext(options: nil)
        // 人脸检测器
        // CIDetectorAccuracyHigh: 检测的精度高,但速度更慢些
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        // 人脸检测需要图片方向(有元数据的话使用元数据,没有就调用featuresInImage)
        if let orientation = inputImage.properties[kCGImagePropertyOrientation as String] {
            faceFeatures = (detector!.features(in: inputImage, options: [CIDetectorImageOrientation: orientation]) as! [CIFaceFeature])
        } else {
            faceFeatures = (detector!.features(in: inputImage) as! [CIFaceFeature])
        }
        let inputImageSize = inputImage.extent.size
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)
        
        // 人脸位置的frame
        var rects: [CGRect] = []
        // 遍历所有的面部，并框出
        for faceFeature in faceFeatures {
            let faceViewBounds = faceFeature.bounds.applying(transform)
            rects.append(faceViewBounds)
        }
        return rects
    }
    
    // MARK: 检测人脸并打马赛克
    /// 检测人脸并打马赛克
    /// - Returns: 打马赛克后的人脸
    func detectAndPixFace() -> UIImage? {
        guard let inputImage = CIImage(image: obj) else {
            return nil
        }
        let context = CIContext(options: nil)
        
        // 用CIPixellate滤镜对原图先做个完全马赛克
        let filter = CIFilter(name: "CIPixellate")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let inputScale = max(inputImage.extent.size.width, inputImage.extent.size.height) / 80
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter.outputImage
        // 检测人脸，并保存在faceFeatures中
        guard let detector = CIDetector(ofType: CIDetectorTypeFace,
                                       context: context,
                                       options: nil) else {
            return nil
        }
        let faceFeatures = detector.features(in: inputImage)
        // 初始化蒙版图，并开始遍历检测到的所有人脸
        var maskImage: CIImage!
        for faceFeature in faceFeatures {
            // 基于人脸的位置，为每一张脸都单独创建一个蒙版，所以要先计算出脸的中心点，对应为x、y轴坐标，
            // 再基于脸的宽度或高度给一个半径，最后用这些计算结果初始化一个CIRadialGradient滤镜
            let centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2
            let centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2
            let radius = min(faceFeature.bounds.size.width, faceFeature.bounds.size.height)
            guard let radialGradient = CIFilter(name: "CIRadialGradient",
                                                parameters: [
                                                  "inputRadius0" : radius,
                                                  "inputRadius1" : radius + 1,
                                                   "inputColor0" : CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                                   "inputColor1" : CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                               kCIInputCenterKey : CIVector(x: centerX, y: centerY)
                                                ]) else {
                return nil
            }
            // 由于CIRadialGradient滤镜创建的是一张无限大小的图，所以在使用之前先对它进行裁剪
            let radialGradientOutputImage = radialGradient.outputImage!.cropped(to: inputImage.extent)
            if maskImage == nil {
                maskImage = radialGradientOutputImage
            } else {
                maskImage = CIFilter(name: "CISourceOverCompositing",
                                     parameters: [
                                        kCIInputImageKey : radialGradientOutputImage,
                                        kCIInputBackgroundImageKey : maskImage as Any
                                     ])!.outputImage
            }
        }
        // 用CIBlendWithMask滤镜把马赛克图、原图、蒙版图混合起来
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        // 输出，在界面上显示
        guard let blendOutputImage = blendFilter.outputImage, let blendCGImage = context.createCGImage(blendOutputImage, from: blendOutputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: blendCGImage)
    }
}

// MARK:- 动态图片的使用
public extension WYJProtocol where T: UIImage {

    // MARK: 深色图片和浅色图片切换 （深色模式适配）
    /// 深色图片和浅色图片切换 （深色模式适配）
    /// - Parameters:
    ///   - light: 浅色图片
    ///   - dark: 深色图片
    /// - Returns: 最终图片
    static func image(light: UIImage?, dark: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard let weakLight = light, let weakDark = dark, let config = weakLight.configuration else { return light }
            let lightImage = weakLight.withConfiguration(config.withTraitCollection(UITraitCollection.init(userInterfaceStyle: UIUserInterfaceStyle.light)))
            lightImage.imageAsset?.register(weakDark, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        } else {
            return light
        }
    }
}


//MARK: --- runtime
public extension UIImage {
    private struct WYJRuntimeKey {
        static let saveBlockKey = UnsafeRawPointer.init(bitPattern: "saveBlock".hashValue)
    }
    private var saveBlock: ((Bool)->())? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.saveBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.saveBlockKey!) as? (Bool) -> ()
        }
    }
}
