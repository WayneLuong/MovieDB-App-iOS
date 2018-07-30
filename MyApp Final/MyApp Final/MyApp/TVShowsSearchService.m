//
//  TVShowsSearchService.m
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "TVShowsSearchService.h"

@implementation TVShowsSearchService

//Synthesized variables from the header file to be used in the call request
@synthesize searchTerm;
@synthesize delegate;

@synthesize results;

//Main Method for service call request
- (void)main{
    //Finds similar search terms using the synthesize property 'search_term' and the api url 
    NSString *api_key = @"b1e17a2d03e88832ee37518d321d4a5d";
    NSString *search_term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/tv?query=%@&api_key=%@",search_term,api_key];
    
    NSURLRequest * theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
    if (responseData != nil ) {
        NSError *error = nil;
        NSDictionary*json = [NSJSONSerialization JSONObjectWithData:responseData
                                                            options:kNilOptions error:&error];
        
        if(error) {
            [delegate serviceFinished:self withError:YES];
        } else {
            results = (NSArray *)[json valueForKey:@"results"];
            [delegate serviceFinished:self withError:NO];
        }
    } else {
        [delegate serviceFinished:self withError:YES];
    }
}
@end

