//
//  ImageProcessing.m
//  Wiggers
//
//  Created by Ben Smith on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceImageProcessing.h"
 
@implementation FaceImageProcessing
@synthesize activeFacePart,features,doneEditing,objectMoving,activeImageView,canvas;


-(id)init{
    if (self = [super init]) {
        doneEditing = FALSE;
        objectMoving = FALSE;

	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Carry out face detection on a given image
+(void)processFace:(UIImage*)faceImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        CIImage *imageToScan = [[CIImage alloc]initWithImage:faceImage];

        //NSString *accuracy = CIDetectorAccuracyHigh;
        NSNumber *orientation = [NSNumber numberWithInt:[faceImage imageOrientation]+1];
        NSDictionary *options = [NSDictionary dictionaryWithObject:orientation forKey: CIDetectorImageOrientation];
        //NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        
        
        NSArray *features = [detector featuresInImage:imageToScan];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObject:features forKey:@"features"]; 
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:@"featuresNotification" 
             object:self userInfo:dict];
        });
        
    });  

}


#pragma mark - DrawImage
-(NSMutableArray*)drawFeaturesAnnotatedWithImageViews{
    
    //intialise local faceFeatures array
    NSMutableArray *faceFeatures = [[NSMutableArray alloc]init];
    UIImage *faceImage = activeImageView.image;
    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    [faceImage drawInRect: activeImageView.bounds];
    
    // Get image context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(context, 0, activeImageView.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    
    
    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    
    //Iterate through the features found in the image
    for (CIFaceFeature *feature in features){
        
        //Test code used to draw a box around the detected face
//        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        CGContextSetLineWidth(context, 2.0f * scale);
//        CGContextAddRect(context, f.bounds);
//        CGContextDrawPath(context, kCGPathFillStroke);
        CIFaceFeature *f = feature;
        
        //Setup the face features that are initially drawn onto the image
        UIImageView *mouthParts = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[MOUTH_PARTS objectAtIndex:0]]];
        //then draw them onto the face
        faceFeature *tempFaceFeature = [self drawFeature:f withRect:f.bounds ofType:mouthType withImage:mouthParts atPoint:f.bounds.origin];
        //set them as shown
        tempFaceFeature.isShown = YES;
        //add them to the array that we pass back
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *leftSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[LEFTEYE_PARTS objectAtIndex:0]]];
        tempFaceFeature = [self drawFeature:f withRect:f.bounds ofType:leftEyeType withImage:leftSB atPoint:f.bounds.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *rightSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[RIGHTEYE_PARTS objectAtIndex:0]]];
        tempFaceFeature = [self drawFeature:f withRect:f.bounds ofType:rightEyeType withImage:rightSB atPoint:f.bounds.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *scar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[SCAR_PARTS objectAtIndex:0]]];
        tempFaceFeature = [self drawFeature:f withRect:f.bounds ofType:scarType withImage:scar atPoint:f.bounds.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        
        
    }
    
    if ([features count] == 0 ) {
        CGRect estimatedFace = CGRectMake(50, 50, 200, 200);
        //Setup the face features that are initially drawn onto the image
        UIImageView *mouthParts = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[MOUTH_PARTS objectAtIndex:0]]];
        //then draw them onto the face
        faceFeature *tempFaceFeature = [self drawFeature:nil withRect:estimatedFace ofType:mouthType withImage:mouthParts atPoint:estimatedFace.origin];
        //set them as shown
        tempFaceFeature.isShown = YES;
        //add them to the array that we pass back
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *leftSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[LEFTEYE_PARTS objectAtIndex:0]]];
        tempFaceFeature = [self drawFeature:nil withRect:estimatedFace ofType:leftEyeType withImage:leftSB atPoint:estimatedFace.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *rightSB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[RIGHTEYE_PARTS objectAtIndex:0]]];
        tempFaceFeature = [self drawFeature:nil withRect:estimatedFace ofType:rightEyeType withImage:rightSB atPoint:estimatedFace.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
        
        UIImageView *scar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[SCAR_PARTS objectAtIndex:0]]];
        tempFaceFeature = [self drawFeature:nil withRect:estimatedFace ofType:scarType withImage:scar atPoint:estimatedFace.origin];
        tempFaceFeature.isShown = YES;
        [faceFeatures addObject:tempFaceFeature];
    }
    //make sure we set the activeimageview image to that of the graphics context so we now draw the annotated features onto the screen
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return faceFeatures;
}

#pragma mark - Draw text
- (UILabel*) drawText:(NSString*) text
            InUILabel:(UILabel*)label
            withFrame:(CGRect)frame
               colour:(UIColor*)colour
           ofFontType:(UIFont*)fontParam
{
    label.layer.cornerRadius = 8;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = colour;
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.7;
    label.frame = frame;
    [label setFont:fontParam];
    
    return label;
}

