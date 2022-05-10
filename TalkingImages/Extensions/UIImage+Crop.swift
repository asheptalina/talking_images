import UIKit

extension UIImage {
    func cropped(topLeft: CGPoint, bottomRight: CGPoint) -> UIImage {
        let sourceCGImage = self.cgImage!
        var cropRect = CGRect(
            x: topLeft.x,
            y: topLeft.y,
            width: bottomRight.x - topLeft.x,
            height: bottomRight.y - topLeft.y
        )
        cropRect.origin.x *= self.scale
        cropRect.origin.y *= self.scale
        cropRect.size.width *= self.scale
        cropRect.size.height *= self.scale

        let cropped = sourceCGImage.cropping(to: cropRect)!
        return UIImage(cgImage: cropped, scale: self.scale, orientation: self.imageOrientation)
    }
}
