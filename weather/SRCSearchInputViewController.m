//
//  SRCSearchInputViewController.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "SRCSearchInputViewController.h"
#import "GeoLocation.h"

#import "AutocompleteCell.h"
#import "SRCFrequentSuggestionsManager.h"
#import "GMapsRequester.h"

@interface SRCSearchInputViewController () <UISearchBarDelegate, UITextFieldDelegate, UITableViewDelegate>

@property (readwrite) NSArray *suggestionsList;

@property (weak, nonatomic) id<SearchInputViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL shouldDisplayLoadingIndicator;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *autocompleteSearchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation SRCSearchInputViewController

+ (instancetype)instantiateWithDelegate:(id<SearchInputViewControllerDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SRCSearchInputViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SRCSearchInputViewController class])];
    viewController.delegate = delegate;
    
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
    AutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:[AutocompleteCell cellIdentifier]];
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
    
    __weak SRCSearchInputViewController *weakSelf = self;
    [[GMapsRequester sharedManager] autcompleteForSearchString:querryText completionBlock:^(NSArray *completionItems) {
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
    __weak SRCSearchInputViewController *weakSelf = self;
    [[GMapsRequester sharedManager] geocodeString:locationPointName completionBlock:^(GeoLocation *geoLocation) {
        if ([weakSelf.delegate respondsToSelector:@selector(searchInputVC:didFinishPickingLocation:)]) {
            [weakSelf.delegate searchInputVC:self didFinishPickingLocation:geoLocation];
        }
        [[SRCFrequentSuggestionsManager sharedManager] insertQuerryIntoDatabaseIfNew:geoLocation.address];
        [weakSelf.autocompleteSearchBar resignFirstResponder];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
