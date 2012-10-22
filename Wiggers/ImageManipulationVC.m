//
//  imageManipulation.m
//  Wiggers
//
//  Created by Ben Smith on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageManipulationVC.h"


@interface ImageManipulationVC ()

@end
//#define IMG_WIDTH 320.0f
//#define IMG_HEIGHT 396.0f

@implementation ImageManipulationVC
@synthesize wiggofy,supportBrad;
@synthesize mouthScrollView,mouthScrollViewContainer;
@synthesize eyeScrollView,eyeScrollViewContainer;
@synthesize scarScrollView,scarScrollViewContainer;
@synthesize featuresLocalInstance;
@synthesize delegate;
@synthesize loadingView;
@synthesize loadingText;
@synthesize loadingWheel;
@synthesize activeImageView;
//@synthesize xCoord,yCoord,width,height;
@synthesize cameraVC;
@synthesize product;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        //intialise toolbar
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(TOOLBAR_X_POSITION_NO_ADS, TOOLBAR_Y_POSITION_NO_ADS, TOOLBAR_WIDTH, TOOLBAR_HEIGHT)];
        }
        else {
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(TOOLBAR_X_POSITION, TOOLBAR_Y_POSITION, TOOLBAR_WIDTH, TOOLBAR_HEIGHT)];
        }
        
        toolBar.barStyle = UIBarStyleBlackTranslucent;

        
        //initialise toolbar buttons
        share =  [self customAddButtonItem:@"SHARE" WithTarget:self action:@selector(buttonPressed:) andTag:1 andTextSize:25 andTextColour:[UIColor blackColor] andButtonWidth:90.0f];
        saveImage =  [self customAddButtonItem:@"SAVE" WithTarget:self action:@selector(buttonPressed:) andTag:2 andTextSize:25 andTextColour:[UIColor blackColor] andButtonWidth:90.0f];
        takeNewImage =  [self customAddButtonItem:@"MAIN MENU" WithTarget:self action:@selector(buttonPressed:) andTag:3 andTextSize:15 andTextColour:[UIColor blackColor] andButtonWidth:90.0f];
        ok =  [self customAddButtonItem:@"DONE" WithTarget:self action:@selector(buttonPressed:) andTag:4 andTextSize:15 andTextColour:[UIColor redColor] andButtonWidth:70.0f];
        mouths =  [self customAddButtonItem:@"MOUTHES" WithTarget:self action:@selector(buttonPressed:) andTag:5 andTextSize:15 andTextColour:[UIColor blackColor] andButtonWidth:70.0f];
        eyes =  [self customAddButtonItem:@"EYES" WithTarget:self action:@selector(buttonPressed:) andTag:6 andTextSize:15 andTextColour:[UIColor blackColor] andButtonWidth:70.0f];
        scars =  [self customAddButtonItem:@"SCARS" WithTarget:self action:@selector(buttonPressed:) andTag:7 andTextSize:15 andTextColour:[UIColor blackColor] andButtonWidth:70.0f];



        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
        
        //create toolbar arrays
        saveToolBarItems = [NSArray arrayWithObjects:saveImage,flexItem, share,flexItem, takeNewImage, nil];
        okToolBarItems = [NSArray arrayWithObjects:ok,flexItem,mouths,flexItem,eyes,flexItem,scars, nil];
        //setup first toolbar
        [toolBar setItems:okToolBarItems animated:NO];
        
        [self.view addSubview:toolBar];
    
        mouthScrollViewContainer.hidden = YES;
        mouthScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, toolBar.frame.size.width, 44);
        [mouthScrollViewContainer setAlpha:0.8];
        showMouthContainer = FALSE;
        
        scarScrollViewContainer.hidden = YES;
        scarScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, toolBar.frame.size.width, 44);
        [scarScrollViewContainer setAlpha:0.8];
        showScarContainer = FALSE;
        
        eyeScrollViewContainer.hidden = YES;
        eyeScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, toolBar.frame.size.width, 44);
        [eyeScrollViewContainer setAlpha:0.8];
        showEyeContainer = FALSE;
        
        faceImageViews = [[NSMutableArray alloc]init];
        editedFaceFeatures = [[NSMutableArray alloc]init];
        
        for (NSString *faceParts in MOUTH_PARTS) {
            [faceImageViews addObject:[[UIImageView alloc]initWithImage:[UIImage imageNamed:faceParts]]];
        }
        for (NSString *faceParts in EYE_PARTS) {
            [faceImageViews addObject:[[UIImageView alloc]initWithImage:[UIImage imageNamed:faceParts]]];
        }
        for (NSString *faceParts in SCAR_PARTS) {
            [faceImageViews addObject:[[UIImageView alloc]initWithImage:[UIImage imageNamed:faceParts]]];
        }
        soundPlayer = [Sound retrieveSingleton];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:toolBar];
    toolBar.hidden = YES;
    [loadingWheel startAnimating];
    [self showLoadingText];
    
    //setup the product, and register as an observer, so we can restore purchases
    self.product = [[IAPStoreManager sharedInstance] productForIdentifier:kInAppPurchaseProductID];
    [self.product addObserver:self];
    
   // NSLog(@"height %f width %f",bannerView_.frame.size.height,bannerView_.frame.size.width);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        // Create a view of the standard size at the bottom of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.frame = CGRectMake(AD_X_POSITION,AD_Y_POSITION, AD_WIDTH, AD_HEIGHT);
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a15048c13360bc3";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        
        [self.view addSubview:bannerView_];
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }


    
    //set to false intially
    //doneEditing = FALSE;
        
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        canvas = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IMG_WIDTH_NO_ADS, IMG_HEIGHT_NO_ADS)];
    }
    else {
        canvas = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT)];
    }
    [self.view addSubview:canvas];
    
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [canvas addGestureRecognizer:panRecognizer];
    
    tapProfileImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [canvas addGestureRecognizer:tapProfileImageRecognizer];
    

    NSString *image =[MOUTH_PARTS objectAtIndex:0];
    imageProcessing.activeFacePart = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    if (!_marque) {
        _marque = [CAShapeLayer layer];
        _marque.fillColor = [[UIColor clearColor] CGColor];
        _marque.strokeColor = [[UIColor grayColor] CGColor];
        _marque.lineWidth = 1.0f;
        _marque.lineJoin = kCALineJoinRound;
        _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
        _marque.bounds = CGRectMake(imageProcessing.activeFacePart.frame.origin.x, imageProcessing.activeFacePart.frame.origin.y, 0, 0);
        _marque.position = CGPointMake(imageProcessing.activeFacePart.frame.origin.x + canvas.frame.origin.x, imageProcessing.activeFacePart.frame.origin.y + canvas.frame.origin.y);
    }

    [self.view sendSubviewToBack:canvas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveImagefeatures:) name:@"featuresNotification" object:nil];
    
}


