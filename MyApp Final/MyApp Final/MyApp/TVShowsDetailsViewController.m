//
//  TVShowsDetailsViewController.m
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "TVShowsDetailsViewController.h"

@interface TVShowsDetailsViewController ()

@end

@implementation TVShowsDetailsViewController

//Synthesize properties from the header file
@synthesize imgTVShow;
@synthesize txtTVShowText;
@synthesize txtTVShowYear;
@synthesize txtSynopsis;
@synthesize navBar;
@synthesize tvshow;

//Service response code called from Service delegate header file for FilmDetailsService
-(void) serviceFinished:(id)service withError:(BOOL)error {
    if (!error) {
        //Check the service that is replying
        if ([service class] == [TVShowsDetailsService class]) {
            NSDictionary *s = [service details];
            
            //Set the values from the service call the dictionary tvshow
            [[self tvshow] setValue:[s valueForKey:@"original_name"] forKey:@"original_name"];
            [[self tvshow] setValue:[s valueForKey:@"first_air_date"] forKey:@"first_air_date"];
            
            [[self tvshow]setValue:[s valueForKey:@"overview"] forKey:@"overview"];
            
            
            //Download and cache profile picture
            //Executes the image download service based on the tv show id
            TVShowPictureDownloadService *service = [[TVShowPictureDownloadService alloc] init];
            [service setDelegate:self];
            [service setTvshowId:[[self tvshow] valueForKey:@"id"]];
            
            //Set the size of the image using the url from the api e.g. w500, w600
            NSString *y= @"http://image.tmdb.org/t/p/w500";
            NSString *UrlRequest = [NSString stringWithFormat:@"%@%@", y, [s valueForKey:@"poster_path"]];
            
            //Initialises the service
            [service setTvshowPictureUrl:UrlRequest];
            
            [serviceQueue addOperation:service];
            
            //Refresh the UI on the Main Thread
            [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
        }else {
            //This mean it must be the image download service
            [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
        }
    }
    
}

//Method for refresh the view
-(void) refreshView {
    //verifies the movie details is not nil, if so then set the details onto the specified text.
    if ([self tvshow] != nil) {
        [txtTVShowText setText:[[self tvshow]valueForKey:@"original_name"]];
        [txtTVShowYear setText:[[[self tvshow] valueForKey:@"first_air_date"] description]];
        
        //Add content already saved
        [txtSynopsis setText:[[[self tvshow] valueForKey:@"overview"] description]];
        
        //Check if image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [[self tvshow] valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]) {
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgTVShow setImage:pic];
        }
    }
}

//Method for refreshing movie details by calling the service again
-(void)refreshTVShowsDetails {
    //===DEBUGGING==
    NSLog(@"Refresh works!");
    TVShowsDetailsService *service =[[TVShowsDetailsService alloc] init];
    [service setTvshowId:[[[self tvshow] valueForKey:@"id"] description]];
    [service setTvshowId:[[[self tvshow] valueForKey:@"id"] description]];
    [service setDelegate:self];
    [serviceQueue addOperation:service];
}

//Methods for describing how the view will appear when run
//===========================================================================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//Method for how the view will appear when loaded
-(void)viewWillAppear:(BOOL)animated {
    if ([self tvshow] != nil)   {
        [self setTitle:@"Details"];
        
        [txtTVShowText setText:[[self tvshow] valueForKey:@"original_name"]];
        [txtTVShowYear setText:[[[self tvshow] valueForKey:@"first_air_date"] description]];
        
        //Clear text fields
        [txtSynopsis setText:@""];
        
        //Add content already saved
        [txtSynopsis setText:[[self tvshow] valueForKey:@"overview"]];
        
        //Service Queue
        serviceQueue = [[NSOperationQueue alloc] init];
        [serviceQueue setMaxConcurrentOperationCount:1];
        
        //If the movie data is incomplete
        if (![[[self tvshow] allKeys] containsObject:@"overview"]) {
            TVShowsDetailsService *service = [[TVShowsDetailsService alloc] init];
            [service setTvshowId :[[[self tvshow] valueForKey:@"id"] description]];
            [service setDelegate:self];
            [serviceQueue addOperation:service];
        }
        
        //Check if image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, [[self tvshow] valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:pngFilePath]) {
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgTVShow setImage:pic];
        } else {
            TVShowsDetailsService *service = [[TVShowsDetailsService alloc]init];
            [service setTvshowId:[[[self tvshow] valueForKey:@"id"] description]];
            [service setDelegate:self];
            [serviceQueue addOperation:service];
        }
    }
}

//Defines the layout of the view e.g. setting the navigation item button
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        //Custom initialisation
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//Custom buttons methods
//Returns to the saved list view
- (IBAction)handleBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:Nil];
}

//Links to the tv show trailer on a web view
- (IBAction)handleTrailerBtnPress:(id)sender {
    NSDictionary *tvinfo = [self tvshow];
    NSString * url = @"https://www.youtube.com/results?search_query=";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@+tv+show", url, [tvinfo valueForKey:@"original_name"]]]];
    NSLog(@"%@%@+trailer", url, [tvinfo valueForKey:@"original_name"]);
}

//Performs a google search of the tv show on a web page
- (IBAction)MoreInfoBtn:(id)sender {
    NSDictionary *tvinfo = [[self tvshow] valueForKey:@"original_name"];
    NSString * url = @"https://www.google.co.uk/?gws_rd=ssl#q=";
    NSLog(@"%@%@+tv+show", url, tvinfo);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@+tv+show", url, tvinfo]]];
    
     //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.co.uk/?gws_rd=ssl#q=%@"]] ;
}

//presents options on a Action Sheet for posting to twitter or facebook with the tv show name
- (IBAction)shareBtn:(id)sender {
    NSDictionary *tvinfo = [[self tvshow] valueForKey:@"original_name"];
    NSString* shareText =@"Hi! I'm using the Wrapped! App to view the TV show:";
    NSArray *itemsToShare = @[shareText, tvinfo];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes =@[];
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
