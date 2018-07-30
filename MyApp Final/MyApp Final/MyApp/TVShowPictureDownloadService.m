//
//  TVShowPictureDownloadService.m
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "TVShowPictureDownloadService.h"

@implementation TVShowPictureDownloadService

//Synthesized variables from the header file to be used in the call request
@synthesize tvshowId;
@synthesize delegate;
@synthesize tvshowPictureUrl;

//Main Method for service call request
-(void)main{
    //Synthesize the declared properties andretireive the movie image by using the url from the call request
    //then the image data is saved in png format and the delegate is finished
    NSString *url = [self tvshowPictureUrl];
    
    NSString *docDir= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, tvshowId];
    
    NSURL * aURL = [NSURL URLWithString:url];
    NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
    UIImage *tvshow_image = [UIImage imageWithData:data];
    
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(tvshow_image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    [delegate serviceFinished:self withError:NO];
}
@end

