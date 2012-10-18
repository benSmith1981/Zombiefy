//
//  ImageProcessing.h
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageManipulationVC.h"

@interface FaceImageProcessing : ImageManipulationVC{
    NSMutableArray *featuresDetected;
}

+(void)processFace:(UIImage*)faceImage;
- (UIImage*) drawText:(NSString*) text 
              inImage:(UIImage*)  image 
              atPoint:(CGPoint)   point ;
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage;
- (UIImage*)dumpOverlayViewToImage;
- (void)drawFeature:(int)feature InContext:(CGContextRef)contextLocal atPoint:(CGPoint)featurePoint;
//this is called when the save image button is pressed
-(void)setImage;
- (void)drawImageAnnotatedWithFeatures;
@end
