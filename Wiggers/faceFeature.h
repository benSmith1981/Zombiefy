//
//  UIButton+isSelected.h
//  Wiggers
//
//  Created by Ben on 9/27/12.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface faceFeature : NSObject{
    faceFeatureType featureType;
   
}
@property (nonatomic) BOOL isShown;
@property (nonatomic) faceFeatureType buttonType;
@property (nonatomic, strong)UILabel *selectedLabel;

@property (nonatomic, strong)CIFaceFeature *featureBelongsToo;
@property (nonatomic, strong)UIImageView *featureImageView;
@property (nonatomic, strong)UIButton *featureButton;

-(faceFeatureType)isOfType;
-(void)setType:(faceFeatureType)type;

@end
