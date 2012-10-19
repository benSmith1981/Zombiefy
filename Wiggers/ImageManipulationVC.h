//
//  imageManipulation.h
//  Wiggers
//
//  Created by Ben Smith on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SaveImage.h"
#import "GADBannerView.h"
#import "CameraVC.h"
#import "SHK.h"
#import "TestFlight.h"
#import "Constants.h"
#import "UIImage+Extensions.h"
#import "SHK.h"
#import "TestFlight.h"
#import "Constants.h"
#import "FaceImageProcessing.h"
#import "faceFeature.h"
#import <AudioToolbox/AudioToolbox.h>
#include <sys/time.h>
#import <AVFoundation/AVFoundation.h>
#import "Sound.h"

#import "IAPStoreManager.h"
#import "IAPProduct.h"
#import  "SFHFKeychainUtils.h"


@protocol failedToDetectFeature
- (void)noFeaturesDetected;
@end

@interface ImageManipulationVC : UIViewController <UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,IAPProductObserver> {
    //Image Views for body parts
    NSArray *arrayOfFaceParts;
    NSDictionary *dictOfFaceParts;
    UIToolbar *imageControls;
    
    //Scale manipulate image
    UIView *canvas;
    NSArray *featuresLocalInstance;
    
    //Toolbar stuff
    UIToolbar *toolBar;
    UIBarButtonItem *share;
    UIBarButtonItem *saveImage;
    UIBarButtonItem *takeNewImage;
    UIBarButtonItem *ok;
    UIBarButtonItem *mouths;
    UIBarButtonItem *eyes;
    UIBarButtonItem *scars;
    NSArray *saveToolBarItems;
    NSArray *okToolBarItems;
    
    //Save Text box
    UITextField * alertTextField;
    
    //Pan gestures
    UIPinchGestureRecognizer *pinchRecognizer;
    UIPanGestureRecognizer *panRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
    UITapGestureRecognizer *tapProfileImageRecognizer;
    
    //ADmobs
    GADBannerView *bannerView_;
    
    //Animate Counter
    int count;
    
    //Instance face processing class
    FaceImageProcessing *imageProcessing;
    
    //Marque round selected image part
    CAShapeLayer *_marque;
    
    //buttons on scroll view containing face parts
    NSMutableArray *mouthButtons;
    NSMutableArray *rightEyeButtons;
    NSMutableArray *leftEyeButtons;
    NSMutableArray *scarButtons;
    NSMutableArray *buttons;
    
    //show or hide the containers
    BOOL showMouthContainer;
    BOOL showEyeContainer;
    BOOL showScarContainer;
    
    //arrays to hold different features drawn on face, editedFaceFeatures is key, it holds all the faceFeatures that are currently being displayed on the face
    NSMutableArray *editedFaceFeatures;
    
    NSMutableArray *faceImageViews;
    NSMutableArray *sideBurnImageViews;
    NSMutableArray *jerseyImageViews;
    
    Sound *soundPlayer;
    
