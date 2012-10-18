//
//  RecentImagesTableView.h
//  Wiggers
//
//  Created by Ben Smith on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveImage.h"
#import "SaveImageVC.h"
#import "GADBannerView.h"


@interface RecentImagesTableView : UIViewController <UITableViewDataSource, UITableViewDelegate,deleteImageDelegate>{
    SaveImage *saveImage;
    
    UIImageView *loadedImageView;
    
    //Toolbar stuff
    UIToolbar *toolBar;
    UIBarButtonItem *back;
    UIBarButtonItem *view;
    UIBarButtonItem *share;

    NSArray *recentImagesToolbar;
    
    SaveImageVC *savedImageVC;
    NSString *selectedFile;
   
    GADBannerView *bannerView_;
}

@property(nonatomic,strong) NSArray *arrayOfImagePaths;
@property(nonatomic,strong) UITableView* table;
- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize  isEnabled:(BOOL)enabled;
@end
