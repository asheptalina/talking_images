import UIKit

extension UIImage {
    func cropped(topLeft: CGPoint, bottomRight: CGPoint) -> UIImage {
        let sourceCGImage = self.cgImage!
        let cropped = sourceCGImage.cropping(
            to: CGRect(
                x: topLeft.x,
                y: topLeft.y,
                width: bottomRight.x - topLeft.x,
                height: bottomRight.y - topLeft.y
            )
        )!
        return UIImage(cgImage: cropped)
    }
}
