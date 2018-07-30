//
//  TVShowsSearchService.h
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <Foundation/Foundation.h>
#import "ServiceDelegate.h"

//Declaration of variables required by the service call
@interface TVShowsSearchService : NSOperation{
    NSString * searchTerm;
    id<ServiceDelegate> delegate;
    
    NSArray *results;
}

@property (nonatomic, retain) NSString *searchTerm;
//Property delegate is called from the service delegate class
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@property (nonatomic, retain) NSArray *results;

@end

