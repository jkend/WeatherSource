//
//  CityAutocompleteTableVC.m
//  WeatherSource
//
//  Created by Joy Kendall on 3/25/17.
//  Copyright © 2017 Joy. All rights reserved.
//

#import "CityAutocompleteTableVC.h"
#import "Model/WeatherDataManager.h"
#import "Model/Wunderground.h"
#import "CurrentConditions.h"

@interface CityAutocompleteTableVC ()
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray<NSDictionary *> *searchResults;
@property (nonatomic, strong) NSArray<NSDictionary *> *filteredResults;
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
    self.searchController.searchBar.placeholder = @"Type in a city name";
    
    // To prevent the search bar from ending up with a zero height!
    // Test, might not be necessary now.
    [self.searchController.searchBar sizeToFit];
}


// MARK: UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length < 2) {
        self.searchResults = nil;
        self.filteredResults = nil;
        [self.tableView reloadData];
    }
    else if (searchText.length == 2) {
        if (!self.searchResults) {
            [Wunderground getAutoCompletions:(NSString *)searchText
                              withCompletion:^(NSDictionary *result, NSError *error) {
                                  self.searchResults = result[@"RESULTS"];
                                  self.filteredResults = self.searchResults;
                                  // Careful, need to reload the table in the main queue,
                                  // or cellForRowAtIndexPath will never happen!
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tableView reloadData];
                                      });
                              }];
        }
    }
}

// MARK: UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length > 2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[cd] %@", searchString];
        self.filteredResults = [self.searchResults filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}


// MARK: UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filteredResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.filteredResults[indexPath.row] objectForKey:@"name"];
    return cell;
}


// MARK: UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *locationDict = self.filteredResults[indexPath.row];
    // The zmw string, apparently unique for each city, and complies with
    // acceptable key values
    NSString *newCityKey = [NSString stringWithFormat:@"zmw:%@", locationDict[@"zmw"]];
    [WeatherDataManager sharedManager].activeCityKey = newCityKey;
    [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
 
}

@end
