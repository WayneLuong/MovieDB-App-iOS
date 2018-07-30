//
//  HomeViewController.m
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "HomeViewController.h"

@interface HomeViewController (){

}

@end

@implementation HomeViewController

@synthesize popularTable;

//Service response code called from Service delegate header file for BoxOfficeService
-(void )serviceFinished:(id)service withError:(BOOL)error {
    if(!error){
        
        // Remove all items in the filmData Array
        [filmData removeAllObjects];
        
        //Loops through to store the data in a dictionary
        for (NSDictionary *movie in [service results]){
            
            // Create a dictionary to store multiple values for a movie
            NSMutableDictionary *m_info = [[NSMutableDictionary alloc] initWithCapacity:3];
            
            // Store given variables
            [m_info setValue:[movie valueForKey:@"id"] forKey:@"id"];
            [m_info setValue:[movie valueForKey:@"title"] forKey:@"title"];
            [m_info setValue:[movie valueForKey:@"year"] forKey:@"year"];
            
            // Add movie to main list
            [filmData addObject:m_info];
            
        } // End for loop
        
        // If there are no results found
        if ([filmData count] == 0) {
            [filmData addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"No Results Found", @"", nil]
                                                                 forKeys:[NSArray arrayWithObjects:@"id", @"title", @"year", nil]]];
        }
    } else {
        
        // Remove all objects
        [filmData removeAllObjects];
        
        // Add new Objects
        [filmData addObject: [NSDictionary dictionaryWithObjects:[NSMutableArray arrayWithObjects:@"-1", @"There has been an Error", @"", nil] forKeys:[NSMutableArray arrayWithObjects:@"id", @"title", @"release_date", nil]]];
        [popularTable reloadData];
    }
}

//Specifies the view when the tab view first loads
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    filmData = [NSMutableArray arrayWithObjects:@"Batman",
             @"Iron Man", @"Ip Man",nil];
    
    // Set up service queue
    serviceQueue = [[NSOperationQueue alloc] init];
    [serviceQueue setMaxConcurrentOperationCount:1];
    
  /*  //Declare a new instance of FilmSearchService
    NSLog(@"Service Run");
    BoxOfficeService *service = [[BoxOfficeService alloc]init];
    //Runs the call request and search using the variable searchTerm
    [service setDelegate:self];
    [serviceQueue addOperation:service];*/

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table Methods
//===========================================================================================================================================================
#pragma mark - Table view data source

//Defines the layout of the table e.g. sections, no. of rows and columns
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. 10 rows0
    return [filmData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [filmData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"AppIcon.png"];
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

//TableView methods for interacting with the table
//Method for interacting with the selected row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Set the background of the tableview (Red)
    UIColor *color = [UIColor colorWithRed:145.0f/255.0f
                                     green:12.0f/255.0f
                                      blue:12.0f/255.0f
                                     alpha:1.0f];
    // Set the background of each cell to the specified color
    [cell setBackgroundColor:color];
    
}

@end
