//
//  SaveImageVC.h
//  Wiggers
//
//  Created by Ben Smith on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveImage.h"
#import "GADBannerView.h"

//delegate to return amount entered by the user
@protocol deleteImageDelegate <NSObject>
@optional
-(void)deleteImage:(NSArray*)imagePaths;

@end

@interface SaveImageVC : UIViewController
{
    UIBarButtonItem *back;
    UIBarButtonItem *deleteImage;
    UIBarButtonItem *share;
    SaveImage *saveImageControl;
    __weak id <deleteImageDelegate> delegate;
    
    GADBannerView *bannerView_;
}
@property (weak)id delegate;
@property (nonatomic,strong)NSString *filename;
@property (nonatomic,strong)UIImage *savedImage;
@property (nonatomic,strong)UIImageView *savedImageView;
@property (nonatomic,strong)UIToolbar *toolBar;

- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize;
@end

