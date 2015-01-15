//
//  SRCSearchInputViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "WTHSearchInputViewController.h"
#import "WTHGeoLocation.h"

#import "WTHAutocompleteCell.h"
#import "SRCFrequentSuggestionsManager.h"
#import "WTHGMapsRequester.h"
#import "WTHNetwork.h"

@interface WTHSearchInputViewController () <UISearchBarDelegate, UITextFieldDelegate, UITableViewDelegate>

@property (readwrite) NSArray *suggestionsList;

@property (assign, nonatomic) BOOL shouldDisplayLoadingIndicator;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *autocompleteSearchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation WTHSearchInputViewController

+ (instancetype)instantiate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTHSearchInputViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([WTHSearchInputViewController class])];
    
    return viewController;
}


#pragma mark - View Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueTextColor];
    [self displayCurrentLocationAndFrequestSearches];
    [self fixMissingSeparatorForLastCell];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueTextColor];
    self.autocompleteSearchBar.tintColor = [UIColor blueTextColor];
    self.autocompleteSearchBar.delegate = self;
    self.autocompleteSearchBar.text = @"";
}


#pragma mark UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.suggestionsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTHAutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:[WTHAutocompleteCell cellIdentifier]];
    [cell updateWithAddress:self.suggestionsList[indexPath.row] query:self.autocompleteSearchBar.text];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self geocodePoint:self.suggestionsList[indexPath.row]];
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self retrieveQuerryForText:searchText];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.tableview reloadData];
}


- (IBAction)cancelSearch:(id)sender {
    [self.autocompleteSearchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)displayCurrentLocationAndFrequestSearches {
    self.suggestionsList = [self recentSearchesArray];
    [self.tableview reloadData];
}


- (void)performQuerryForText:(NSString *)querryText {
    if ([querryText length] == 0) {
        [self displayCurrentLocationAndFrequestSearches];
        [self stopLoadingIndicator];
        return;
    }
    
    __weak WTHSearchInputViewController *weakSelf = self;
    [[WTHGMapsRequester sharedManager] autcompleteForSearchString:querryText completionBlock:^(NSArray *completionItems) {
        weakSelf.suggestionsList = completionItems;
        [weakSelf.tableview reloadData];
        [weakSelf stopLoadingIndicator];
    }];
}


- (void)retrieveQuerryForText:(NSString *)text {
    self.shouldDisplayLoadingIndicator = YES;
    [self performSelector:@selector(displayLoadingIndicator) withObject:nil afterDelay:1.0f];
    [self performQuerryForText:text];
}


- (void)displayLoadingIndicator {
    if (self.shouldDisplayLoadingIndicator) {
        [self.loadingIndicator startAnimating];
    }
}


- (void)stopLoadingIndicator {
    self.shouldDisplayLoadingIndicator = NO;
    [self.loadingIndicator stopAnimating];
}


- (NSArray *)recentSearchesArray {
    NSArray *recentSearches = [[SRCFrequentSuggestionsManager sharedManager] fetchRecentSearches];
    if (recentSearches && ([recentSearches count] <= 0)) return nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SearchQuerryEntity *entity in recentSearches) {
        [array addObject:entity.searchQueery];
    }
    
    return [[array reverseObjectEnumerator] allObjects];
}


- (void)fixMissingSeparatorForLastCell {
    CGRect frame = self.tableview.tableFooterView.frame;
    CGRect sepFrame = CGRectMake(0, 0, frame.size.width, 0.5f);
    UIView *separatorView = [[UIView alloc] initWithFrame:sepFrame];
    separatorView.backgroundColor = self.tableview.separatorColor;
    [self.tableview.tableFooterView addSubview:separatorView];
}


- (void)geocodePoint:(NSString *)locationPointName {
    __weak WTHSearchInputViewController *weakSelf = self;
    [[WTHNetwork sharedManager] makeRequestWithQuerry:locationPointName success:^(id responseObject) {
        
        [[SRCFrequentSuggestionsManager sharedManager] insertQuerryIntoDatabaseIfNew:geoLocation.address];
        [weakSelf.autocompleteSearchBar resignFirstResponder];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
