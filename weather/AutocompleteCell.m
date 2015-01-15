//
//  AutocompleteCell.m
//  weather
//
//  Created by Andrei Vidrasco on 1/15/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "AutocompleteCell.h"

@interface AutocompleteCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation AutocompleteCell

- (void)updateWithAddress:(NSString *)address query:(NSString *)query {
    self.addressLabel.text = address;
    self.addressLabel.font = [UIFont globalRegularFontOfSize:14.f];
    self.addressLabel.textColor = [UIColor grayTextColor];
    [self highlightSearchQuery:query inString:self.addressLabel];
}


- (void)highlightSearchQuery:(NSString *)query inString:(UILabel *)labelToFormat {
    if (!query) {
        return;
    }
    if (!labelToFormat.text) {
        return;
    }
    NSRange boldedRange = [labelToFormat.text rangeOfString:query
                                                    options:(NSCaseInsensitiveSearch)];
    NSDictionary *subAttrs = @{NSFontAttributeName: [UIFont globalBoldFontOfSize:14.f],
                               NSForegroundColorAttributeName: [UIColor blackColor]};
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont globalRegularFontOfSize:14.f],
                            NSForegroundColorAttributeName: [UIColor grayTextColor]};
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:labelToFormat.text
                                                                                       attributes:attrs];
    [attributedText setAttributes:subAttrs range:boldedRange];
    [labelToFormat setAttributedText:attributedText];
}

@end
