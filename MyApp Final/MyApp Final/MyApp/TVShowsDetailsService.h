//
//  TVShowsDetailsService.h
//  MyApp
//
//  Created by Wayne Luong on 02/03/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"

//Declaration of variables required by the service call
@interface TVShowsDetailsService : NSOperation{
    NSString *tvshowId;
    id<ServiceDelegate> delegate;
    
    NSDictionary *details;
}

@property (nonatomic, retain) NSString *tvshowId;
@property (nonatomic, retain) NSDictionary *details;

//Property delegate is called from the service delegate class
@property (nonatomic, retain) id<ServiceDelegate> delegate;


@end
