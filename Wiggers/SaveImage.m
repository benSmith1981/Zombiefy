//
//  SaveImageViewController.m
//  Wiggers
//
//  Created by Ben Smith on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveImage.h"

//@interface SaveImageViewController ()
//
//@end

@implementation SaveImage



+ (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", fileName]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    
    NSLog(@"image removed");
    
}

//The following function saves UIImage in test.png file in the user Document folder:
+ (void)saveImage:(UIImage*)image withFileName:(NSString*)fileName
{
    if (image != nil)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithFormat:@"%@.png",fileName] ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}
//The following function loads UIImage from the test.png file:
+ (UIImage*)loadImage:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                      [NSString stringWithFormat:@"%@.png",fileName] ];
    
   	
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+(NSArray*)getListOfPNGsInDocDirectory{
    
    NSMutableArray *savedFiles = [[NSMutableArray alloc]init];
    // Define Filemanager
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Catch any errors
    NSError *dataError = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *dataFiles = [fm contentsOfDirectoryAtPath:documentsDirectory error:&dataError];
    
    for (NSString *fileNames in dataFiles) {
        if([fileNames hasSuffix:@".png"])
        {
            [savedFiles addObject:[fileNames stringByDeletingPathExtension]];
            NSLog(@"data files %@",fileNames);
        }
    }
    for (NSString *fileNames in savedFiles) {
        NSLog(@"Saved Files %@",fileNames);
    }
    if ([savedFiles count] > 0) {
        
        return savedFiles;
    }
    else {
        return nil;
    }
}
@end
