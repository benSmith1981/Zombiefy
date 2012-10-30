//
//  NSObject_Constants.h
//  Wiggers
//
//  Created by Ben Smith on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define IMG_HEIGHT 386.0f
#define IMG_WIDTH 320.0f
#define IMG_X 0.0f
#define IMG_Y 0.0f
#define AD_Y_POSITION 430.0f
#define AD_X_POSITION 0.0f
#define AD_HEIGHT 50.0f
#define AD_WIDTH 320.0f
#define TOOLBAR_Y_POSITION 386.0f
#define TOOLBAR_X_POSITION 0.0f
#define TOOLBAR_HEIGHT 44.0f
#define TOOLBAR_WIDTH 320.0f

#define TITLE_HEIGHT 66.0f
#define TITLE_WIDTH 320.0f
#define TITLE_FONT_SIZE 30.0f

#define IMG_HEIGHT_NO_ADS 436.0f
#define IMG_WIDTH_NO_ADS 320.0f
#define TOOLBAR_Y_POSITION_NO_ADS 436.0f
#define TOOLBAR_X_POSITION_NO_ADS 0.0f

#define OVERLAY_ALPHA 1.0f
#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1

#define kInAppPurchaseProductID @"com.BenSmithInc.Zombify.ZombiePack"

#define kHairKey 1
#define krightSBKey 2
#define kleftSBKey 3

#define TAG_GRAYVIEW 5671263 // for overlay on selected buttons

#define FONT_TYPE @"DOUBLE FEATURE"

#define KEY_CHAIN_USERNAME @"ZOMBIE"
#define KEY_CHAIN_PASSWORD @"ZOMBIE_PASSWORD"
#define KEY_SERVICE_NAME @"ZOMBIE_PACK"

#define IMG(name) [UIImage imageNamed:name]
//#define FACE_IMAGE_NAMES [NSArray arrayWithObjects:@"mouth.png",@"mouth2.png", @"lefteye.png", @"lefteye2.png",  @"righteye.png",@"righteye2.png",nil]
//@"yellowJumper1.png",@"yellowJumper2.png",@"medal.png", nil]

//#define FACE_PARTS [NSArray arrayWithObjects:IMG(@"mouth.png"),IMG(@"mouth2.png"),IMG(@"lefteye.png"),IMG(@"lefteye2.png") , IMG(@"righteye.png"),IMG(@"righteye2.png"),nil]
//,IMG(@"yellowJumper1.png"),IMG(@"yellowJumper2.png"),IMG(@"medal.png"), nil]


//[NSArray arrayWithObjects:IMG(@"betterHairScaled.png"),  IMG(@"rightlargesideburnScaled.png"),IMG(@"leftlargesideburnScaled.png"), IMG(@"yellowJumper.png"), IMG(@"hair.png"), nil]
//
#define SELECTED_IMAGE IMG(@"Green_tick.png")
#define PADLOCK_IMAGE IMG(@"padlock.png")
#define SOUNDBUTTONIMAGE IMG(@"X.png")

#define NUM_FREE_FEATURES 3

#define MOUTH_PARTS [NSArray arrayWithObjects:@"mouth1.png",@"mouth2.png",@"mouth3.png",@"mouth4.png",@"mouth5.png",@"mouth6.png",@"mouth7.png",@"mouth8.png",@"mouth9.png",@"mouth10.png",@"mouth11.png", nil]
#define LEFTEYE_PARTS [NSArray arrayWithObjects:@"lefteye1.png",@"lefteye2.png",@"lefteye3.png",@"lefteye4.png",@"lefteye5.png",@"lefteye6.png",@"lefteye7.png",@"lefteye8.png", nil]
#define RIGHTEYE_PARTS [NSArray arrayWithObjects:@"righteye1.png",@"righteye2.png",@"righteye3.png",@"righteye4.png",@"righteye5.png",@"righteye6.png",@"righteye7.png", @"righteye8.png",nil]
#define EYE_PARTS [NSArray arrayWithObjects:@"righteye1.png",@"lefteye1.png",@"righteye2.png",@"lefteye2.png",@"righteye3.png",@"lefteye3.png",@"righteye4.png",@"lefteye4.png",@"righteye5.png",@"lefteye5.png",@"righteye6.png",@"lefteye6.png",@"righteye7.png",@"lefteye7.png",@"righteye8.png",@"lefteye8.png", nil]

#define SCAR_PARTS [NSArray arrayWithObjects:@"scar1.png",@"scar2.png",@"scar3.png",@"scar4.png",@"scar5.png", nil]

#define sounds [NSArray arrayWithObjects:@"TheUndead.mp3",@"laugh.mp3", nil]
//#define sounds [NSArray arrayWithObjects:@"TheUndead.mp3", nil]

//#define FACE_KEYS [NSArray arrayWithObjects:@"hair",@"leftSB",@"rightSB",@"yellowJumper",@"hair", nil]

typedef enum {
    mouthContainer = 1,
    scarContainer = 2,
    eyeContainer = 3
    
} containerType;

typedef enum {
    leftEyeType = 1,
    rightEyeType = 2,
    mouthType = 3,
    hairType = 4,
    leftSBType = 5,
    rightSBType = 6,
    scarType
    
} faceFeatureType;

