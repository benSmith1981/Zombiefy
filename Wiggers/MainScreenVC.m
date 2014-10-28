//
//  ViewController.m
//  Wigtastic
//
//  Created by Ben on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScreenVC.h"
#import "GADBannerView+SetFrame.h"
#import "iNotify.h"

@interface MainScreenVC ()

@end

@implementation MainScreenVC

//view for the image taken from camera
@synthesize adFree;
@synthesize activeImageView;
//buttons
@synthesize recentImages, takePicture,recentImagesTitle1,recentImagesTitle2,takePicTitle1,takePicTitle2,blueCog,infoButton;
@synthesize recentImageTable,mainTitle,head,cameraVC;
@synthesize imageManip,soundButton;
@synthesize product;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure iNotify
    [iNotify sharedInstance].notificationsPlistURL = @"http://wigtastic.com/notifications.plist";

    [self.navigationController setNavigationBarHidden:YES];
    //[self initProduct:kInAppPurchaseProductID];

//    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"TheUndead" ofType:@"mp3"];
//    Sound *soundInst = [[Sound alloc]initialiseSound:pewPewPath];
//    [soundInst playSound:soundInst.player numberofTimes:0];

	

    
//    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"TheUndead" ofType:@"mp3"];
//	NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
//	AudioServicesCreateSystemSoundID((__bridge)pewPewURL, &_pewPewSound);
//    AudioServicesPlaySystemSound(_pewPewSound);
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        // Create a view of the standard size at the bottom of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        NSLog(@"height %f width %f",bannerView_.frame.size.height,bannerView_.frame.size.width);
        [bannerView_ positionView:CGRectMake(AD_X_POSITION, AD_Y_POSITION, AD_WIDTH, AD_HEIGHT)];
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a15048c13360bc3";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }
    

    
    [recentImagesTitle1 setFont:[UIFont fontWithName:FONT_TYPE size:17]];
    recentImagesTitle1.textColor = [UIColor blackColor];
    recentImagesTitle1.text = @"Saved Zombies";
    
//    [recentImagesTitle2 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:33]]; 
//    [takePicTitle1 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:20]];
    [takePicTitle1 setFont:[UIFont fontWithName:FONT_TYPE size:17]];
    takePicTitle1.textColor = [UIColor blackColor];
    takePicTitle1.text = @"Choose Victim!";
    //takePicture.titleLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:15];
    
    
    //recentImages.titleLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:15];
    
    
    //Get constraint size
    CGSize constraintSize;
    constraintSize.width = self.view.frame.size.width;
    constraintSize.height = TITLE_HEIGHT;
    mainTitle.text = @"Zombiefy Yourself!";
    mainTitle.textColor = [UIColor blackColor];
    
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                   FONT_TYPE, NSFontAttributeName,nil];
    
    CGRect theSize = [mainTitle.text boundingRectWithSize:constraintSize
                                                 options:NSStringDrawingUsesFontLeading
                                              attributes:fontAttribute
                                                 context:nil];
    
//    CGSize theSize = [mainTitle.text sizeWithFont:[UIFont fontWithName:FONT_TYPE size:TITLE_FONT_SIZE] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingMiddle];
    mainTitle.frame = CGRectMake((self.view.frame.size.width-theSize.size.width)/2,
                                 (TITLE_HEIGHT-theSize.size.height)/2,
                                 theSize.size.width,theSize.size.height);
    [mainTitle setFont:[UIFont fontWithName:FONT_TYPE size:TITLE_FONT_SIZE]];
    
//    Animation *animateCogs = [[Animation alloc]init];
//    [animateCogs spinLayer:blueCog.layer duration:3 direction:SPIN_COUNTERCLOCK_WISE];

    //setup cameraVc so this class can act as delegate to receive callbacks
    self.cameraVC = [[CameraVC alloc] initWithNibName:@"Camera" bundle:nil];
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.cameraVC.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveImagefeatures:) name:@"featuresNotification" object:nil];
    
    //soundPlayer = [Sound retrieveSingleton];
    [[Sound retrieveSingleton] initWithSounds:sounds];
    [[Sound retrieveSingleton] playSound:[[Sound retrieveSingleton].funnyClipsPlayer objectAtIndex:0] numberofTimes:-1];
    
    
    //soundButton.selected = FALSE;
    soundPlayer.soundOn = TRUE;
}

