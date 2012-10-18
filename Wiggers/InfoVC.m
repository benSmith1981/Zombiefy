//
//  InfoViewViewController.m
//  Wiggers
//
//  Created by Ben Smith on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC
@synthesize backButton;
@synthesize text1;
@synthesize text2,secondaryView,label,textView1,textView2;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [text1 setFont:[UIFont fontWithName:FONT_TYPE size:15]];
    text1.textColor = [UIColor blackColor];
    //text2.font = [UIFont fontWithName:FONT_TYPE size:15];
    label.text = @"BACK";
    label.font = [UIFont fontWithName:FONT_TYPE size:20];
	// Do any additional setup after loading the view.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:productPurchase]) {
        // Create a view of the standard size at the bottom of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        NSLog(@"height %f width %f",bannerView_.frame.size.height,bannerView_.frame.size.width);
        bannerView_.frame = CGRectMake(AD_X_POSITION, AD_Y_POSITION, AD_WIDTH, AD_HEIGHT);
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a15048c13360bc3";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setTextView1:nil];
    [self setTextView2:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)buttonPressed:(id)sender {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
}
@end
