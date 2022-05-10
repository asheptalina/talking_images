#include "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

using namespace std;

@implementation OpenCVWrapper : NSObject

+ (NSArray<UIImage*>*)processImage: (UIImage *)inputImage withMouthPoints: (NSArray<NSValue*>*) mouthPoints {
    cv::Mat mat = [inputImage CVMat];
    cv::Mat mat2 = [inputImage CVMat];

    vector<cv::Point> contourPoints;
    for (id value in mouthPoints) {
        if ([value isKindOfClass:[NSValue class]]) {
            CGPoint cgPoint = ((NSValue*) value).CGPointValue;
            contourPoints.push_back(cv::Point(cgPoint.x, cgPoint.y));
        }
    }
    contourPoints.push_back(contourPoints[0]);

    cv::polylines(mat, contourPoints, false, cv::Scalar(0, 0, 255), 10);

    UIImage* resultImage = [UIImage imageWithCVMat:mat withOrientation:inputImage.imageOrientation];
    UIImage* resultImage2 = [UIImage imageWithCVMat:mat2 withOrientation:inputImage.imageOrientation];
    return @[resultImage, resultImage2, resultImage, resultImage2];
}

@end