- (UIImage*) drawText:(NSString*) text
              inImage:(UIImage*)  image
              atPoint:(CGPoint)   point
               ofSize:(int)textSize
               colour:(UIColor*)colour
           ofFontType:(UIFont*)fontParam
{
    // Get image context reference
    UIFont *font = fontParam;
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [colour set];
    
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     colour, NSForegroundColorAttributeName,
                                     font, NSFontAttributeName, nil];
                                    
    [text drawAtPoint:point withAttributes:fontAttribute];
     //drawAtPoint:point withFont:font];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}


//this is called when the save image button is pressed
-(void)setImageWithImageViews:(NSMutableArray*)faceFeatures{
    UIImage *faceImage = activeImageView.image;

    UILabel *wiggofy = [[UILabel alloc]initWithFrame:CGRectMake(10,5,155,37)];
    wiggofy = [self drawText:@"@Zzombiefy" InUILabel:wiggofy withFrame:wiggofy.frame colour:[UIColor whiteColor] ofFontType:[UIFont fontWithName:FONT_TYPE size:25]];

    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    [faceImage drawInRect:activeImageView.bounds];
    
    // Get image context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip Context
    CGContextTranslateCTM(context, 0, activeImageView.bounds.size.height);
    CGContextScaleCTM(context, _lastScale, _lastScale);
    
    CGFloat scale = _lastScale;
    
    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }
    
    
    
    for (faceFeature *faceparts in faceFeatures) {
        if(faceparts.isShown)
            [activeImageView addSubview:faceparts.featureImageView];
    }
    [activeImageView addSubview:wiggofy];
    
    //render it into the activeImageView then we can post or whatever
    [activeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    activeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    activeImageView.image = [self dumpOverlayViewToImage];
    activeFacePart = nil;
    
    
}


- (faceFeature*)drawFeature:(CIFaceFeature*)f withRect:(CGRect)faceRect ofType:(faceFeatureType)featureType withImage:(UIImageView*)imageView atPoint:(CGPoint)featurePoint{

    //Calcualte the size of sideburns according to the face size
    CGFloat leftSBScaleWidth = faceRect.size.width*1/4;
    CGFloat leftSBScaleHeight = faceRect.size.height*1/1.8;
    CGFloat rightSBScaleWidth = faceRect.size.width*1/4;
    CGFloat rightSBScaleHeight = faceRect.size.height*1/1.8;
    
    //get face size and height and store in variables (used to scale everything else)
    CGFloat faceWidth = faceRect.size.width;
    CGFloat faceHeight = faceRect.size.height;
    
    
    // CoreImage coordinate system origin is at the bottom left corner and UIKit's
    // is at the top left corner. So we need to translate features positions before
    // drawing them to screen. In order to do so we make an affine transform
    transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform,
                                           0, -activeImageView.bounds.size.height);
    
    CGPoint leftEye;
    CGPoint rightEye;
    CGPoint mouth;
    if(f == nil)
    {
        leftEye = CGPointMake(faceRect.origin.x + faceRect.size.width/3, faceRect.origin.y + faceRect.size.height/1.5);
        rightEye = CGPointMake(faceRect.origin.x + faceRect.size.width - faceRect.size.width/3, faceRect.origin.y + faceRect.size.height/1.5);
        mouth = CGPointMake(faceRect.origin.x + faceRect.size.width/2, faceRect.origin.y + faceRect.size.height/3);
    }
    else{
        leftEye = f.leftEyePosition;
        rightEye = f.rightEyePosition;
        mouth = f.mouthPosition;
    }
    

    faceFeature *newFaceFeature = [[faceFeature alloc]init];
    if(f == nil)
    {
        newFaceFeature.fakeRect = faceRect;
        
    }
    else
    {
        newFaceFeature.featureBelongsToo = f;
    }
    switch (featureType) {
        case 1:// left eye
            //if(f.hasLeftEyePosition)
            {
                // Get the mouth position translated to imageView UIKit coordinates
                CGPoint eyePos = CGPointApplyAffineTransform(leftEye, transform);
                //scale the mouth image size according to the dimensions of the face
                imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(faceWidth*0.4,faceHeight*0.4)];
                //set frame of mouth image to be equal to that of the image, but adjust the x and y coords slightly as they are offset by scaling of the image
                imageView.frame = CGRectMake(eyePos.x-imageView.image.size.width/2,eyePos.y-imageView.image.size.width/2,imageView.image.size.width, imageView.image.size.height );
                //set the newFaceFeature objects type
                [newFaceFeature setType:featureType];
                //set the newFaceFeature objects imageView
                newFaceFeature.featureImageView = imageView;
                //set the newFaceFeature objects CIFaceFeature variable

            }
            break;
        case 2:// right eye
            //if(f.hasRightEyePosition)
            {
                // Get the mouth position translated to imageView UIKit coordinates
                CGPoint eyePos = CGPointApplyAffineTransform(rightEye, transform);
                imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(faceWidth*0.4,faceHeight*0.4)];
                imageView.frame = CGRectMake(eyePos.x-imageView.image.size.width/2,eyePos.y-imageView.image.size.width/2,imageView.image.size.width, imageView.image.size.height );
                [newFaceFeature setType:featureType];
                newFaceFeature.featureImageView = imageView;
            }
            break;
        case 3:// mouth
            //if(f.hasMouthPosition)
            {
                // Get the mouth position translated to imageView UIKit coordinates
                CGPoint mouthPos = CGPointApplyAffineTransform(mouth, transform);
                                
                imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(faceWidth*0.6,faceHeight*0.6)];
                imageView.frame = CGRectMake(mouthPos.x-imageView.image.size.width/2,mouthPos.y-imageView.image.size.height/2,imageView.image.size.width, imageView.image.size.height );
                [newFaceFeature setType:featureType];
                newFaceFeature.featureImageView = imageView;
            }
            break;
        case 4://hair
            imageView.image = [imageView.image imageByScalingProportionallyToSize: CGSizeMake(f.bounds.size.width + f.bounds.size.width/4, f.bounds.size.height + f.bounds.size.height/6)];
            imageView.frame = CGRectMake(f.bounds.origin.x-f.bounds.size.width/8.5, IMG_HEIGHT - (f.bounds.origin.y + f.bounds.size.height + f.bounds.size.height/2 ), imageView.image.size.width,imageView.image.size.height);            
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            break;
        case 5:// left sideburn
            imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(leftSBScaleWidth,leftSBScaleHeight)];
            imageView.frame = CGRectMake(f.bounds.origin.x, IMG_HEIGHT - (f.bounds.origin.y + imageView.image.size.height + f.bounds.size.height/4), imageView.image.size.width, imageView.image.size.height);
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            
            break;
        case 6:// right sideburn
            imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(rightSBScaleWidth, rightSBScaleHeight)];
            imageView.frame = CGRectMake(f.bounds.origin.x + f.bounds.size.width - imageView.image.size.width, IMG_HEIGHT - (f.bounds.origin.y + imageView.image.size.height + f.bounds.size.height/4),  imageView.image.size.width, imageView.image.size.height );
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            break;
        case 7:// scarType

           imageView.image = [imageView.image imageByScalingProportionallyToSize:CGSizeMake(faceWidth*0.3,faceHeight*0.3)];
            imageView.frame = CGRectMake(f.bounds.origin.x + (faceWidth*0.7 - imageView.image.size.width/2), IMG_HEIGHT - (f.bounds.origin.y + faceHeight*0.9 + imageView.image.size.height), imageView.image.size.width, imageView.image.size.height);
            [newFaceFeature setType:featureType];
            newFaceFeature.featureImageView = imageView;
            break;
        default:
            break;
    }
    //return the new faceFeature object we have created so it can be stored in an array of objects of faceFeatures
    return newFaceFeature;
}