    __weak id <failedToDetectFeature> delegate;
}
/** This is object to access the in app purchase wrapper*/
@property (nonatomic,strong) IAPProduct *product;
/**  Twitter tag label on images*/
@property (weak, nonatomic) IBOutlet UILabel *wiggofy;
/** Label appearing at bottom of screen if we so wish*/
@property (weak, nonatomic) IBOutlet UILabel *supportBrad;
/** The scroll view container for the mouth parts*/
@property (nonatomic, strong) IBOutlet UIView *mouthScrollViewContainer;
/** The scroll view that contains the mouth parts*/
@property (nonatomic, strong) IBOutlet UIScrollView *mouthScrollView;
/** Scroll View Container for the eyes*/
@property (nonatomic, strong) IBOutlet UIView *eyeScrollViewContainer;
/** Scroll view of the eye parts*/
@property (nonatomic, strong) IBOutlet UIScrollView *eyeScrollView;
/** Scar Scroll view container*/
@property (nonatomic, strong) IBOutlet UIView *scarScrollViewContainer;
/** Scar Scroll view*/
@property (nonatomic, strong) IBOutlet UIScrollView *scarScrollView;
/** This is the delegate used to call back the MainScreen to tell it that face detection has failed and so needs to ask for another image*/
@property (weak) id <failedToDetectFeature> delegate;
/** Array to locally hold the detected features*/
@property (nonatomic,strong) NSArray *featuresLocalInstance;
/** The loading View screen*/
@property (weak, nonatomic) IBOutlet UIView *loadingView;
/** The loading view text that appears*/
@property (weak, nonatomic) IBOutlet UILabel *loadingText;
/** Loading wheel for the text*/
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingWheel;
/** */
@property (nonatomic, strong) UIImageView *activeImageView;
///** */
//@property (nonatomic, strong) IBOutlet UILabel *height;
///** */
//@property (nonatomic, strong) IBOutlet UILabel *width;
///** */
//@property (nonatomic, strong) IBOutlet UILabel *xCoord;
///** */
//@property (nonatomic, strong) IBOutlet UILabel *yCoord;

/** This is an instance of the CameraVC so we can open the camera and take an image*/
@property (nonatomic, retain) CameraVC *cameraVC;

/** This shows and alertbox when the user tries to save an image if they have not entered a name or whatever
 */
-(void)alertSaveBox;

/** This method keeps looping until we have either detected 0 features or the counter has reached 8, if at any point 0 features are detected and error is thrown
 */
- (void)showLoadingText;

/** Allows custom buttons to be created with their own size text and font
 */
- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize;

/** Called when image detection has finished, determines what happens if a face is detected or not, giving the user information about what to do next
 */
-(void)ImageDetectionFinished;

/** Notification received from the image processing class getting the face Features
 @param notification This notification contains an array of the face features detected
 */
- (void) receiveImagefeatures:(NSNotification *) notification;

/** Used to show a container
 @param container The UIView of the container we want to show
 @param containerTypeParam The type of container to show or hide, mouth, eyes or scars
 */
-(void)showContainer:(UIView*)container withTag:(containerType)containerTypeParam;

/** Used to hide a container
 @param container The UIView of the container we want to hide
 @param containerTypeParam The type of container to hide or hide, mouth, eyes or scars
 */
-(void)hideContainer:(UIView*)container withTag:(containerType)containerTypeParam;

/**loads the scroll view for the mouths getting all the image and making buttons out of them
 */
-(void)loadMouthScrollView;

/**loads the scroll view for the eyes getting all the image and making buttons out of them 
 */
-(void)loadEyeScrollView;

/**loads the scroll view for the scars getting all the image and making buttons out of them
 */
-(void)loadScarScrollView;

/**Create new left sideburn parts to add onto the image
 @param sender The ID of the button that was pressed so we know what to add onto the image
 */
-(void)createNewLeftSBParts:(id)sender;
-(void)createNewRightSBParts:(id)sender;
-(void)createNewScarParts:(id)sender;
-(void)createNewMedalParts:(id)sender;

/** This method is key to adding features onto the face, the actual image processing doesn't happen here but is passed into the FaceImageProcessing class, it is called from the createNew... methods passing in the different features about the face feature to add
 @param faceFeatureParam
 @param feature
 @param featureType
 @param sender
 @param facePartsArray
 @return faceFeature the face feature that has been added to the image is returned to the createNew... method that called it and added to the editedImagesarray
 */
-(faceFeature*)updateFaceFeature:(faceFeature*)faceFeatureParam withCIFaceFeature:(CIFaceFeature*)feature withFaceFeatureType:(faceFeatureType)featureType withSender:(id)sender fromArray:(NSArray*)facePartsArray;


#pragma mark - Manipulate Image
-(void)showOverlayWithFrame:(CGRect)frame;

-(void)scale:(id)sender;

-(void)rotate:(id)sender;


-(void)move:(id)sender;
#pragma mark Gesture recognizer actions

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)tapped:(id)sender;

#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
