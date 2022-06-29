#include "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

using namespace std;

@implementation OpenCVWrapper : NSObject

+ (NSArray<UIImage*>*)processImage: (UIImage *)inputImage withMouthPoints: (NSArray<NSValue*>*) mouthPoints {
    cv::Mat mat = [inputImage CVMat];

    vector<cv::Point> contourPoints;
    for (id value in mouthPoints) {
        if ([value isKindOfClass:[NSValue class]]) {
            CGPoint cgPoint = ((NSValue*) value).CGPointValue;
            contourPoints.push_back(cv::Point(cgPoint.x, cgPoint.y));
        }
    }

    float diff1 = 0;
    float diff2 = (contourPoints[0].y - contourPoints[1].y) / 3;
    float diff3 = (contourPoints[0].y - contourPoints[1].y) / 3 * 2;
    float diff4 = contourPoints[0].y - contourPoints[1].y;

    vector<cv::Mat> cvImages;
    for (int i = 0; i <= 3; i++) {
        vector<cv::Point> resPoints = contourPoints;
        vector<cv::Point> points = contourPoints;
        reverse(points.begin(), points.end());

        resPoints.push_back(cv::Point(points[1].x, points[1].y + diff2 / 3 * i));
        resPoints.push_back(cv::Point(points[2].x, points[2].y + diff3 / 3 * i));
        resPoints.push_back(cv::Point(points[3].x, points[3].y + diff4 / 3 * i));
        resPoints.push_back(cv::Point(points[4].x, points[4].y + diff3 / 3 * i));
        resPoints.push_back(cv::Point(points[5].x, points[5].y + diff2 / 3 * i));
        resPoints.push_back(cv::Point(points[6].x, points[6].y + diff1 / 3 * i));

        cv::Mat mat1 = [inputImage CVMat];
        cv::fillPoly(mat1, resPoints, cv::Scalar(0, 0, 0));
        cvImages.push_back(mat1);
    }

    UIImage* resultImage = [UIImage imageWithCVMat:mat withOrientation:inputImage.imageOrientation];
    UIImage* resultImage2 = [UIImage imageWithCVMat:cvImages[0] withOrientation:inputImage.imageOrientation];
    UIImage* resultImage3 = [UIImage imageWithCVMat:cvImages[1] withOrientation:inputImage.imageOrientation];
    UIImage* resultImage4 = [UIImage imageWithCVMat:cvImages[2] withOrientation:inputImage.imageOrientation];
    UIImage* resultImage5 = [UIImage imageWithCVMat:cvImages[3] withOrientation:inputImage.imageOrientation];
    return @[
        resultImage,
        resultImage2,
        resultImage3,
        resultImage4,
        resultImage5,
        resultImage4,
        resultImage3,
        resultImage2,
        resultImage2,
        resultImage3,
        resultImage4,
        resultImage5,
        resultImage4,
        resultImage3,
        resultImage2,
        resultImage2,
        resultImage3,
        resultImage4,
        resultImage5,
        resultImage4,
        resultImage3,
        resultImage2,
        resultImage2,
        resultImage3,
        resultImage4,
        resultImage5,
        resultImage4,
        resultImage3,
        resultImage2,
        resultImage
    ];
}

@end