- (void)viewDidAppear:(BOOL)animated{ 
    //animate in toolbar when view appears
    [super viewDidAppear:animated];
    [self loadEyeScrollView];
    [self loadMouthScrollView];
    [self loadScarScrollView];
//    [UIView beginAnimations:@"hideView" context:nil];
//    [UIView setAnimationDuration:0.7];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:toolBar cache:YES];
//    toolBar.frame = CGRectMake(0.0f,436.0f, 320, 44);
//    [UIView commitAnimations];
    count = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Image features Notification
- (void) receiveImagefeatures:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    //NSDictionary *dict = notification.userInfo; 
    NSArray *features = [notification.userInfo objectForKey:@"features"];
    featuresLocalInstance = features;
}
#pragma mark - Loading Text Animations

- (void)showLoadingText{
    //set loading text array
    NSString* allStrings[] = {@"Zombiefying", @"Eviling UP", @"Gouging Eyes", @"Fake Blooding", @"Mwhaaa!",@"Disgustifying",@"Channelling Spirits",@"Eating Brains",nil};
    
    //randomly select the loading text
    int randomNumber = arc4random()%8;
    NSString *tempStr = allStrings[randomNumber];
    
    //set loading text font size and colour
    [loadingText setFont:[UIFont fontWithName:FONT_TYPE size:25]];
    loadingText.text = tempStr;
    loadingText.textColor = [UIColor redColor];
    
    //increase the counter used to determine when loading text has been shown enough
    ++count;
    //set number of features to 1,so the method keeps looping until we have either detected 0 features or the counter has reached 8
    int numOfFeatures = 1;
    
    //Check if the featuresLocalInstance is not empty, in which case the notification method will have returned with the face features
    if (featuresLocalInstance != nil)
        //Find out how many features there are
        numOfFeatures = [featuresLocalInstance count];

    //if the counter is less than 8, and we have some features detected, call this method again after 0.8 seconds
    if (count <= 8 && numOfFeatures !=0)
        [self performSelector:@selector(showLoadingText) withObject:nil afterDelay:0.8];
    //if the counter has reached 8 or the no features are detected, or Both!! THen end the loading text animation
    else{
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1.0];
        self.loadingView.alpha = 0;
        [UIView commitAnimations];
        //call image detection to decide what happens now
        [self ImageDetectionFinished];
    }
    

    //loadingText.text = @"Wigifying you!";
}

#pragma mark - Customize Tool Bar Buttons

- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize andTextColour:(UIColor*)colour andButtonWidth:(float)buttonWidth{
    UIButton *customButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    customButtonView.frame = CGRectMake(0.0f, 0.0f,buttonWidth, 38.0f);
    customButtonView.tag = tag;
    
    //Get constraint size
    CGSize constraintSize;
    constraintSize.width = customButtonView.frame.size.width;
    constraintSize.height = customButtonView.frame.size.height;
    CGSize theSize = [title sizeWithFont:[UIFont fontWithName:FONT_TYPE size:textSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeMiddleTruncation];
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake((customButtonView.frame.size.width-theSize.width)/2, (customButtonView.frame.size.height-theSize.height)/2, theSize.width, theSize.height)];
    backLabel.font = [UIFont fontWithName:FONT_TYPE size:textSize];
    backLabel.text = title;
    backLabel.textColor = colour;
    
    [backLabel setBackgroundColor:[UIColor clearColor]];
    [customButtonView addSubview:backLabel];
    
    [customButtonView setBackgroundImage:
     [UIImage imageNamed:@"button.png"] 
                                forState:UIControlStateNormal];
    [customButtonView setBackgroundImage:
     [UIImage imageNamed:@"buttonPressed.png"] 
                                forState:UIControlStateHighlighted];
    
    [customButtonView setImage:
     [UIImage imageNamed:@"button.png"] 
                      forState:UIControlStateNormal];
    [customButtonView setImage:
     [UIImage imageNamed:@"buttonPressed.png"] 
                      forState:UIControlStateHighlighted];
    
    [customButtonView addTarget:target action:action 
               forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customButtonItem = [[UIBarButtonItem alloc] 
                                         initWithCustomView:customButtonView];
    customButtonItem.tag = tag;
    NSLog(@"%i",customButtonItem.tag);
    [customButtonView setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    
    //customButtonItem.imageInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    
    return customButtonItem;    
}

#pragma mark - Button action
- (void)buttonPressed:(id)sender {
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSLog(@"%@",button.title);
    //SAVE
    if (button.tag == 2){
        [self alertSaveBox];
    }
    //SHARE
    else if (button.tag == 1){
        SHKItem *item = [SHKItem image:self.
                         activeImageView.image title:@"Zombiefy, on app store now"];
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        [SHK setRootViewController:self];
        [actionSheet showFromToolbar:toolBar];
    }
    //BACK
    else if (button.tag == 3){
        self.activeImageView = nil;
        //deregister the observer
        [self.product removeObserver:self];

        [self.navigationController popViewControllerAnimated:YES];
        //Test flight build purposes only
        #warning Comment out before building for appstore!!
//        [TestFlight openFeedbackView];
//        UIAlertView *restorePopup = [[UIAlertView alloc]
//                                     initWithTitle:@"Please Enter feedback"
//                                     message:@"Did you love or hate the app? What is/isn't good about it? Your feedback is extremely important to me, and I would appreciate your time in letting me know. Once you have finished writing please press submit, and it will be sent to me, as if by magic!! Thanks"
//                                     delegate:nil
//                                     cancelButtonTitle:@"OK"
//                                     otherButtonTitles:nil];
//        [restorePopup show];

    }
    //Done
    else if (button.tag == 4){

        if (showEyeContainer) {
            [UIView beginAnimations:@"showView" context:nil];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:eyeScrollViewContainer cache:YES];
            eyeScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, eyeScrollViewContainer.frame.size.width, eyeScrollViewContainer.frame.size.height);
            eyeScrollViewContainer.alpha = 0;
            [UIView commitAnimations];
        }
        else if (showMouthContainer)
        {
            [UIView beginAnimations:@"showView" context:nil];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mouthScrollViewContainer cache:YES];
            mouthScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, mouthScrollViewContainer.frame.size.width, mouthScrollViewContainer.frame.size.height);
            mouthScrollViewContainer.alpha = 0;
            [UIView commitAnimations];
        }
        else if (showScarContainer){
            [UIView beginAnimations:@"showView" context:nil];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scarScrollViewContainer cache:YES];
            scarScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, scarScrollViewContainer.frame.size.width, scarScrollViewContainer.frame.size.height);
            scarScrollViewContainer.alpha = 0;
            [UIView commitAnimations];
        }

        
        showScarContainer = FALSE;
        showMouthContainer = FALSE;
        showEyeContainer = FALSE;
        
        [imageProcessing setImageWithImageViews:editedFaceFeatures];//View:self.activeImageView withFeatures:featuresLocalInstance OnCanvas:canvas];
        [canvas removeGestureRecognizer:pinchRecognizer];
        [canvas removeGestureRecognizer:tapProfileImageRecognizer];
        [canvas removeGestureRecognizer:panRecognizer];
        [canvas removeGestureRecognizer:rotationRecognizer];
        _marque.hidden = YES;
        
        imageProcessing.doneEditing = TRUE;
        [toolBar setItems:saveToolBarItems];
    }
    //Mouth ScrollView
    else if (button.tag == 5){
        if (!showMouthContainer) {
            if(showScarContainer)
            {
                [self hideContainer:scarScrollViewContainer withTag:scarContainer];
            }
            if (showEyeContainer) {
                [self hideContainer:eyeScrollViewContainer withTag:eyeContainer];
            }
            [self showContainer:mouthScrollViewContainer withTag:mouthContainer];
        }
        else
        {
            [self hideContainer:mouthScrollViewContainer withTag:mouthContainer];
//            showMouthContainer = FALSE;
//
//            [UIView beginAnimations:@"showView" context:nil];
//            [UIView setAnimationDuration:0.7];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mouthScrollViewContainer cache:YES];
//            mouthScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, mouthScrollViewContainer.frame.size.width, mouthScrollViewContainer.frame.size.height);
//            mouthScrollViewContainer.alpha = 0;
//            [UIView commitAnimations];
        }
        
    }
    
    //Eye scroll view
    else if (button.tag == 6){
        if (!showEyeContainer) {
            if(showScarContainer)
            {
                [self hideContainer:scarScrollViewContainer withTag:scarContainer];
            }
            if (showMouthContainer) {
                [self hideContainer:mouthScrollViewContainer withTag:mouthContainer];
            }
            [self showContainer:eyeScrollViewContainer withTag:eyeContainer];
//            showEyeContainer = TRUE;
//            [self.view bringSubviewToFront:eyeScrollViewContainer];
//            [self.view bringSubviewToFront:toolBar];
//            eyeScrollViewContainer.hidden = NO;
//            eyeScrollViewContainer.alpha = 1;
//            [UIView beginAnimations:@"showView" context:nil];
//            [UIView setAnimationDuration:0.7];
//            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mouthScrollViewContainer cache:YES];
//            eyeScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y-eyeScrollViewContainer.frame.size.height, eyeScrollViewContainer.frame.size.width, eyeScrollViewContainer.frame.size.height);
//            
//            [UIView commitAnimations];
        }
        else
        {
            [self hideContainer:eyeScrollViewContainer withTag:eyeContainer];
//            showEyeContainer = FALSE;
//            
//            [UIView beginAnimations:@"showView" context:nil];
//            [UIView setAnimationDuration:0.7];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:eyeScrollViewContainer cache:YES];
//            eyeScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, eyeScrollViewContainer.frame.size.width, eyeScrollViewContainer.frame.size.height);
//            eyeScrollViewContainer.alpha = 0;
//            [UIView commitAnimations];
        }
    }
    //Scar scroll view
    else if (button.tag == 7){
        if (!showScarContainer) {
            if(showMouthContainer)
            {
                [self hideContainer:mouthScrollViewContainer withTag:mouthContainer];
            }
            if (showEyeContainer) {
                [self hideContainer:eyeScrollViewContainer withTag:eyeContainer];
            }
            [self showContainer:scarScrollViewContainer withTag:scarContainer];

//            showScarContainer = TRUE;
//            [self.view bringSubviewToFront:scarScrollViewContainer];
//            [self.view bringSubviewToFront:toolBar];
//            scarScrollViewContainer.hidden = NO;
//            scarScrollViewContainer.alpha = 1;
//            [UIView beginAnimations:@"showView" context:nil];
//            [UIView setAnimationDuration:0.7];
//            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scarScrollViewContainer cache:YES];
//            scarScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y-scarScrollViewContainer.frame.size.height, scarScrollViewContainer.frame.size.width, scarScrollViewContainer.frame.size.height);
//            
//            [UIView commitAnimations];
        }
        else
        {
            [self hideContainer:scarScrollViewContainer withTag:scarContainer];
//            showScarContainer = FALSE;
//            
//            [UIView beginAnimations:@"showView" context:nil];
//            [UIView setAnimationDuration:0.7];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scarScrollViewContainer cache:YES];
//            scarScrollViewContainer.frame = CGRectMake(0.0f,toolBar.frame.origin.y, scarScrollViewContainer.frame.size.width, scarScrollViewContainer.frame.size.height);
//            scarScrollViewContainer.alpha = 0;
//            [UIView commitAnimations];
        }
    }
    
}

