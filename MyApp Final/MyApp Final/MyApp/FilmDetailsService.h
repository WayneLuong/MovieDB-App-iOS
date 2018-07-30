//
//  FilmDetailsService.h
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"

//Declaration of variables required by the service call
@interface FilmDetailsService : NSOperation{
    
    //Represent the movie id when retrieving data
    NSString *movieId;
    id<ServiceDelegate> delegate;
    
    //Dictionary to store an array of details
    NSDictionary *details;
}

@property (nonatomic, retain) NSString *movieId;
//Property delegate is called from the service delegate class
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@property (nonatomic, retain) NSDictionary *details;

@end
