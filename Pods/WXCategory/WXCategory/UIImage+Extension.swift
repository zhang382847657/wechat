//
//  UIImage+Extension.swift
//  LearnSwift
//
//  Created by 张琳 on 2018/8/30.
//  Copyright © 2018年 张琳. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

private let lock = NSLock()

public extension UIImage {
    
    
    /// 颜色转UIImage
    ///
    /// - Parameter color: 颜色
    /// - Returns: UIImage
    public class func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    /// Initializes and returns the image object with the specified data in a thread-safe manner.
    ///
    /// It has been reported that there are thread-safety issues when initializing large amounts of images
    /// simultaneously. In the event of these issues occurring, this method can be used in place of
    /// the `init?(data:)` method.
    ///
    /// - parameter data: The data object containing the image data.
    ///
    /// - returns: An initialized `UIImage` object, or `nil` if the method failed.
    public static func threadSafeImage(with data: Data) -> UIImage? {
        lock.lock()
        let image = UIImage(data: data)
        lock.unlock()
        
        return image
    }
    
    
    /// Initializes and returns the image object with the specified data and scale in a thread-safe manner.
    ///
    /// It has been reported that there are thread-safety issues when initializing large amounts of images
    /// simultaneously. In the event of these issues occurring, this method can be used in place of
    /// the `init?(data:scale:)` method.
    ///
    /// - parameter data:  The data object containing the image data.
    /// - parameter scale: The scale factor to assume when interpreting the image data. Applying a scale factor of 1.0
    ///                    results in an image whose size matches the pixel-based dimensions of the image. Applying a
    ///                    different scale factor changes the size of the image as reported by the size property.
    ///
    /// - returns: An initialized `UIImage` object, or `nil` if the method failed.
    public static func threadSafeImage(with data: Data, scale: CGFloat) -> UIImage? {
        lock.lock()
        let image = UIImage(data: data, scale: scale)
        lock.unlock()
        
        return image
    }
    
}


// MARK: - Alpha
extension UIImage {
    /// Returns whether the image contains an alpha component.
    public var containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo
        
        return (
            alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
    }
    
    /// Returns whether the image is opaque.
    public var isOpaque: Bool { return !containsAlphaComponent }
}

// MARK: - Scaling
extension UIImage {
    
    /// Returns a new version of the image scaled to the specified size.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func imageScaled(to size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fit within
    /// a specified size.
    ///
    /// The resulting image contains an alpha component used to pad the width or height with the necessary transparent
    /// pixels to fit the specified size. In high performance critical situations, this may not be the optimal approach.
    /// To maintain an opaque image, you could compute the `scaledSize` manually, then use the `af_imageScaledToSize`
    /// method in conjunction with a `.Center` content mode to achieve the same visual result.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func imageAspectScaled(toFit size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fill a
    /// specified size. Any pixels that fall outside the specified size are clipped.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func imageAspectScaled(toFill size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
