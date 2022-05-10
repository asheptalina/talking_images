#import <UIKit/UIKit.h>
#ifdef __cplusplus
#undef NO
#undef YES
#import <opencv2/opencv.hpp>
#endif

@interface UIImage (OpenCV)

//cv::Mat to UIImage
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat withOrientation:(UIImageOrientation) orientation;
- (id)initWithCVMat:(const cv::Mat&)cvMat withOrientation:(UIImageOrientation) orientation;

//UIImage to cv::Mat
- (cv::Mat)CVMat;
- (cv::Mat)CVMat3;  // no alpha channel
- (cv::Mat)CVGrayscaleMat;

@end
