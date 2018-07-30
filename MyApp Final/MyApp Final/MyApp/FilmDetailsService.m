//
//  FilmDetailsService.m
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "FilmDetailsService.h"

@implementation FilmDetailsService

//Synthesized variables from the header file to be used in the call request
@synthesize movieId;
@synthesize delegate;
@synthesize details;

//Main Method for service call request based on movie id
-(void) main {
    //Calls the api service using the movie id in order to call the rest of its details
    //this is validated by the api key
    NSString *api_key =@"b1e17a2d03e88832ee37518d321d4a5d";
    NSString *movie_id = [movieId stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@", movie_id, api_key];
    
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


