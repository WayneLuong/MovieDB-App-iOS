//
//  TVListViewController.m
//  MyApp
//
//  Created by Wayne Luong on 26/02/2015.
//  Copyright (c) 2015 Wayne Luong . All rights reserved.
//

//Imports from other classes
#import "TVListViewController.h"

@interface TVListViewController ()

@end

//Service methods
//===========================================================================================================================================================
@implementation TVListViewController

//Service response code called from Service delegate header file for TVShowsSearchService
-(void) serviceFinished:(id)service withError:(BOOL)error  {
    //Enter Service response code
    if (!error) {
        [searchResults removeAllObjects];
        
        for (NSDictionary *shows in [service results]) {
            //create dictionary to store multiple values for a tv show
            NSMutableDictionary *t_info = [[NSMutableDictionary alloc] initWithCapacity:3];
            
            //store given variables
            [t_info setValue:[shows valueForKey:@"id"] forKey:@"id"];
            [t_info setValue:[shows valueForKey:@"original_name"] forKey:@"original_name"];
            [t_info setValue:[shows valueForKey:@"first_air_date"] forKey:@"first_air_date"];
            
            //add tv show info to main list
            [searchResults addObject:t_info];
        }
        
        // if there are no results found
        //then display a error text
        if ([searchResults count] == 0) {
            [searchResults addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"No Results Found", @"", nil]
                                                                 forKeys:[NSArray arrayWithObjects:@"id", @"original_name", @"first_air_date", nil]]];
        }
        
        [[self tableView] reloadData];
        //Else show an error message
    } else {
        [searchResults removeAllObjects];
        [searchResults addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"There has been an error", @"", nil]
                                                             forKeys:[NSArray arrayWithObjects:@"id", @"original_name", @"first_air_date", nil]]];
        //Refresh table view
        [[self tableView] reloadData];
    }
}

//Methods for describing how the view will appear when run
//===========================================================================================================================================================
-(void) viewWillAppear:(BOOL)animated   {
    //Save Films list returned to list view
    [super viewWillAppear:animated];
    
    //Writes the film list to the xml file 'tvshows.xml'
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *yourArrayFileName = [documentDirectory stringByAppendingPathComponent:@"tvShows.xml"];
    [tvShows writeToFile:yourArrayFileName atomically:YES];
}

//Initilisation of the view after it has loaded
- (void)viewDidLoad {
    [super viewDidLoad];
    // Custom initialization
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Initialises the layout of the table and its cells when the view is loaded
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setTitle:@"My TV Shows"];
        
        //set up Search Bar for searching tv shows
        [searchBar setPlaceholder:@"TV Show Title"];
        [searchBar setDelegate:self];
        searching = NO;
        
        //create basic TV Show List for testing display
        tvShows = [NSMutableArray arrayWithCapacity:10];
        searchResults = [NSMutableArray arrayWithCapacity:10];
        
        // Set up service queue
        serviceQueue = [[NSOperationQueue alloc] init];
        [serviceQueue setMaxConcurrentOperationCount:1];
        
        //restore saved film list
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"tvShows.xml"];
        tvShows = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
        if (tvShows == nil) {
            tvShows = [NSMutableArray arrayWithCapacity:10];
        }
        //sort films
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"original_name" ascending:YES];
        [tvShows sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        
        //Shows the edit button to remove tv shows which is in by default
        [navBar setLeftBarButtonItem:[self editButtonItem]];
        
    }
    return self;
}
//===========================================================================================================================================================


//Search Methods
//===========================================================================================================================================================
//Method for when text is being inputted into the searchbar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // set the state to be searching
    searching = YES;
    
    // add cancel/done button to navigation bar
    [navBar setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(searchDone:)]];
    
    //Hides the edit button
    [navBar setLeftBarButtonItem:nil];
    
    //Force table to reload and redraw
    [searchResults removeAllObjects];
    [[self tableView] reloadData];
}

//Method for when the search is completed
- (void)searchDone:(id)sender
{
    //clear search text
    [searchBar setText:@""];
    
    //hide the keyboard from the searchbar
    [searchBar resignFirstResponder];
    
    //remove the cancel/done button from navigation bar
    [navBar setRightBarButtonItem:nil];
    
    //Shows the edit button to remove a selected tv show which is in by default
    [navBar setLeftBarButtonItem:[self editButtonItem]];
    
    //clear search results and reset state
    searching = NO;
    [searchResults removeAllObjects];
    
    //force table to reload and redraw
    [[self tableView] reloadData];
}

