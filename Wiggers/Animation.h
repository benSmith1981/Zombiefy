//
//  Animation.h
//  Wiggers
//
//  Created by Ben Smith on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Animation : CAAnimation
{
    
}
- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction;
@end
