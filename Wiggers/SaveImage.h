//
//  SaveImageViewController.h
//  Wiggers
//
//  Created by Ben Smith on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveImage : NSObject <UIAlertViewDelegate>
{
//    NSMutableArray *savedFiles;
//    UIImage *imageToSave;
}
+ (void)saveImage:(UIImage*)image withFileName:(NSString*)fileName;
+ (UIImage*)loadImage:(NSString*)fileName;
+ (void)removeImage:(NSString*)fileName;
+ (NSArray*)getListOfPNGsInDocDirectory;
@end
