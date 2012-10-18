//
//  UIImageView + Extenstions.m
//  Zombify
//
//  Created by Ben on 10/11/12.
//
//

#import "UIImageView + Extenstions.h"

@implementation UIImageView (Extensions)

- (UIImageView *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImageView *sourceImage = self;
    //UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.frame.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
//    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
//    [sourceImage.image drawInRect:thumbnailRect];
    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    if(newImage == nil) NSLog(@"could not scale image");
    
    sourceImage.frame = CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight);
    return sourceImage;
}
@end
