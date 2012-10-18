//
//  ImageProcessing.h
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Extensions.h"
#import "faceFeature.h"
#import "UIImageView + Extenstions.h"


@interface FaceImageProcessing:NSObject {
    NSArray *features;
    NSArray *arrayOfImagesToAdd;
    NSDictionary *imagesToAdd;
    UIImageView *activeImageView;
    UIView *canvas;
    
    
    CGFloat _lastScale;
	CGFloat _lastRotation;
	CGFloat _firstX;
	CGFloat _firstY;
    
    UIImageView *activeFacePart;
    BOOL objectMoving;
    BOOL doneEditing;
    CGAffineTransform transform;
}
/** This is the canvas that we want to draw the activeImageView object onto*/
@property(nonatomic,strong)UIView *canvas;
/** This is the activeImageView that we want to draw onto */
@property(nonatomic,strong)UIImageView *activeImageView;
/** This is the currently selected face part that we want to draw onto the activeImageView*/
@property(nonatomic,strong)UIImageView *activeFacePart;
/** This is an array of face features picked up by face Detection*/
@property(nonatomic,strong)NSArray *features;
/** This is set to TRUE when the user removes their fingers from the screen after scaling or rotating*/
@property(nonatomic)BOOL doneEditing;
/** This is set to TRUE when the user has tapped on an object and is moving the object across the screen*/
@property(nonatomic)BOOL objectMoving;

/** Process the face features, finding the eyes, mouth and face and then send the array of features out through a notification
 *@param faceImage This is the UIImage of the face that we want to detect the features of
 */
+ (void)processFace:(UIImage*)faceImage;

/**Draw some initial features onto the face using the facefeatures array
 @return An array of the features that have been added onto the face so we know what is there
 */
- (NSMutableArray*)drawFeaturesAnnotatedWithImageViews;

/**A method to draw text on an image at any position
 @param NSString of the text to draw on image
 @param UIImage to draw onto
 @param CGPoint the point to draw the text at on the image
 @return the image to return with the text drawn onto
 */
- (UIImage*) drawText:(NSString*)text inImage:(UIImage*)image atPoint:(CGPoint)point;

/**A method to draw text onto a UILabel with any position, colour and fontType
 @param NSString of the text to draw
 @param UILabel is the label we want to draw the text in
 @param CGRect this is the frame size of the UILabel
 @param UIColor this is the color of the Text in the label
 @param UIFont this is the font type used in the UILabel
 */
- (UILabel*) drawText:(NSString*) text InUILabel:(UILabel*)label withFrame:(CGRect)frame colour:(UIColor*)colour ofFontType:(UIFont*)fontParam;

/**Adds and overly image to the base image that is passed and returns a merged image
 @param baseImage that is passed into add an overlay onto
 @return UIImage is the image that is returned
 */
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage;

/**Renders two images together, one over the other called from addOverlayToBaseImage
 @return UIImage the flattened image is returned
 */
- (UIImage*)dumpOverlayViewToImage;

/**This is called when the save image button is pressed, and flattens the camera image and the face features so that they are one image
 @param faceFeatures This is an array of face features that are added onto the image
 */
- (void)setImageWithImageViews:(NSMutableArray*)faceFeatures;

/**This draws the features on the areas picked up by face detection, it can draw on hair, eyes, sideburns, mouth and scars
 @param f This is a CIFaceFeature object that is returned by the face detection algorithm, it contains eyes, face and mouth positions and size
 @param featureType This is custom object type, used to ID if it is a eyes, mouth, hair, scar etc type feature
 @param imageView This is the imageView of the feature we want to add
 @param featurePoint This is the point we want to add the feature at
 */
- (faceFeature*)drawFeature:(CIFaceFeature*)f ofType:(faceFeatureType)featureType withImage:(UIImageView*)imageView atPoint:(CGPoint)featurePoint;

/**This is called to highlight the currently selected overlay with a scrolling marque, so the user knows which one is selected
 @param frame This is the frame for the selected object
 @param _marque This is the marque object so we can make it visible
 */
- (void)showOverlayWithFrame:(CGRect)frame withMarque:(CAShapeLayer*)_marque;

/**Called when the user selects a face part and wants to scale it
 @param sender This ID's what object called this scale method
 @param view This is the view of the object that called this scale method
 */
- (void)scale:(id)sender withView:(UIView*)view;

/**This is called when the user wants to rotate a currently selected object
 @param sender This ID's what object called this rotate method
 @param view This is the view of the object that called this rotate method
 */
- (void)rotate:(id)sender withView:(UIView*)view;

/**This is called when the user wants to move the currently selected object
 @param sender This ID's what object called this move method
 @param view This is the view of the object that called this move method
 */
- (void)move:(id)sender withView:(UIView*)view withEditedFaceFeatures:(NSMutableArray*)editedFaceFeatureParam;
@end
