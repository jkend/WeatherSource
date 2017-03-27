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
@end

#define STATUS_BAR_HEIGHT   20.0
#define NAV_BAR_HEIGHT      44.0
#define SEARCH_BAR_PLACEHOLDER_TEXT     @"Type in a city name"

@implementation CityAutocompleteTableVC

// MARK: Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchControllerSetup];
}

-(void)searchControllerSetup {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // Set searchController's delegates
    self.searchController.searchBar.delegate = self;
    
    // Put search bar at top of tableView
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Adjust content offset and inset to keep search bar from appearing under the status bar.
    // Since we're not showing the nav bar we need the offset.  I'm using constants here, don't judge.
    self.tableView.contentOffset = CGPointMake(0, -NAV_BAR_HEIGHT);
    self.tableView.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0.0, 0.0, 0.0);
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.placeholder = SEARCH_BAR_PLACEHOLDER_TEXT;
    
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
        [self.tableView reloadData];
    }
    else {
        // The autocomplete sends different result with each new character, so we
        // have to query it each time the text changes.
        // I'd thought it would be enough to query it once with maybe 2 characters,
        // get back a huge list, and then do:
        //
        //      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[cd] %@", searchString];
        //      self.filteredResults = [self.searchResults filteredArrayUsingPredicate:predicate];
        //      [self.tableView reloadData];
        //
        // But that's what you do when you start with a known set of items - not using an
        // an external API for autocompletion.
        [Wunderground getAutoCompletions:(NSString *)searchText
                          withCompletion:^(NSDictionary *result, NSError *error) {
                              self.searchResults = result[WUNDERGROUND_AUTOCOMPLETE_RESULTS];
                              // Careful, need to reload the table in the main queue,
                              // or cellForRowAtIndexPath will never happen!
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.tableView reloadData];
                                  });
                          }];

    }
}


// MARK: UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.searchResults[indexPath.row] objectForKey:@"name"];
    return cell;
}


// MARK: UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *locationDict = self.searchResults[indexPath.row];
    // The zmw string, apparently unique for each city, and complies with
    // acceptable key values.  Storing it with a zmw: prefix makes it handy
    // for plunking into a query string later on.
    NSString *newCityKey = [NSString stringWithFormat:@"zmw:%@", locationDict[@"zmw"]];
    [WeatherDataManager sharedManager].activeCityKey = newCityKey;
    
    // Because we're in a second navigation controller, calling self.navigationcontroller popToRoot isn't enough.
    [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
 
}

@end
