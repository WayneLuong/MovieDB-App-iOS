//
//  TVShowsDetailsViewController.h
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"
#import "TVShowsDetailsService.h"
#import "TVShowPictureDownloadService.h"

//imports UI methods for the specified delegates
@interface TVShowsDetailsViewController : UIViewController < UINavigationBarDelegate, ServiceDelegate> {
    NSOperationQueue *serviceQueue;
}

//Custom declaration of the UI objects from the XIB file
//These are linked to their declared viewcontrollers via storyboard
- (IBAction)shareBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *trailerBtn;
@property (weak, nonatomic) IBOutlet UIButton *MoreInfoBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgTVShow;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *txtTVShowText;
@property (weak, nonatomic) IBOutlet UILabel *txtTVShowYear;

@property (weak, nonatomic) IBOutlet UITextView *txtSynopsis;

//Declaration of dictionary tvshow to store multiple fields
@property (weak, nonatomic) NSDictionary *tvshow;

@end