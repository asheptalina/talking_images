#ifdef __cplusplus
#undef NO
#undef YES
#import <opencv2/opencv.hpp>
#endif
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface OpenCVWrapper : NSObject
    + (NSArray<UIImage*>*)processImage: (UIImage *)inputImage withMouthPoints: (NSArray<NSValue*>*) mouthPoints;
//    + (ImageWithBoundingBox *)processImage: (UIImage *)inputImage;
//    + (UIImage*)cutDocumentFrom: (UIImage *) inputImage withDocumentContour: (NSArray<NSValue*>*) contour;
@end
