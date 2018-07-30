//
//  BoxOfficeService.h
//  MyApp
//
//  Created by Wayne Luong on 09/03/2015.
//  Copyright (c) 2015 Wayne Luong. All rights reserved.
//

//Imports from other classes
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"

//Declaration of variables required by the service call
@interface BoxOfficeService : NSOperation{
    
    id<ServiceDelegate> delegate;
    
    //Dictionary to store an array of details
    NSDictionary *details;
}

//Property delegate is called from the service delegate class
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@property (nonatomic, retain) NSDictionary *details;

@end