-(void)showContainer:(UIView*)container withTag:(containerType)containerTypeParam{
    if(containerTypeParam == scarContainer){
        showScarContainer = TRUE;
        showMouthContainer = FALSE;
        showEyeContainer = FALSE;
    }
    if(containerTypeParam == mouthContainer){
        showScarContainer = FALSE;
        showMouthContainer = TRUE;
        showEyeContainer = FALSE;
    }
    if(containerTypeParam == eyeContainer){
        showScarContainer = FALSE;
        showMouthContainer = FALSE;
        showEyeContainer = TRUE;
    }
    
    [self.view bringSubviewToFront:container];
    [self.view bringSubviewToFront:toolBar];
    container.hidden = NO;
    container.alpha = 1;
    [UIView beginAnimations:@"showView" context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:container cache:YES];
    container.frame = CGRectMake(0.0f,toolBar.frame.origin.y-container.frame.size.height, container.frame.size.width, container.frame.size.height);
    [UIView commitAnimations];
}

-(void)hideContainer:(UIView*)container withTag:(containerType)containerTypeParam{
    if(containerTypeParam == scarContainer){
        //showScarContainer = TRUE;
        showMouthContainer = FALSE;
        showEyeContainer = FALSE;
    }
    if(containerTypeParam == mouthContainer){
        showScarContainer = FALSE;
        //showMouthContainer = TRUE;
        showEyeContainer = FALSE;
    }
    if(containerTypeParam == eyeContainer){
        showScarContainer = FALSE;
        showMouthContainer = FALSE;
        //showEyeContainer = TRUE;
    }
    showScarContainer = FALSE;
    showMouthContainer = FALSE;
    showEyeContainer = FALSE;

    [UIView beginAnimations:@"showView" context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:container cache:YES];
    container.frame = CGRectMake(0.0f,toolBar.frame.origin.y, container.frame.size.width, container.frame.size.height);
    container.alpha = 0;
    [UIView commitAnimations];
    
}

#pragma mark - Save Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"Entered: %@",[alertTextField text]);
    
    if ([alertView.title isEqualToString:@"Zombiefy!"]) {

        if([[alertTextField text] isEqualToString:@""] && buttonIndex == 1) //invalid name and OK
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name!" message:@"Please enter a name to save:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }
        else if (buttonIndex == 1) //OK pressed
        {
            [SaveImage saveImage:activeImageView.image withFileName:[alertTextField text]];
        }
        else {
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
        }
    }
    else if ([alertView.title isEqualToString:@"No Evil Face Detected"])
    {
        if(buttonIndex == 0) //Main Menu
        {
            self.activeImageView = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1) //New Image
        {
            self.activeImageView = nil;
            [canvas removeFromSuperview];
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            [self.delegate noFeaturesDetected];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([alertView.title isEqualToString:@"Unlock ALL Zombie Features"])
    {
        if (buttonIndex == 0) {
            [self buyButtonTapped];
        }
        
    }
}

-(void)alertSaveBox{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Zombiefy!" message:@"Please enter your HELLISH name to save:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"File Name";
    [alert show];
}

#pragma mark - Alert View when image detection finished
-(void)ImageDetectionFinished
{
    //[soundPlayer fadeSound:soundPlayer.player];
    if ([featuresLocalInstance count] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Evil Face Detected" message:@"No Evil Face was detected, please take another image" delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:@"New Image",nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"To Adjust your face..." message:@"1)Tap mouth or eyes 2)Pinch, Flick and Rotate them, to fit to your face to complete Evilification!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        

        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoadingText) object: nil];
        [loadingWheel stopAnimating];
        toolBar.hidden = NO;

        //initialise the FaceImageProcessing intialise
        imageProcessing = [[FaceImageProcessing alloc]init];
        imageProcessing.canvas = canvas;
        imageProcessing.features = featuresLocalInstance;
        imageProcessing.activeImageView = self.activeImageView;
        
        //pass in the images we want to draw on the face
        editedFaceFeatures = [imageProcessing drawFeaturesAnnotatedWithImageViews];
        self.activeImageView = imageProcessing.activeImageView;
        
        [self.view addSubview:activeImageView];
        
        for (faceFeature *faceParts in editedFaceFeatures) {
            [self.view addSubview:faceParts.featureImageView];

        }
    
