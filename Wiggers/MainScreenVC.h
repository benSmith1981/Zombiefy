//
//  ViewController.h
//  Wigtastic
//
//  Created by Ben on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "RecentImagesTableView.h"
#import "Animation.h"
#import "CameraVC.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"
#import "ImageManipulationVC.h"
#import "SaveImage.h"
#import "InfoVC.h"
#import "Constants.h"
#import "InAppPurchaseManager.h"
#import "FaceImageProcessing.h"

#import <AVFoundation/AVFoundation.h>
#import "Sound.h"

#import "IAPStoreManager.h"
#import "IAPProduct.h"
#import  "SFHFKeychainUtils.h"

@interface MainScreenVC : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate,OverlayViewControllerDelegate, failedToDetectFeature>{

    GADBannerView *bannerView_;
    UIView *parentView;
    RecentImagesTableView *recentImageTable;
    UIActionSheet *sheet;
    NSArray *imageFeatures;
    ImageManipulationVC *imageManip;
    UIWebView *webView;
    
    Sound *soundPlayer;
}
@property (weak, nonatomic) IBOutlet UIButton *Delete;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (nonatomic,strong) ImageManipulationVC *imageManip;
@property (weak, nonatomic) IBOutlet UIButton *adFree;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UILabel *mainTitle;
@property (nonatomic, strong) IBOutlet UILabel *recentImagesTitle1;
@property (nonatomic, strong) IBOutlet UILabel *recentImagesTitle2;
@property (nonatomic, strong) IBOutlet UILabel *takePicTitle1;
@property (nonatomic, strong) IBOutlet UILabel *takePicTitle2;
@property (nonatomic, strong) IBOutlet UIButton *takePicture;
@property (nonatomic, strong) IBOutlet UIImageView *blueCog;
@property (nonatomic, strong) IBOutlet UIImageView *head;
@property (nonatomic, strong) IBOutlet UIButton *recentImages;
@property (nonatomic, strong) RecentImagesTableView *recentImageTable;
@property (nonatomic, strong) UIImageView *activeImageView;
@property (nonatomic,strong) IAPProduct *product;

@property (nonatomic, retain) CameraVC *cameraVC;
- (IBAction)Delete:(id)sender;

- (IBAction)soundButtonSelected:(id)sender;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)AdFreePurchase:(id)sender;
- (void)ImagePicker;
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (IBAction)restorePreviousTransaction:(id)sender;


@end

