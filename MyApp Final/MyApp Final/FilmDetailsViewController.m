//
//  FilmDetailsViewController.m
//  MyApp
//
//  Created by Wayne Luong on 27/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "FilmDetailsViewController.h"

@interface FilmDetailsViewController ()

@end

@implementation FilmDetailsViewController

//Synthesize properties from the header file
@synthesize imgFilm;
@synthesize txtFilmText;
@synthesize txtFilmYear;
@synthesize txtSynopsis;
@synthesize txtRating;
@synthesize navBar;
@synthesize movie;

//Service response code called from Service delegate header file for TVShowsDetailsService
-(void) serviceFinished:(id)service withError:(BOOL)error {
    if (!error) {
        //Check the service that is replying
        if ([service class] == [FilmDetailsService class]) {
            NSDictionary *m = [service details];
            
            //Set the values from the service call the dictionary movie
            [[self movie] setValue:[m valueForKey:@"original_title"] forKey:@"original_title"];
            [[self movie] setValue:[m valueForKey:@"release_date"] forKey:@"release_date"];
            [[self movie] setValue:[m valueForKey:@"vote_average"] forKey:@"vote_average"];
            
            [[self movie]setValue:[m valueForKey:@"overview"] forKey:@"overview"];
            
            
            //Download and cache profile picture
            //Executes the image download service based on the movie id
            FilmPictureDownloadService *service = [[FilmPictureDownloadService alloc] init];
            [service setDelegate:self];
            [service setMovieId:[[self movie] valueForKey:@"id"]];
            
            //Set the size of the image using the url from the api e.g. w500, w600
            NSString *y= @"http://image.tmdb.org/t/p/w500";
            NSString *UrlRequest = [NSString stringWithFormat:@"%@%@", y, [m valueForKey:@"poster_path"]];
            
            //Initialises the service
            [service setMoviePictureUrl:UrlRequest];
            
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
    if ([self movie] != nil) {
        [txtFilmText setText:[[self movie]valueForKey:@"original_title"]];
        [txtFilmYear setText:[[[self movie] valueForKey:@"release_date"] description]];
           [txtRating setText:[[[self movie] valueForKey:@"vote_average"] description]];
        
        //Add content already saved
        [txtSynopsis setText:[[[self movie] valueForKey:@"overview"] description]];
        
        //Check if image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [[self movie] valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]) {
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
        }
    }
}

//Method for refreshing movie details by calling the service again
-(void)refreshMovieDetails {
    //===DEBUGGING==
     NSLog(@"Refresh works!");
    FilmDetailsService *service =[[FilmDetailsService alloc] init];
    [service setMovieId:[[[self movie] valueForKey:@"id"] description]];
    [service setMovieId:[[[self movie] valueForKey:@"id"] description]];
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
    if ([self movie] != nil)   {
        [self setTitle:@"Details"];
        
        [txtFilmText setText:[[self movie] valueForKey:@"original_title"]];
        [txtFilmYear setText:[[[self movie] valueForKey:@"release_date"] description]];
        [txtRating setText:[[[self movie] valueForKey:@"vote_average"] description]];
        
        //Clear text fields
        [txtSynopsis setText:@""];
        
        //Add content already saved
        [txtSynopsis setText:[[self movie] valueForKey:@"overview"]];
        
        //Service Queue
        serviceQueue = [[NSOperationQueue alloc] init];
        [serviceQueue setMaxConcurrentOperationCount:1];
        
        //If the movie data is incomplete
        if (![[[self movie] allKeys] containsObject:@"overview"]) {
            FilmDetailsService *service = [[FilmDetailsService alloc] init];
            [service setMovieId:[[[self movie] valueForKey:@"id"] description]];
            [service setDelegate:self];
            [serviceQueue addOperation:service];
        }
        
        //Check if image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, [[self movie] valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:pngFilePath]) {
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
        } else {
            FilmDetailsService *service = [[FilmDetailsService alloc]init];
            [service setMovieId:[[[self movie] valueForKey:@"id"] description]];
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
      //  [navBar setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      //                UIBarButtonSystemItemRefresh target:self action:@selector(refreshMovieDetails)]];
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

//Links to the films trailer on a web view
- (IBAction)handleTrailerBtnPress:(id)sender {
    NSDictionary *minfo = [self movie];
    NSString * url = @"https://www.youtube.com/results?search_query=";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@+movie+trailer", url, [minfo valueForKey:@"original_title"]]]];
    NSLog(@"%@%@+trailer", url, [minfo valueForKey:@"original_title"]);
}

//Performs a google search of the film on a web page
- (IBAction)moreInfoBtn:(id)sender {
    NSDictionary *movieinfo = [[self movie] valueForKey:@"original_title"];
    NSString * url = @"https://www.google.co.uk/?gws_rd=ssl#q=";
    NSLog(@"%@%@+movie", url, movieinfo);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@+movie", url, movieinfo]]];
    
       //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.co.uk/?gws_rd=ssl#q=%@"]] ;
}

//presents options on a Action Sheet for posting to twitter or facebook with the film name
- (IBAction)shareBtn:(id)sender {
    NSDictionary *movieinfo = [[self movie] valueForKey:@"original_title"];
    NSString* shareText =@"Hi! I'm using the Wrapped! App to view the movie:";
    NSArray *itemsToShare = @[shareText, movieinfo];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes =@[];
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
