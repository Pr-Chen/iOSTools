//
//  UIImage+Bar.swift
//  iOSTools
//
//  Created by 陈凯 on 2016/11/1.
//  Copyright © 2016年 陈凯. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 创建带logo的二维码
    public static func creatQRCode(for string:String, logo:UIImage, width: CGFloat) -> UIImage? {
        
        let noLogoCode = self.creatQRCode(for: string, width: width)
        guard let QRCode = noLogoCode  else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height:width), true, UIScreen.main.scale)
        QRCode.draw(in: CGRect(x: 0, y: 0, width: width, height: width))
        logo.addCorner(radius: 0.1*logo.size.width).draw(in: CGRect(x: 0.4*width, y: 0.4*width, width: 0.2*width, height: 0.2*width))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return resultImage
    }
    
    ///创建高质量二维码
    public static func creatQRCode(for string:String, width: CGFloat) -> UIImage? {
        
        guard let image = self.creatQRCode(for: string) else {
            return nil
        }
        
        let extent = image.extent.integral
        let scale = min(width/extent.width, width/extent.height)
        
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(image, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        return UIImage(ciImage: colorFilter.outputImage!
            .applying(CGAffineTransform(scaleX: scale, y: scale)))
    }
    
    ///创建高质量128条码
    public static func creat128Code(for string:String, width: CGFloat) -> UIImage? {
        
        guard let image = self.creat128Code(for: string) else {
            return nil
        }
        
        let extent = image.extent.integral
        let scale = min(width/extent.width, width/extent.height)
        
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(image, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        return UIImage(ciImage: colorFilter.outputImage!
            .applying(CGAffineTransform(scaleX: scale, y: scale)))
    }
    
    //创建低质量二维码
    fileprivate static func creatQRCode(for string:String) -> CIImage? {
        
        let data = string.data(using: .utf8)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(data, forKey: "inputMessage")
        
        return filter?.outputImage
    }
    
    //创建低质量128条码
    fileprivate static func creat128Code(for string:String) -> CIImage? {
        
        let data = string.data(using: .utf8)
        
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setDefaults()
        filter?.setValue(data, forKey: "inputMessage")
        
        return filter?.outputImage
    }
    
    /// 获取圆角图片
    func addCorner(radius: CGFloat) -> UIImage {
        
        if radius <= 0 {
            return self
        }
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(self.cgImage!, in: rect)
        context?.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
        context?.clip()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        guard let resultImage = image else {
            return self
        }
        return resultImage
    }
}
