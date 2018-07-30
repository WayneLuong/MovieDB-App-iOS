//
//  Service Delegate.h
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <Foundation/Foundation.h>

//Protocol file for the implementation files that uses the protocol 'serviceFinished'
@protocol ServiceDelegate <NSObject>

-(void) serviceFinished:(id)service withError:(BOOL)error;

@end
