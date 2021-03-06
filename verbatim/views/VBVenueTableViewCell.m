//
//  VBVenueTableViewCell.m
//  verbatim
//
//  Created by Jonathan Azoff on 4/19/14.
//  Copyright (c) 2014 Verbatim. All rights reserved.
//

#import "VBVenueTableViewCell.h"
#import "VBLabel.h"
#import "UIImage+Overlay.h"

@interface VBVenueTableViewCell ()

@property (weak, nonatomic) IBOutlet VBLabel *nameLabel;
@property (weak, nonatomic) IBOutlet VBLabel *addressLabel;
@property (weak, nonatomic) IBOutlet VBLabel *userCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sourceImage;

@end

@implementation VBVenueTableViewCell

-(void)setVenue:(VBVenue *)venue
{
    _venue = venue;
    self.nameLabel.text = venue.name;
    self.addressLabel.text = venue.address;
    [self.venue checkedInUserCountWithSuccess:^(int count) {
        self.userCountLabel.text = [[NSNumber numberWithInt:count] stringValue];
    } andFailure:^(NSError *error) {
        self.userCountLabel.text = @"0";
        NSLog(@"[ERROR] Unable to get user count, displaying 0. Reason: %@", error);
    }];
    [self updateStyleForState];
}

- (void)updateStyleForState
{
    VBUser *current = [VBUser currentUser];
    BOOL selected = current != nil && [self.venue isEqualObject:current.venue];
    id color = selected ? [VBColor activeColor] : [VBColor translucsentTextColor];
    id image = selected ? @"checkmark" : @"person";
    self.nameLabel.textColor =
    self.addressLabel.textColor =
    self.userCountLabel.textColor = color;
    self.sourceImage.image = [[UIImage imageNamed:image] imageByApplyingOverlayColor:color];
}

- (void)awakeFromNib
{
    id color = [VBColor translucsentTextColor];
    self.sourceImage.image = [self.sourceImage.image
                              imageByApplyingOverlayColor:color];
}

@end
