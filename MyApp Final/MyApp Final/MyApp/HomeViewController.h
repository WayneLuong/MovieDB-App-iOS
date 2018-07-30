//
//  HomeViewController.h
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"
#import "BoxOfficeService.h"

//View controller for the Home tab
@interface HomeViewController : UIViewController<UITabBarDelegate, UITableViewDataSource, ServiceDelegate>
{
   NSMutableArray *filmData;
   NSOperationQueue * serviceQueue;
}
@property (weak, nonatomic) IBOutlet UITableView *popularTable;

@end

