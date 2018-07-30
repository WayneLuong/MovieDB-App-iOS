//
//  TVShowPictureDownloadService.h
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
@interface TVShowPictureDownloadService  : NSOperation {
    NSString *tvshowId;
    NSString *tvshowPictureUrl;
}

@property (nonatomic, retain) NSString *tvshowId;
@property (nonatomic, retain) NSString *tvshowPictureUrl;
//Property delegate is called from the service delegate class
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@end
