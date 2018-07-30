//
//  TVShowsDetailsService.m
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "TVShowsDetailsService.h"


@implementation TVShowsDetailsService

//Synthesized variables from the header file to be used in the call request
@synthesize tvshowId;
@synthesize delegate;
@synthesize details;

//Main Method for service call request based on id
-(void) main {
    //Calls the api service using the tvshow id in order to call the rest of its details
    //this is validated by the api key
    NSString *api_key =@"b1e17a2d03e88832ee37518d321d4a5d";
    NSString *tvshow_id = [tvshowId stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://api.themoviedb.org/3/tv/%@?api_key=%@", tvshow_id, api_key];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
    if (responseData != nil) {
        NSError *error = nil;
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if(error) {
            [delegate serviceFinished:self withError:YES];
        }else {
            details = json;
            [delegate serviceFinished:self withError:NO];
        }
    }else{
        [delegate serviceFinished:self withError:YES];
    }
}
@end
