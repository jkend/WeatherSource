//
//  CityAutocompleteTableVC.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/25/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CityAutocompleteTableVC.h"

@interface CityAutocompleteTableVC ()
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation CityAutocompleteTableVC

// MARK: Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchControllerSetup];
}

-(void)searchControllerSetup {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // Set searchController's delegates
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    // Put search bar at top of tableView
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    
    // To prevent the search bar from ending up with a zero height!
    // Test, might not be necessary now.
    [self.searchController.searchBar sizeToFit];
}


// MARK: UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// MARK: UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}


// MARK: UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/




@end
