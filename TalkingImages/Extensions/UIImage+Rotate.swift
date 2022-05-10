import Foundation
import UIKit

extension UIImage {

    func rotate(degrees: Float) -> UIImage? {
        return self.rotate(radians: .pi * degrees / 180)
    }

    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(
            in: CGRect(
                x: -self.size.width/2,
                y: -self.size.height/2,
                width: self.size.width,
                height: self.size.height
            )
        )

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    //    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
    //        //Calculate the size of the rotated view's containing box for our drawing space
    //        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
    //        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
    //        rotatedViewBox.transform = t
    //        let rotatedSize: CGSize = rotatedViewBox.frame.size
    //        //Create the bitmap context
    //        UIGraphicsBeginImageContext(rotatedSize)
    //        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    //        //Move the origin to the middle of the image so we will rotate and scale around the center.
    //        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    //        //Rotate the image context
    //        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
    //        //Now, draw the rotated/scaled image into the context
    //        bitmap.scaleBy(x: 1.0, y: -1.0)
    //        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
    //        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    //        UIGraphicsEndImageContext()
    //        return newImage
    //    }
    //
    //    public func fixedOrientation() -> UIImage {
    //        if imageOrientation == UIImage.Orientation.up {
    //            return self
    //        }
    //
    //        var transform: CGAffineTransform = CGAffineTransform.identity
    //
    //        switch imageOrientation {
    //        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
    //            transform = transform.translatedBy(x: size.width, y: size.height)
    //            transform = transform.rotated(by: CGFloat.pi)
    //            break
    //        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
    //            transform = transform.translatedBy(x: size.width, y: 0)
    //            transform = transform.rotated(by: CGFloat.pi/2)
    //            break
    //        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
    //            transform = transform.translatedBy(x: 0, y: size.height)
    //            transform = transform.rotated(by: -CGFloat.pi/2)
    //            break
    //        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
    //            break
    //        }
    //
    //        switch imageOrientation {
    //        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
    //            transform.translatedBy(x: size.width, y: 0)
    //            transform.scaledBy(x: -1, y: 1)
    //            break
    //        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
    //            transform.translatedBy(x: size.height, y: 0)
    //            transform.scaledBy(x: -1, y: 1)
    //        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
    //            break
    //        }
    //
    //        let ctx: CGContext = CGContext(data: nil,
    //                                       width: Int(size.width),
    //                                       height: Int(size.height),
    //                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
    //                                       bytesPerRow: 0,
    //                                       space: self.cgImage!.colorSpace!,
    //                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    //
    //        ctx.concatenate(transform)
    //
    //        switch imageOrientation {
    //        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
    //            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
    //        default:
    //            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    //            break
    //        }
    //
    //        let cgImage: CGImage = ctx.makeImage()!
    //
    //        return UIImage(cgImage: cgImage)
    //    }
}