/*To add an overlay image to the camera image you must specify the overlay image here
 */
- (UIImage*)dumpOverlayViewToImage{
	CGSize imageSize = activeImageView.bounds.size;
	UIGraphicsBeginImageContext(imageSize);
	[activeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

/*Pass in the base image from the camera here
 */
- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage {
    UIImage* result;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        UIImage *overlayImageLocal = [self dumpOverlayViewToImage];
        CGPoint topCorner = CGPointMake(_firstX, _firstY);
        
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
        CGPoint topCorner = CGPointMake(_firstX, _firstY);
        
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


#pragma mark - Manipulate Image

-(void)showOverlayWithFrame:(CGRect)frame withMarque:(CAShapeLayer*)_marque{
    
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
//    self.xCoord.text = [NSString stringWithFormat:@"%f", _firstX];
//    self.yCoord.text = [NSString stringWithFormat:@"%f", _firstY];
    
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
    
}

-(void)scale:(id)sender withView:(UIView*)view{
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = activeFacePart.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [activeFacePart setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
//    self.height.text = [NSString stringWithFormat:@"%f", activeFacePart.frame.size.height];
//    self.width.text = [NSString stringWithFormat:@"%f", activeFacePart.frame.size.width];
    
    
}

-(void)rotate:(id)sender withView:(UIView*)view{
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    //NSLog(@"rotation %f",rotation);
//    self.rotationLabel.text = [NSString stringWithFormat:@"%f", rotation];
    CGAffineTransform currentTransform = activeFacePart.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [activeFacePart setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}


-(void)move:(id)sender withView:(UIView*)view withEditedFaceFeatures:(NSMutableArray*)editedFaceFeatureParam{
    
    CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:view];
    for (faceFeature *facePart in editedFaceFeatureParam) {
        if (CGRectContainsPoint(facePart.featureImageView.frame, touchPoint) && !objectMoving)
        {
            activeFacePart = facePart.featureImageView;
        }
    }
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [activeFacePart center].x;
        _firstY = [activeFacePart center].y;
        
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [activeFacePart setCenter:translatedPoint];

}



@end
