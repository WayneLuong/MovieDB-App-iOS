//
//  FilmPictureDownloadService.m
//  MyApp
//
//  Created by Wayne Luong on 27/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "FilmPictureDownloadService.h"

@implementation FilmPictureDownloadService

//Synthesized variables from the header file to be used in the call request
@synthesize movieId;
@synthesize delegate;
@synthesize moviePictureUrl;

//Main Method for service call request
-(void)main{
    //Synthesize the declared properties andretireive the movie image by using the url from the call request
    //then the image data is saved in png format and the delegate is finished
    NSString *url = [self moviePictureUrl];
    
    NSString *docDir= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, movieId];
    
    NSURL * aURL = [NSURL URLWithString:url];
    NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
    UIImage *movie_image = [UIImage imageWithData:data];
    
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(movie_image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    [delegate serviceFinished:self withError:NO];
}
@end