- (void)viewDidUnload
{
    
    [self setTakePicture:nil];
    [self setAdFree:nil];
    [self setSoundButton:nil];
    [self setDelete:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Sound BUtton Selected


- (IBAction)soundButtonSelected:(id)sender{
    //UIButton *button = sender;
    if([Sound retrieveSingleton].soundOn)
    {
        [sender setBackgroundImage:SOUNDBUTTONIMAGE forState:UIControlStateNormal];
        //button.selected = TRUE;
        //[[Sound retrieveSingleton] fadeSound];
        [[[Sound retrieveSingleton].funnyClipsPlayer objectAtIndex:0] stop];
        [Sound retrieveSingleton].soundOn = FALSE;
    }
    else
    {
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
        //button.selected = FALSE;
        [[Sound retrieveSingleton] playSound:[[Sound retrieveSingleton].funnyClipsPlayer objectAtIndex:0] numberofTimes:-1];
        [Sound retrieveSingleton].soundOn = TRUE;
    }
}

#pragma mark - failedToDetectFeature delegate
- (void)noFeaturesDetected{
    self.activeImageView = nil;
    [self ImagePicker];
}

#pragma mark - Image features Notification  
- (void) receiveImagefeatures:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    //NSDictionary *dict = notification.userInfo; 
    NSArray *features = [notification.userInfo objectForKey:@"features"];
    imageManip.featuresLocalInstance = features;
}


#pragma mark - Action sheet Image picker
- (void)ImagePicker {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] 
                 initWithTitle:@"" delegate:self 
                 cancelButtonTitle:@"Cancel" 
                 destructiveButtonTitle:nil 
                 otherButtonTitles:@"Choose An Existing Photo", nil];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self.view];
        sheet.tag = 0;
        //[sheet release];
    }
    
    else {
        sheet = [[UIActionSheet alloc] 
                 initWithTitle:@"" delegate:self 
                 cancelButtonTitle:@"Cancel" 
                 destructiveButtonTitle:nil 
                 otherButtonTitles:@"Choose An Existing Photo", @"Take A Photo", nil];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self.view];
        sheet.tag = 1;
        //[sheet release];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.activeImageView = nil;
    UIImageView *imageView = [[UIImageView alloc]init];
    
    //TODO sort out sizing inherit from parent view all way up to window
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        imageView.frame = CGRectMake(IMG_X,IMG_Y, IMG_HEIGHT_NO_ADS, IMG_HEIGHT_NO_ADS);
    }
    else {
        imageView.frame = CGRectMake(IMG_X,IMG_Y, IMG_WIDTH, IMG_HEIGHT);
    }
    
    //[self.view addSubview:imageView];
    self.activeImageView = imageView;
    
    switch (sheet.tag) {
        case 0:
            if (buttonIndex == 0) {
                //Okay the UIImagePickerControllerSourceTypeSavedPhotosAlbum displays the 
                NSLog(@"Album");
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentModalViewController:picker animated:YES];
                //[picker release];
                
            }
            break;
        case 1:
            if (buttonIndex == 0) {
                //Okay the UIImagePickerControllerSourceTypeSavedPhotosAlbum displays the 
                NSLog(@"Album");
                //[[soundPlayer.funnyClipsPlayer objectAtIndex:0]fadeSound];

                [soundPlayer fadeSound];
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentModalViewController:picker animated:YES];
                //[picker release];
                
            } else if (buttonIndex == 1) {
                NSLog(@"Camera");
                //[[soundPlayer.funnyClipsPlayer objectAtIndex:0]fadeSound];
                [soundPlayer fadeSound];
                [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                picker.cameraOverlayView = [[UIImageView alloc] initWithImage:overlayImage.image];
//                [self presentModalViewController:picker animated:YES];
                //[picker release];
            }
            break;
    }
}

#pragma mark - Show Camera


- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.cameraVC setupImagePicker:sourceType];
        
        [self presentViewController:self.cameraVC.imagePickerController animated:YES completion:nil];
         //presentModalViewController:self.cameraVC.imagePickerController animated:YES];
    }
}

#pragma mark - Take picture

- (IBAction)buttonPressed:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"%i", [button tag]);
    if ([button tag] == 1) {

        [self ImagePicker];
    }
    else if ([button tag] == 2) {
        self.recentImageTable = [[RecentImagesTableView alloc]init];
        [self.navigationController pushViewController:recentImageTable animated:YES];
    }
    else if ([button tag] == 3) {//try to flip to info view
        InfoVC *infoView = [[InfoVC alloc]initWithNibName:@"InfoView" bundle:nil];
        
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                               forView:self.navigationController.view cache:NO];
        
        [self.navigationController pushViewController:infoView animated:YES];
        [UIView commitAnimations];
        
    }
    
}

