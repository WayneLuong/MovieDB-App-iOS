//
//  BoxOfficeService.m
//  MyApp
//
//  Created by Wayne Luong on 09/03/2015.
//  Copyright (c) 2015 Wayne Luong. All rights reserved.
//

#import "BoxOfficeService.h"

@implementation BoxOfficeService

//Synthesized variables from the header file to be used in the call request

@synthesize delegate;
@synthesize details;

//Main Method for service call request based on movie id

-(void) main {
    //Calls the api service using api key and url
    NSString *api_key =@"vk25mwcxh2t7jv6mu8d2bxy3";
    NSString *url = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=%@", api_key];
    
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
