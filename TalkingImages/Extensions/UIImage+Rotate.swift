import Foundation
//UIImage *rotatedImage(UIImage *image, CGFloat rotation) // rotation in radians
//{
//    // Calculate Destination Size
//    CGAffineTransform t = CGAffineTransformMakeRotation(rotation);
//    CGRect sizeRect = (CGRect) {.size = image.size};
//    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
//    CGSize destinationSize = destRect.size;
//    
//    // Draw image
//    UIGraphicsBeginImageContext(destinationSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
//    CGContextRotateCTM(context, rotation);
//    [image drawInRect:CGRectMake(-image.size.width / 2.0f, -image.size.height / 2.0f, image.size.width, image.size.height)];
//    
//    // Save image
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//CGFloat DegreesToRadians(CGFloat degrees)
//{
//    return degrees * M_PI / 180;
//};
//
//CGFloat RadiansToDegrees(CGFloat radians)
//{
//    return radians * 180 / M_PI;
//};