//Method for when search is initialised
-(void)searchBarSearchButtonClicked: (UISearchBar *)sb
{
    //retrieve search term from search bar
    NSString *searchTerm = [searchBar text];
    
    //Declare a new instance of FilmSearchService
    TVShowsSearchService *service = [[TVShowsSearchService alloc]init];
    //Runs the call request and search using the variable searchTerm
    [service setSearchTerm:searchTerm];
    [service setDelegate:self];
    [serviceQueue addOperation:service];
    
    //Removes the the previous search results and updates with the current search results
    [searchResults removeAllObjects];
    //Display text 'searching' while searching
    [searchResults addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"Searching . . .", @"", nil]
                                                         forKeys:[NSArray arrayWithObjects:@"id", @"original_name", @"first_air_date", nil]]];
    [[self tableView] reloadData];
    
    //===DEBUGGING===
    //log search term on terminal
    NSLog(@" TV Show Search Term : %@", searchTerm);
    
    //hide the keyboard from searchBar
    [searchBar resignFirstResponder];
}
//===========================================================================================================================================================

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
    //Returns the number of search results while searching
    return searching ? [searchResults count] : [tvShows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *shows = searching ? [searchResults objectAtIndex:[indexPath row]] : [tvShows objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[shows valueForKey:@"original_name"]];
    [[cell detailTextLabel] setText:[[shows valueForKey:@"first_air_date"] description]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return !searching;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If row is deleted remove it from the list
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Remove from arrays
        NSDictionary *shows = [tvShows objectAtIndex:[indexPath row]];
        
        //Delete Thumbnail if present
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath =[NSString stringWithFormat:@"%@/%@.png",docDir,[shows valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]) {
            [fileManager removeItemAtPath:pngFilePath error:nil];
        }
        
        //Remove from list and save changes
        [tvShows removeObject:shows];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex: 0];
        NSString *yourArrayFileName = [documentsDirectory stringByAppendingString:@"tvShows.xml"];
        [tvShows writeToFile:yourArrayFileName atomically:YES];
        
        //Trigger remove animation on Table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationRight];
    }
}


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
    if (searching) {
        //Use for interaction with search list
        //New dictionary movie to store the film selected at the row
        NSDictionary *shows = [searchResults objectAtIndex:[indexPath row]];
        
        //check label for system messages
        if ([[shows valueForKey:@"id"] intValue] != -1) {
            //add new film to list
            [tvShows addObject:shows];
            
            //clear search text
            [searchBar setText:@""];
            
            //remove the cancel/done button from navigation bar
            [navBar setRightBarButtonItem:nil];
            
            //clear search results and reset state
            searching = NO;
            [searchResults removeAllObjects];
            
            //force table to reload and redraw
            [[self tableView] reloadData];
            
            //sort films
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"original_name" ascending:YES];
            [tvShows sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
            
            //store data
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"tvShows.xml"];
            [tvShows writeToFile:yourArrayFileName atomically:YES];
        }
        //if searching is not true then navigate to new view controller (detailsViewController)
    } else {
        //use for interaction with film list
        //New dictionary movie to store the film selected at the row
        NSDictionary *shows = [tvShows objectAtIndex:[indexPath row]];
        
        TVShowsDetailsViewController *vc=[[TVShowsDetailsViewController alloc]
                                       initWithNibName:@"TVShowsDetailsViewController" bundle:nil ];
        [vc setTvshow:shows];
        
        //=====DEBUGGING=====
        NSLog(@"Test");
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

//Attempt using segues
/*-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender   {
 if ([segue.identifier isEqualToString:@"test"]){
 NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
 TVShowsDetailsViewController* vc =segue.destinationViewController;
 vc.tvshows = [tvshow objectAtIndex:[indexPath row]];
 }
 }*/

//Method for declaring how the cells are displayed
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Set the background of the tableview (Red)
    UIColor *color = [UIColor colorWithRed:145.0f/255.0f
                                     green:12.0f/255.0f
                                      blue:12.0f/255.0f
                                     alpha:1.0f];
    // Set the background of each cell to the specified color
    [cell setBackgroundColor:color];
    
    [[self tableView] setSeparatorColor:[UIColor redColor]];
    
}
@end