//        [self.view addSubview:[editedImageViews objectAtIndex:0]]; //Hair
//        [self.view addSubview:[editedImageViews objectAtIndex:1]];
//        [self.view addSubview:[editedImageViews objectAtIndex:2]];
        
        //add scrolling marque to indicate selected image
        [[self.view layer] addSublayer:_marque];
        //add info over canvas
        //[self.view bringSubviewToFront:Info];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
            [self.view bringSubviewToFront:bannerView_];
        }
        [self.view bringSubviewToFront:toolBar];
        
        
        [soundPlayer playSound:[soundPlayer.funnyClipsPlayer objectAtIndex:1] numberofTimes:1];
    }
}
-(void)drawPadlock:(UIButton*)padlockButton orSelectedButton:(UIButton*)selectButton onScrollView:(UIScrollView*)scrollView overImageWithString:(NSString*)imageString andButtonCounter:(int)selectedTag andAddToArray:(NSMutableArray*)buttonsArray withSelectedButtonString:(NSString*)selectedButtonString{
    if([self IAPItemPurchased])
    {
        if ([imageString isEqualToString:selectedButtonString])
        {
            [selectButton setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
            selectButton.selected = TRUE;
            
        }
        else
            [selectButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [scrollView addSubview:selectButton];
        [buttonsArray addObject:selectButton];
    }
    else
    {
        if (selectedTag <=NUM_FREE_FEATURES) {
            if ([imageString isEqualToString:selectedButtonString])
            {
                [selectButton setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
                selectButton.selected = TRUE;
                
            }
            else
                [selectButton setBackgroundImage:nil forState:UIControlStateNormal];
            
            [scrollView addSubview:selectButton];
            [buttonsArray addObject:selectButton];
            
            
        }
        else{
            [padlockButton setBackgroundImage:PADLOCK_IMAGE forState:UIControlStateNormal];
            [padlockButton setBackgroundImage:PADLOCK_IMAGE forState:UIControlStateSelected];
            [scrollView addSubview:padlockButton];
            [buttonsArray addObject:padlockButton];
        }
    }
}

-(void)loadMouthScrollView{
    
    //Make the buttons on the Scrollview match up to the images in our face parts array
    int selectedTag = 0;
    mouthButtons = [[NSMutableArray alloc]init];

    UIButton *selectButton;
    UIButton *padlockButton;

    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.mouthScrollView.frame.size;
    int buttonHeight = pagesScrollViewSize.height;
    int buttonWidth = pagesScrollViewSize.height;
    
    //setup mouth scroll view
    CGRect frame;
    int page = 0;
    
    for (NSString *hair in MOUTH_PARTS) {
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton addTarget:self action:@selector(mouthButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.tag = selectedTag;
        
        padlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [padlockButton addTarget:self action:@selector(AdFreePurchase:) forControlEvents:UIControlEventTouchUpInside];
        //padlockButton.tag = tag;
        selectedTag++;
        
        frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        frame.origin.x = (buttonWidth + 10) * page ;
        frame.origin.y = 0.0f;
        selectButton.frame = frame;
        padlockButton.frame = frame;
        UIImageView *buttonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:hair]];
        buttonImageView.frame = frame;
        
        [self.mouthScrollView addSubview:buttonImageView];

        [self drawPadlock:padlockButton orSelectedButton:selectButton onScrollView:mouthScrollView overImageWithString:hair andButtonCounter:selectedTag andAddToArray:mouthButtons withSelectedButtonString:@"mouth1.png"];
        

        page++;
    }
    int numberOfButtons = [mouthButtons count];
    self.mouthScrollView.contentSize = CGSizeMake((buttonHeight + 10) * numberOfButtons, pagesScrollViewSize.height);
    [self.mouthScrollView setShowsHorizontalScrollIndicator:NO];
    
}

-(void)loadEyeScrollView{
    //Make the buttons on the Scrollview match up to the images in our face parts array
    int leftTag = 0;
    int rightTag = 0;
    leftEyeButtons = [[NSMutableArray alloc]init];
    rightEyeButtons = [[NSMutableArray alloc]init];
    UIButton *leftButton;
    UIButton *rightButton;
    
    UIButton *padlockButton;

    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.eyeScrollView.frame.size;
    int buttonHeight = pagesScrollViewSize.height;
    int buttonWidth = pagesScrollViewSize.height;
    
    //setup mouth scroll view
    CGRect frame;
    int page = 0;
    
    
    for (NSString *hair in EYE_PARTS) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        frame.origin.x = (buttonWidth + 10) * page;
        frame.origin.y = 0.0f;
        
        if ([hair isEqualToString:[NSString stringWithFormat:@"lefteye%i.png",leftTag+1]])
        {
            [leftButton addTarget:self action:@selector(leftEyeButtonsSelected:) forControlEvents:UIControlEventTouchUpInside];
            padlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [padlockButton addTarget:self action:@selector(AdFreePurchase:) forControlEvents:UIControlEventTouchUpInside];
            
            leftButton.tag = leftTag;
            if(leftTag == 0)
            {
                [leftButton setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
                leftButton.selected = TRUE;
            }
            else
                [leftButton setBackgroundImage:nil forState:UIControlStateNormal];
            leftTag++;
            
            leftButton.frame = frame;
            padlockButton.frame = frame;
            UIImageView *buttonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:hair]];
            buttonImageView.frame = frame;
            [self.eyeScrollView addSubview:buttonImageView];
//            [self.eyeScrollView addSubview:leftButton];
//            [leftEyeButtons addObject:leftButton];
            [self drawPadlock:padlockButton orSelectedButton:leftButton onScrollView:eyeScrollView overImageWithString:hair andButtonCounter:leftTag andAddToArray:leftEyeButtons withSelectedButtonString:[NSString stringWithFormat:@"lefteye%i.png",leftTag+1]];
        }
        else if ([hair isEqualToString:[NSString stringWithFormat:@"righteye%i.png",rightTag+1]])
        {
            [rightButton addTarget:self action:@selector(rightEyeButtonsSelected:) forControlEvents:UIControlEventTouchUpInside];
            padlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [padlockButton addTarget:self action:@selector(AdFreePurchase:) forControlEvents:UIControlEventTouchUpInside];
            
            rightButton.tag = rightTag;
            if(rightTag == 0)
            {
                [rightButton setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
                rightButton.selected = TRUE;
            }
            else
                [rightButton setBackgroundImage:nil forState:UIControlStateNormal];
            rightTag++;
            
            rightButton.frame = frame;
            padlockButton.frame = frame;
            UIImageView *buttonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:hair]];
            buttonImageView.frame = frame;
            [self.eyeScrollView addSubview:buttonImageView];
//            [self.eyeScrollView addSubview:rightButton];
//            [rightEyeButtons addObject:rightButton];
            [self drawPadlock:padlockButton orSelectedButton:rightButton onScrollView:eyeScrollView overImageWithString:hair andButtonCounter:rightTag andAddToArray:rightEyeButtons withSelectedButtonString:[NSString stringWithFormat:@"righteye%i.png",rightTag+1]];
        }
        page++;


    }

    int numberOfButtons = [leftEyeButtons count]+[rightEyeButtons count];
    self.eyeScrollView.contentSize = CGSizeMake((buttonHeight + 10) * numberOfButtons, pagesScrollViewSize.height);
    [self.eyeScrollView setShowsHorizontalScrollIndicator:NO];
    
    
    

}

