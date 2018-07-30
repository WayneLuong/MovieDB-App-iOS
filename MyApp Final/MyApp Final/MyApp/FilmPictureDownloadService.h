//
//  FilmPictureDownloadService.h
//  MyApp
//
//  Created by Wayne Luong on 27/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"

//Declaration of variables required by the service call
@interface FilmPictureDownloadService : NSOperation {
    NSString *movieId;
    NSString *moviePictureUrl;
}

@property (nonatomic, retain) NSString *movieId;
@property (nonatomic, retain) NSString *moviePictureUrl;
//Property delegate is called from the service delegate class
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@end

