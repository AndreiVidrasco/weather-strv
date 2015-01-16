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

@interface WTHSearchInputViewController () <UISearchBarDelegate, UITextFieldDelegate, UITableViewDelegate>

@property (readwrite) NSArray *suggestionsList;

@property (weak, nonatomic) id<SearchInputViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL shouldDisplayLoadingIndicator;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *autocompleteSearchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@end

@implementation WTHSearchInputViewController

+ (instancetype)instantiateWithDelegate:(id<SearchInputViewControllerDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTHSearchInputViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([WTHSearchInputViewController class])];
    viewController.delegate = delegate;
    
    return viewController;
}


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self displayCurrentLocationAndFrequestSearches];
    [self adjustVisualSearchBar];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self adjustVisualSearchBar];
}


#pragma mark UITableView Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WTHAutocompleteCell prefferedHeight];
}


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


#pragma mark - Actions

- (IBAction)cancelSearch:(id)sender {
    [self.autocompleteSearchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private Methods

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


- (void)geocodePoint:(NSString *)locationPointName {
    __weak WTHSearchInputViewController *weakSelf = self;
    [[WTHGMapsRequester sharedManager] geocodeString:locationPointName completionBlock:^(WTHGeoLocation *geoLocation) {
        if ([weakSelf.delegate respondsToSelector:@selector(searchInputVC:didFinishPickingLocation:)]) {
            [weakSelf.delegate searchInputVC:self didFinishPickingLocation:geoLocation];
        }
        [[SRCFrequentSuggestionsManager sharedManager] insertQuerryIntoDatabaseIfNew:geoLocation.address];
        [weakSelf.autocompleteSearchBar resignFirstResponder];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)adjustVisualSearchBar {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueTextColor];
    self.autocompleteSearchBar.scopeBarBackgroundImage = [[UIImage imageNamed:@"location_input"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 8, 4, 8)];
    [self.autocompleteSearchBar setImage:[UIImage imageNamed:@"location_search"]
                        forSearchBarIcon:UISearchBarIconSearch
                                   state:UIControlStateNormal];
    [self.autocompleteSearchBar setImage:[UIImage imageNamed:@"location_close"]
                        forSearchBarIcon:UISearchBarIconClear
                                   state:UIControlStateNormal];
    UIView *view = [self.autocompleteSearchBar.subviews firstObject];
    for (UIView *backgroundView in view.subviews) {
        if ([NSStringFromClass([backgroundView class]) isEqualToString:@"UIView"]) {
            for (UIView *subSubView in [backgroundView subviews]) {
                if ([NSStringFromClass([subSubView class]) isEqualToString:@"_UISearchBarScopeBarBackground"]) {
                    [subSubView setFrame:CGRectMake(0, 0, subSubView.frame.size.width, self.autocompleteSearchBar.frame.size.height)];
                }
            }
        } else if ([NSStringFromClass([backgroundView class]) isEqualToString:@"UISearchBarTextField"]) {
            for (UIView *subSubView in [backgroundView subviews]) {
                if ([NSStringFromClass([subSubView class]) isEqualToString:@"_UISearchBarSearchFieldBackgroundView"]) {
                    for (UIView *subSubSubView in [subSubView subviews]) {
                        if ([subSubSubView respondsToSelector:@selector(setHidden:)]) {
                            [subSubSubView setHidden:YES];
                        }
                    }
                }
            }
        }
    }
}

@end
