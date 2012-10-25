//
//  RecentImagesTableView.m
//  Wiggers
//
//  Created by Ben Smith on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentImagesTableView.h"
#import "SHK.h"
#import "Constants.h"
#import "GADBannerView+SetFrame.h"

@interface RecentImagesTableView ()

@end

@implementation RecentImagesTableView
@synthesize table,arrayOfImagePaths;
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    
    saveImage = [[SaveImage alloc]init];
    arrayOfImagePaths = [[NSArray alloc]initWithArray:[SaveImage getListOfPNGsInDocDirectory]];
    NSLog(@"%i",[arrayOfImagePaths count]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,0.0f, 320, IMG_HEIGHT_NO_ADS) style:UITableViewStylePlain];
    }
    else {
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,0.0f, 320, IMG_HEIGHT) style:UITableViewStylePlain];
    }
    NSLog(@"width: %f height: %f",table.frame.size.width,table.frame.size.height);
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:table];
    
    
    //intialise toolbar
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kInAppPurchaseProductID]) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,IMG_HEIGHT_NO_ADS, 320, 44)];
    }
    else {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,IMG_HEIGHT, 320, 44)];
    }
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIView *whiteBackground = [[UIView alloc]initWithFrame:toolBar.frame];
    [whiteBackground setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:whiteBackground];
//    toolBar.barStyle = UIBarStyleDefault;
//    if ([toolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
//        [toolBar setBackgroundImage:[UIImage imageNamed:@"menuBar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    } else {
//        [toolBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBar"]] atIndex:0];
//    }
    
    back = [self customAddButtonItem:@"BACK" WithTarget:self action:@selector(buttonPressed:) andTag:1 andTextSize:25 isEnabled:TRUE];
    view = [self customAddButtonItem:@"VIEW" WithTarget:self action:@selector(buttonPressed:) andTag:2 andTextSize:22 isEnabled:TRUE];
    share = [self customAddButtonItem:@"SHARE" WithTarget:self action:@selector(buttonPressed:) andTag:3 andTextSize:25 isEnabled:FALSE];
    share.enabled = FALSE;
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    //create toolbar arrays
    recentImagesToolbar = [NSArray arrayWithObjects:flexItem, back,flexItem, nil];
    [toolBar setItems:recentImagesToolbar animated:NO];
    [self.view addSubview:toolBar];
}

- (UIBarButtonItem *)customAddButtonItem:(NSString*)title WithTarget:(id)target action:(SEL)action andTag:(int)tag andTextSize:(int)textSize  isEnabled:(BOOL)enabled{
    UIButton *customButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    //customButtonView.enabled = enabled;
    customButtonView.frame = CGRectMake(0.0f, 0.0f, 79.0f, 38.0f);
    customButtonView.tag = tag;

    //Get constraint size
    CGSize constraintSize;
    constraintSize.width = customButtonView.frame.size.width;
    constraintSize.height = customButtonView.frame.size.height;
    CGSize theSize = [title sizeWithFont:[UIFont fontWithName:FONT_TYPE size:textSize] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeMiddleTruncation];
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake((customButtonView.frame.size.width-theSize.width)/2, (customButtonView.frame.size.height-theSize.height)/2, theSize.width, theSize.height)];
    NSLog(@"Height %f Width %f",theSize.height,theSize.width);
    backLabel.font = [UIFont fontWithName:FONT_TYPE size:textSize];
    backLabel.text = title;

    [backLabel setBackgroundColor:[UIColor clearColor]];
    [customButtonView addSubview:backLabel];
    
    [customButtonView setBackgroundImage:
     [UIImage imageNamed:@"button.png"] 
                                forState:UIControlStateNormal];
    [customButtonView setBackgroundImage:
     [UIImage imageNamed:@"buttonPressed.png"] 
                                forState:UIControlStateHighlighted];
    
    [customButtonView setImage:
     [UIImage imageNamed:@"button.png"] 
                      forState:UIControlStateNormal];
    [customButtonView setImage:
     [UIImage imageNamed:@"buttonPressed.png"] 
                      forState:UIControlStateHighlighted];
    
    [customButtonView addTarget:target action:action 
               forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customButtonItem = [[UIBarButtonItem alloc] 
                                          initWithCustomView:customButtonView];
    customButtonItem.tag = tag;
    NSLog(@"%i",customButtonItem.tag);
    [customButtonView setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    
    //customButtonItem.imageInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    
    return customButtonItem;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) ||
    (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    CGRect frame = self.view.frame;
//	frame.size.height = 416;
//	self.view.frame = frame;
//    

}

#pragma mark - Button action
- (void)buttonPressed:(id)sender {
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSLog(@"%i",button.tag);
    //Back
    if (button.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //Share
    else if (button.tag == 3) {
        SHKItem *item = [SHKItem image:loadedImageView.image title:@"Zombiefy iPhone app, scare all your friends this Halloween"];
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        [SHK setRootViewController:self];
        [actionSheet showFromToolbar:toolBar];
    }
    //Delete
    else if (button.tag == 2) {
        savedImageVC = [[SaveImageVC alloc]initWithNibName:@"SaveImageVC" bundle:nil];
        savedImageVC.delegate = self;
        savedImageVC.filename = selectedFile;
        savedImageVC.savedImage = loadedImageView.image;
        [self.navigationController pushViewController:savedImageVC animated:YES];

        //[self presentViewController:loadedImageView animated:YES completion:nil];
        //[self.view addSubview:loadedImageView];
//        savedImageVC = [[SaveImageVC alloc]initWithNibName:@"SavedImage" bundle:nil];
//        savedImageVC.savedImageView = loadedImageView;
//        [self.navigationController pushViewController:savedImageVC animated:YES];
    }
}

-(void)deleteImage:(NSArray*)imagePaths{
    arrayOfImagePaths = imagePaths;
    [table reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (arrayOfImagePaths == nil) {
        return 1;
    }
    else {
        return [arrayOfImagePaths count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *fileName = [arrayOfImagePaths objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:FONT_TYPE size:20]; 
    cell.textLabel.text = [fileName lastPathComponent];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedFile = [arrayOfImagePaths objectAtIndex:indexPath.row];
    loadedImageView = [[UIImageView alloc]initWithImage:[SaveImage loadImage:selectedFile]];
    //share.enabled = TRUE;
    savedImageVC = [[SaveImageVC alloc]initWithNibName:@"SaveImageVC" bundle:nil];
    savedImageVC.delegate = self;
    savedImageVC.filename = selectedFile;
    savedImageVC.savedImage = loadedImageView.image;
    [self.navigationController pushViewController:savedImageVC animated:YES];

    //[self presentModalViewController:savedImageVC animated:YES];
}


@end