#pragma mark - OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    //Code to display overlay over camera image
    //    self.activeImageView.image = [self addOverlayToBaseImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    //    UIImageView *compositeView = [[UIImageView alloc]initWithImage:[self addOverlayToBaseImage:self.activeImageView.image]];
    //    self.activeImageView = compositeView;
    //    [self.view addSubview:compositeView];
    
    self.activeImageView.image = picture;
    
    self.imageManip = [[ImageManipulationVC alloc]initWithNibName:@"ImageManipulationView" bundle:nil];
    self.imageManip.delegate = self;
    //
    //    FaceImageProcessing *imageProcessing = [[FaceImageProcessing alloc]init];
    //    imageProcessing.activeImageView = self.activeImageView;
    //self.activeImageView = [imageProcessing drawImageAnnotatedWithFeatures];
    imageManip.activeImageView = self.activeImageView;
    [FaceImageProcessing processFace:self.activeImageView.image];
    [self.navigationController pushViewController:imageManip animated:YES];
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - INApp purchasing

- (IBAction)AdFreePurchase:(id)sender {
    //InAppPurchaseManager *purchase = [[InAppPurchaseManager alloc]initPrivate];
    //[self buyButtonTapped:sender];
    
    if ([self IAPItemPurchased]) {
        [self.adFree setTitle:@"Purchased" forState:UIControlStateNormal];
        
    } else {
        // not purchased so show a view to prompt for purchase
        UIAlertView *askToPurchase = [[UIAlertView alloc]
                                      initWithTitle:@"Unlock"
                                      message:@"Purchase Zombies?"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"Yes", @"No", nil];
        
        askToPurchase.delegate = self;
        [askToPurchase show];
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self buyButtonTapped];
    }
    else
    {
        
    }
}

- (void)buyButtonTapped{
    [product purchase];
    
    //for testing
//    NSString *title = @"Purchased";
//    [self.adFree setTitle:title forState:UIControlStateNormal];
//    NSError *error = nil;
//    [SFHFKeychainUtils storeUsername:KEY_CHAIN_USERNAME andPassword:KEY_CHAIN_PASSWORD forServiceName:KEY_SERVICE_NAME updateExisting:YES error:&error];
    

}

// Start observing the product.
- (void)initProduct:(NSString*)productIdentifier {
    self.product = [[IAPStoreManager sharedInstance] productForIdentifier:productIdentifier];
    //[self.product addObserver:self];
    
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

    }
    else if (self.product.isReadyForSale) {
        title = self.product.price;
        enabled = YES;
    }
    
    [self.adFree setEnabled:enabled];
    [self.adFree setTitle:title forState:UIControlStateNormal];
}

-(BOOL)IAPItemPurchased {
    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:KEY_CHAIN_USERNAME andServiceName:KEY_SERVICE_NAME error:&error];
    if ([password isEqualToString:KEY_CHAIN_PASSWORD])
        return TRUE;
    else
        return FALSE;
}

- (IBAction)Delete:(id)sender {
    NSError *error = nil;
    [SFHFKeychainUtils deleteItemForUsername:KEY_CHAIN_USERNAME andServiceName:KEY_SERVICE_NAME error:&error];
}

- (IBAction)restorePreviousTransaction:(id)sender {
    //[self.product restorePurchase];
    if([self.product isRestored])
    {
        UIAlertView *restore = [[UIAlertView alloc]
                                      initWithTitle:@"Restore"
                                      message:@"Previous Purchases have been restored"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [restore show];

        NSError *error = nil;
        [SFHFKeychainUtils storeUsername:KEY_CHAIN_USERNAME andPassword:KEY_CHAIN_PASSWORD forServiceName:KEY_SERVICE_NAME updateExisting:YES error:&error];
    }
    else
    {
        UIAlertView *restore = [[UIAlertView alloc]
                                initWithTitle:@"Not Restored"
                                message:@"Previous Purchases have NOT been restored"
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [restore show];
    }
}

- (IBAction)facebookFanButton:(id)sender {
    NSString* params = @"profile/288981524551602";
    
    NSString* URI = @"fb://"; // Text sent through url.
    //NSString* URI = @"soundcloud:";
    
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //Append URI with URLEncodedText
    NSURL *ourURL = [NSURL URLWithString:[URI stringByAppendingString:URLEncodedText]];
    
    //if we ahve the Sound cloud app open song with this
    if ([ourApplication canOpenURL:ourURL]) {
        
        [ourApplication openURL:ourURL];
    }
    //else open the website at the permalink obtained
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Zombiefy/288981524551602"]];
        
    }
}
@end
