//
//  GADBannerView+SetFrame.m
//  Zombify
//
//  Created by Martin Lloyd on 25/10/2012.
//
//

#import "GADBannerView.h"
#import "GADBannerView+SetFrame.h"
#import "Constants.h"

@implementation GADBannerView (SetFrame)

-(void)positionView:(CGRect)rect
{
    rect.origin.y = [[UIScreen mainScreen]bounds].size.height;
    rect.origin.y = rect.origin.y - AD_HEIGHT;
    
    self.frame = rect;
}

@end
