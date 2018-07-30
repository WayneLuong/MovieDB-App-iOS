//
//  FilmDetailsViewController.h
//  MyApp
//
//  Created by Wayne Luong on 27/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"
#import "FilmDetailsService.h"
#import "FilmPictureDownloadService.h"

//imports UI methods for the specified delegates
@interface FilmDetailsViewController : UIViewController < UINavigationBarDelegate, ServiceDelegate> {
      NSOperationQueue *serviceQueue;
}

//Custom declaration of the UI objects from the XIB file
//These are linked to their declared viewcontrollers via storyboard
- (IBAction)shareBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *trailerBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgFilm;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UILabel *txtFilmText;
@property (weak, nonatomic) IBOutlet UILabel *txtFilmYear;
@property (weak, nonatomic) IBOutlet UILabel *txtRating;

@property (weak, nonatomic) IBOutlet UITextView *txtSynopsis;

//Declaration of dictionary movie to store multiple fields
@property (weak, nonatomic) NSDictionary *movie;

@end
