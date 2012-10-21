//
//  InfoViewViewController.h
//  Wiggers
//
//  Created by Ben Smith on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "Constants.h"
#import "IAPStoreManager.h"
#import "IAPProduct.h"
#import  "SFHFKeychainUtils.h"
@interface InfoVC : UIViewController <IAPProductObserver>{
    GADBannerView *bannerView_;
}

@property (nonatomic,strong) UIView *secondaryView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *restore;
@property (weak, nonatomic) IBOutlet UILabel *restoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (nonatomic,strong) IAPProduct *product;

- (IBAction)buttonPressed:(id)sender;
@end
