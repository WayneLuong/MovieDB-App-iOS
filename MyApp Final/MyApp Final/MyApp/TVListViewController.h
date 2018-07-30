//
//  TVListViewController.h
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"
#import "TVShowsSearchService.h"
#import "TVShowsDetailsViewController.h"

//imports UI methods for the specified delegates
@interface TVListViewController :  UITableViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ServiceDelegate>
{
    
    //Custom declaration of navigation bar and search bar
    __weak IBOutlet UISearchBar *searchBar;
    
    __weak IBOutlet UINavigationItem *navBar;
    
    //Boolean value to indicate whether the searchbar is searching or not
     BOOL searching;
    
    //Declaration of arrays to store film results
    NSMutableArray *tvShows;
    NSMutableArray *searchResults;
    
    //Operation queue used to run the service
    NSOperationQueue * serviceQueue;
}

@end