-(void)loadScarScrollView{
    scarButtons = [[NSMutableArray alloc]init];
    UIButton *aButton;
    
    UIButton *padlockButton;

    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scarScrollView.frame.size;
    int buttonHeight = pagesScrollViewSize.height;
    int buttonWidth = pagesScrollViewSize.height;
    
    int tag = 0;
    int page = 0;
    CGRect frame;
    for (NSString *scar in SCAR_PARTS) {
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton addTarget:self action:@selector(scarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        padlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [padlockButton addTarget:self action:@selector(AdFreePurchase:) forControlEvents:UIControlEventTouchUpInside];
        
        aButton.tag = tag;
        tag++;
        if ([scar isEqualToString:@"scar1.png"])
        {
            [aButton setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
            aButton.selected = TRUE;
        }
        else
        {
            [aButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        
        frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        frame.origin.x = (buttonWidth + 10) * page ;
        frame.origin.y = 0.0f;
        aButton.frame = frame;
        padlockButton.frame = frame;
        UIImageView *buttonImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:scar]];
        buttonImageView.frame = frame;
        page++;
        [self.scarScrollView addSubview:buttonImageView];
        
//        [self.scarScrollView addSubview:aButton];
//        [scarButtons addObject:aButton];
        [self drawPadlock:padlockButton orSelectedButton:aButton onScrollView:scarScrollView overImageWithString:scar andButtonCounter:tag andAddToArray:scarButtons withSelectedButtonString:@"scar1.png"];
    }
    int numberOfButtons = [scarButtons count];
    self.scarScrollView.contentSize = CGSizeMake((buttonHeight + 10) * numberOfButtons, pagesScrollViewSize.height);
    [self.scarScrollView setShowsHorizontalScrollIndicator:NO];
}

#pragma mark - Hair BUtton Action method
- (IBAction)mouthButtonSelected:(id)sender{
    
    int numberOfButtonsToReset;
    //only reset all the buttons if we have purchased pack, else jsut reset the first 2 and leave others alone
    if([self IAPItemPurchased]){
        numberOfButtonsToReset = [mouthButtons count];
    }
    else
        numberOfButtonsToReset = NUM_FREE_FEATURES;
    
    //reset buttons to normal state
    for (int i = 0;i<numberOfButtonsToReset;i++)
    {
        UIButton *testB = [mouthButtons objectAtIndex:i];
        //Make sure previous button that was selected is now set to not selected
        if([sender tag] != i)
            testB.selected = FALSE;

        [testB setBackgroundImage:nil forState:UIControlStateNormal];

    }
    
    UIButton *button = (UIButton *)sender;

    if(button.selected)
    {
        [[mouthButtons objectAtIndex:[sender tag]] setBackgroundImage:nil forState:UIControlStateNormal];
        button.selected = FALSE;
    }
    else
    {
        [sender setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
        //button.selected = FALSE;
        button.selected = TRUE;

    }
    [self createNewHairParts:sender];
}

#pragma mark - Hair BUtton Action method
- (IBAction)leftEyeButtonsSelected:(id)sender{

    int numberOfButtonsToReset;
    //only reset all the buttons if we have purchased pack, else jsut reset the first 2 and leave others alone
    if([self IAPItemPurchased]){
        numberOfButtonsToReset = [leftEyeButtons count];
    }
    else
        numberOfButtonsToReset = NUM_FREE_FEATURES;
    
    //reset buttons to normal state
    for (int i = 0;i<numberOfButtonsToReset;i++)
    {
        UIButton *testB = [leftEyeButtons objectAtIndex:i];
        //Make sure previous button that was selected is now set to not selected
        if([sender tag] != i)
            testB.selected = FALSE;
        
        [testB setBackgroundImage:[UIImage imageNamed:[LEFTEYE_PARTS objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
    
    
    UIButton *button = (UIButton *)sender;
    
    if(button.selected)
    {
        
        [[leftEyeButtons objectAtIndex:[sender tag]] setBackgroundImage:nil forState:UIControlStateNormal];
        button.selected = FALSE;
    }
    else
    {
        
        [sender setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
        button.selected = TRUE;
    }
    [self createNewLeftSBParts:sender];
    
}

#pragma mark - Hair BUtton Action method
- (IBAction)rightEyeButtonsSelected:(id)sender{
    
    int numberOfButtonsToReset;
    //only reset all the buttons if we have purchased pack, else jsut reset the first 2 and leave others alone
    if([self IAPItemPurchased]){
        numberOfButtonsToReset = [rightEyeButtons count];
    }
    else
        numberOfButtonsToReset = NUM_FREE_FEATURES;
    
    //reset buttons to normal state
    for (int i = 0;i<numberOfButtonsToReset;i++)
    {
        UIButton *testB = [rightEyeButtons objectAtIndex:i];
        //Make sure previous button that was selected is now set to not selected
        if([sender tag] != i)
            testB.selected = FALSE;
        
        [testB setBackgroundImage:[UIImage imageNamed:[RIGHTEYE_PARTS objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
    UIButton *button = (UIButton *)sender;
    
    if(button.selected)
    {
        [[rightEyeButtons objectAtIndex:[sender tag]] setBackgroundImage:nil forState:UIControlStateNormal];
        button.selected = FALSE;

    }
    else
    {
        [sender setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
        button.selected = TRUE;

    }
    [self createNewRightSBParts:sender];
    
}

#pragma mark - Scar BUtton Action method
- (IBAction)scarButtonSelected:(id)sender{
    
    int numberOfButtonsToReset;
    //only reset all the buttons if we have purchased pack, else jsut reset the first 2 and leave others alone
    if([self IAPItemPurchased]){
        numberOfButtonsToReset = [scarButtons count];
    }
    else
        numberOfButtonsToReset = NUM_FREE_FEATURES;
    
    //reset buttons to normal state
    for (int i = 0;i<numberOfButtonsToReset;i++)
    {
        UIButton *testB = [scarButtons objectAtIndex:i];
        //Make sure previous button that was selected is now set to not selected
        if([sender tag] != i)
            testB.selected = FALSE;
        
        [testB setBackgroundImage:[UIImage imageNamed:[SCAR_PARTS objectAtIndex:i]] forState:UIControlStateNormal];
    }
    
    UIButton *button = (UIButton *)sender;
    
    if(button.selected)
    {
        [[scarButtons objectAtIndex:[sender tag]] setBackgroundImage:nil forState:UIControlStateNormal];
        button.selected = FALSE;
        
    }
    else
    {
        [sender setBackgroundImage:SELECTED_IMAGE forState:UIControlStateNormal];
        button.selected = TRUE;
        
    }
    [self createNewScarParts:sender];
    
}

/* Changes the face parts in the editedFacesFeatures array if the button has been clicked on to display a new feature
 */
-(void)createNewHairParts:(id)sender{
    NSMutableArray *newEditedImageViews = [[NSMutableArray alloc]init];
    
    for (faceFeature *feature in editedFaceFeatures) {
        // draw mouth on view
        if ([feature isOfType]==mouthType) {
            [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:mouthType withSender:sender fromArray:MOUTH_PARTS]];
        }
        else{
            [newEditedImageViews addObject:feature];
        }

    }
    editedFaceFeatures = [[NSMutableArray alloc]initWithArray:newEditedImageViews];

}
-(void)createNewLeftSBParts:(id)sender{
    NSMutableArray *newEditedImageViews = [[NSMutableArray alloc]init];
    for (faceFeature *feature in editedFaceFeatures) {
        //draw leftSB 1
        if ([feature isOfType]==leftEyeType) {
            [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:leftEyeType withSender:sender fromArray:LEFTEYE_PARTS]];
        }
        else{
            [newEditedImageViews addObject:feature];
        }
//        if([sender tag] == 0)
//        {
//
//        }

        //draw leftSB 2
//        else if([sender tag] == 1){
//            if ([feature isOfType]==leftSBType) {
//                [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:leftEyeType withSender:sender fromArray:LEFTEYE_PARTS]];
//            }
//            else{
//                [newEditedImageViews addObject:feature];
//            }
//        }        
        
    }
    editedFaceFeatures = [[NSMutableArray alloc]initWithArray:newEditedImageViews];
}


-(void)createNewRightSBParts:(id)sender{
    NSMutableArray *newEditedImageViews = [[NSMutableArray alloc]init];
    for (faceFeature *feature in editedFaceFeatures) {
        //draw rightSB 1
        if ([feature isOfType]==rightEyeType) {
            [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:rightEyeType withSender:sender fromArray:RIGHTEYE_PARTS]];
        }
        else{
            [newEditedImageViews addObject:feature];
        }
        
//        if([sender tag] == 0)
//        {
//
//        }
//        //draw rightSB 2
//        else if([sender tag] == 1){
//            if ([feature isOfType]==rightSBType) {
//                [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:rightEyeType withSender:sender fromArray:RIGHTEYE_PARTS]];
//            }
//            else{
//                [newEditedImageViews addObject:feature];
//            }
//        }
    }
    editedFaceFeatures = [[NSMutableArray alloc]initWithArray:newEditedImageViews];

}

-(void)createNewScarParts:(id)sender{
    NSMutableArray *newEditedImageViews = [[NSMutableArray alloc]init];
    for (faceFeature *feature in editedFaceFeatures) {
        //draw scar
        //if([sender tag] == 0){
            if ([feature isOfType]==scarType) {
                [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:scarType withSender:sender fromArray:SCAR_PARTS]];
            }
            else{
                [newEditedImageViews addObject:feature];
            }
        
        //}
        //draw scar
//        else if([sender tag] == 1){
//            if ([feature isOfType]==scarType) {
//                [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:scarType withSender:sender fromArray:nil]];
//            }
//            else{
//                [newEditedImageViews addObject:feature];
//            }
//            
//        }
    }
    editedFaceFeatures = [[NSMutableArray alloc]initWithArray:newEditedImageViews];

}

//-(void)createNewMedalParts:(id)sender{
//    NSMutableArray *newEditedImageViews = [[NSMutableArray alloc]init];
//    for (faceFeature *feature in editedFaceFeatures) {
//    //draw medal
//        if([sender tag] == 0){
//            if ([feature isOfType]==medalType) {
//                [newEditedImageViews addObject:[self updateFaceFeature:feature withCIFaceFeature:feature.featureBelongsToo withFaceFeatureType:medalType withSender:sender fromArray:nil]];
//            }
//            else{
//                [newEditedImageViews addObject:feature];
//            }
//            
//        }
//    }
//    editedFaceFeatures = [[NSMutableArray alloc]initWithArray:newEditedImageViews];
//
//}

/** Creates new face features
 */
-(faceFeature*)updateFaceFeature:(faceFeature*)faceFeatureParam withCIFaceFeature:(CIFaceFeature*)feature withFaceFeatureType:(faceFeatureType)featureType withSender:(id)sender fromArray:(NSArray*)facePartsArray{
    
    faceFeature *facePart = [[faceFeature alloc]init];
    UIButton *button = (UIButton *)sender;
    if (!button.selected && featureType ) {
        faceFeatureParam.isShown = FALSE;
        [faceFeatureParam.featureImageView removeFromSuperview];
        [facePart setType:featureType];
        facePart.featureImageView = faceFeatureParam.featureImageView;
        facePart.featureBelongsToo = feature;
        facePart.isShown = FALSE;
    }
    else //if(featureType != scarType)
    {
        facePart = [imageProcessing drawFeature:feature ofType:featureType withImage:[[UIImageView alloc]initWithImage:[UIImage imageNamed:[facePartsArray objectAtIndex:[sender tag]]]] atPoint:feature.bounds.origin];
        [faceFeatureParam.featureImageView removeFromSuperview];
        [self.view addSubview:facePart.featureImageView];
        faceFeatureParam.isShown = TRUE;
        facePart.isShown = TRUE;
    }
//    else
//    {
//        facePart = [imageProcessing drawFeature:feature ofType:featureType withImage:[[UIImageView alloc]initWithImage:[UIImage imageNamed:[facePartsArray objectAtIndex:[sender tag]]]] atPoint:feature.bounds.origin];
//        //[faceFeatureParam.featureImageView removeFromSuperview];
//        [self.view addSubview:facePart.featureImageView];
//        faceFeatureParam.isShown = TRUE;
//    }
    imageProcessing.activeFacePart = facePart.featureImageView;
    [imageProcessing showOverlayWithFrame:imageProcessing.activeFacePart.frame withMarque:_marque];

    return facePart;
}

#pragma mark - Manipulate Image
-(void)showOverlayWithFrame:(CGRect)frame {
    [imageProcessing showOverlayWithFrame:frame withMarque:_marque];
}

-(void)scale:(id)sender {
 
    [imageProcessing scale:sender withView:self.view];

}

-(void)rotate:(id)sender {
    
    [imageProcessing rotate:sender withView:self.view];
    [imageProcessing showOverlayWithFrame:imageProcessing.activeFacePart.frame withMarque:_marque];
}


-(void)move:(id)sender {
    [imageProcessing move:sender withView:self.view withEditedFaceFeatures:editedFaceFeatures];
    [imageProcessing showOverlayWithFrame:imageProcessing.activeFacePart.frame withMarque:_marque];

}

#pragma mark Gesture recognizer actions

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    imageProcessing.objectMoving = TRUE;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


-(void)tapped:(id)sender {
    if(!imageProcessing.doneEditing)
    {
        CGPoint touchPoint = [(UIGestureRecognizer*)sender locationInView:self.view];
        
        for (faceFeature *facePart in editedFaceFeatures) {
            if (CGRectContainsPoint(facePart.featureImageView.frame, touchPoint))
            {
                imageProcessing.activeFacePart = facePart.featureImageView;

            }
        }
        [self showOverlayWithFrame:imageProcessing.activeFacePart.frame];

        [self.view bringSubviewToFront:imageProcessing.activeFacePart];
    }
}

#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}

#pragma mark Inapp purchase
- (IBAction)AdFreePurchase:(id)sender {
    //InAppPurchaseManager *purchase = [[InAppPurchaseManager alloc]initPrivate];
    //[self buyButtonTapped:sender];
    //[self initProduct:kInAppPurchaseProductID];

    if ([self IAPItemPurchased]) {
        //[self.adFree setTitle:@"Purchased" forState:UIControlStateNormal];
        
    } else {
        // not purchased so show a view to prompt for purchase
        UIAlertView *askToPurchase = [[UIAlertView alloc]
                                      initWithTitle:@"Unlock ALL Zombie Features"
                                      message:@"Please tap YES to purchase all Zombie features"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"Yes", @"No", nil];
        
        askToPurchase.delegate = self;
        [askToPurchase show];
        
    }
}




- (void)buyButtonTapped{
//    self.product = [[IAPStoreManager sharedInstance] productForIdentifier:kInAppPurchaseProductID];
//    [self.product addObserver:self];
    if (self.product.isReadyForSale)
    {
        [product purchase];
    }
    else
    {
        UIAlertView *restorePopup = [[UIAlertView alloc]
                                     initWithTitle:@"Seems to be a problem..."
                                     message:@"We cannot access the appstore at this current time, so no purchase can take place"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [restorePopup show];
    }
    
    //for testing
    //NSString *title = @"Purchased";
    //[self.adFree setTitle:title forState:UIControlStateNormal];
//    NSError *error = nil;
//    [SFHFKeychainUtils storeUsername:KEY_CHAIN_USERNAME andPassword:KEY_CHAIN_PASSWORD forServiceName:KEY_SERVICE_NAME updateExisting:YES error:&error];
    
    
}

// Start observing the product.
- (void)initProduct:(NSString*)productIdentifier {
    self.product = [[IAPStoreManager sharedInstance] productForIdentifier:productIdentifier];
    [self.product addObserver:self];
}

// If an error is encountered.
// If we're requesting the In App Purchase's details from Apple.
// If we've received the In App Purchase's details from Apple.
// If a purchase was successfully made.
// If a purchase was successfully restored.
// If a purchase was initiated.
- (void)iapProductWasUpdated:(IAPProduct*)iapProduct {
    [self setButtonState];
}

// Just a snippet that shows the purchase state in use.
- (void)setButtonState {
    BOOL enabled = NO;
    NSString* title = @"";
    
    if (self.product.isLoading) {
        title = @"Loading...";
    }
    else if (self.product.isPurchasing) {
        title = @"Purchasing...";
    }
    else if (self.product.isError) {
        title = @"Error";
    }
    else if (self.product.isPurchased) {
        title = @"Purchased";
        NSError *error = nil;
        [SFHFKeychainUtils storeUsername:KEY_CHAIN_USERNAME andPassword:KEY_CHAIN_PASSWORD forServiceName:KEY_SERVICE_NAME updateExisting:YES error:&error];

        UIAlertView *restorePopup = [[UIAlertView alloc]
                                     initWithTitle:@"Purchase Complete"
                                     message:@"You have now unlocked all the Zombie features! Enjoy!"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [restorePopup show];
        
        [self removeAllButtons:mouthButtons];
        [self removeAllButtons:leftEyeButtons];
        [self removeAllButtons:rightEyeButtons];
        [self removeAllButtons:scarButtons];

        [self loadMouthScrollView];
        [self loadEyeScrollView];
        [self loadScarScrollView];
        
    }
    else if (self.product.isReadyForSale) {
        title = self.product.price;
        enabled = YES;
    }
    else if(self.product.isRestored)
    {
        NSError *error = nil;
        [SFHFKeychainUtils storeUsername:KEY_CHAIN_USERNAME andPassword:KEY_CHAIN_PASSWORD forServiceName:KEY_SERVICE_NAME updateExisting:YES error:&error];
    }
    
//    [self.adFree setEnabled:enabled];
//    [self.adFree setTitle:title forState:UIControlStateNormal];
}

-(BOOL)IAPItemPurchased {
    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:KEY_CHAIN_USERNAME andServiceName:KEY_SERVICE_NAME error:&error];
    if ([password isEqualToString:KEY_CHAIN_PASSWORD])
        return TRUE;
    else
        return FALSE;
}

-(void)removeAllButtons:(NSArray*)buttonsOnScrollView{
    //reset buttons to normal state
    for (int i = 0;i<[buttonsOnScrollView count];i++)
    {
        UIButton *testB = [buttonsOnScrollView objectAtIndex:i];
        [testB removeFromSuperview];
        //            [testB setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload {
//    [self setRotation:nil];
    [self setLoadingWheel:nil];
    [self setLoadingText:nil];
    [self setLoadingView:nil];
    //[self setInfo:nil];
    [self setSupportBrad:nil];
    [self setWiggofy:nil];
    [super viewDidUnload];
}
@end
