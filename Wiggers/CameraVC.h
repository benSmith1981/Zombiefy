//
//  CameraVC.h
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol OverlayViewControllerDelegate;
@interface CameraVC : UIViewController <UIImagePickerControllerDelegate>
{
    __weak id <OverlayViewControllerDelegate> delegate;
    
    UIImageView *overlayImage;
}

@property (weak) id <OverlayViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *cameraImageView;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage;
- (UIImage*)dumpOverlayViewToImage ;
@end


@protocol OverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end