//
//  CameraVC.m
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraVC.h"
#import "Constants.h"

@interface CameraVC ()

@end

@implementation CameraVC
@synthesize delegate,imagePickerController,cameraImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        
        //overlay image for the camera
        overlayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"faceScaled.png"]];
        overlayImage.alpha = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePickerController.showsCameraControls = YES;
        self.imagePickerController.cameraOverlayView = overlayImage;
    }

//    if (sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        // user wants to use the camera interface
//        //
//        self.imagePickerController.showsCameraControls = YES;
//        
//        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
//        {
//            // setup our custom overlay view for the camera
//            //
//            // ensure that our custom view's frame fits within the parent frame
//            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
//            CGRect newFrame = CGRectMake(0.0,
//                                         CGRectGetHeight(overlayViewFrame) -
//                                         self.view.frame.size.height - 10.0,
//                                         CGRectGetWidth(overlayViewFrame),
//                                         self.view.frame.size.height + 10.0);
//            self.view.frame = newFrame;
//            [self.imagePickerController.cameraOverlayView addSubview:self.view];
//        }
//    }
}

// update the UI after an image has been chosen or picture taken
//
- (void)finishAndUpdate
{
    [self.delegate didFinishWithCamera];  // tell our delegate we are done with the camera
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:[self addOverlayToBaseImage:image]];
    
    //if (![self.cameraTimer isValid])
        [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
}

#pragma mark - Dump Image
/*To add an overlay image to the camera image you must specify the overlay image here
 */
- (UIImage*)dumpOverlayViewToImage {
    CGSize imageSize;
	//CGSize imageSize = overlayImage.bounds.size;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        imageSize = CGSizeMake(IMG_WIDTH_NO_ADS, IMG_HEIGHT_NO_ADS);
    }   
    else {
        imageSize = CGSizeMake(IMG_WIDTH, IMG_HEIGHT);
    }
    
	UIGraphicsBeginImageContext(imageSize);
	[cameraImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

/*Pass in the base image from the camera here
 */
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage {
    UIImage* result;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        UIImage *overlayImageLocal = [self dumpOverlayViewToImage];	
        CGPoint topCorner = CGPointMake(0, 0);
        CGSize targetSize = CGSizeMake(IMG_WIDTH_NO_ADS, IMG_HEIGHT_NO_ADS);	
        CGRect scaledRect = CGRectZero;
        
        CGFloat scaledX = IMG_HEIGHT_NO_ADS * baseImage.size.width / baseImage.size.height;
        CGFloat offsetX = (scaledX - IMG_WIDTH_NO_ADS) / -2;
        
        scaledRect.origin = CGPointMake(offsetX, 0.0);
        scaledRect.size.width  = scaledX;
        scaledRect.size.height = IMG_HEIGHT_NO_ADS;
        
        UIGraphicsBeginImageContext(targetSize);	
        [baseImage drawInRect:scaledRect];	
        [overlayImageLocal drawAtPoint:topCorner];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();	
    }
    else {
        UIImage *overlayImageLocal = [self dumpOverlayViewToImage];	
        CGPoint topCorner = CGPointMake(0, 0);
        CGSize targetSize = CGSizeMake(IMG_WIDTH, IMG_HEIGHT);	
        CGRect scaledRect = CGRectZero;
        
        CGFloat scaledX = IMG_HEIGHT * baseImage.size.width / baseImage.size.height;
        CGFloat offsetX = (scaledX - IMG_WIDTH) / -2;
        
        scaledRect.origin = CGPointMake(offsetX, 0.0);
        scaledRect.size.width  = scaledX;
        scaledRect.size.height = IMG_HEIGHT;
        
        UIGraphicsBeginImageContext(targetSize);	
        [baseImage drawInRect:scaledRect];	
        [overlayImageLocal drawAtPoint:topCorner];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
	
	
	return result;	
}


@end
