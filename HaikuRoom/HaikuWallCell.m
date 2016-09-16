//
//  HaikuWallCell.m
//  HaikuRoom
//
//  Created by Selina Liu on 4/21/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "HaikuWallCell.h"
#import <Parse/Parse.h>
@interface HaikuWallCell()
@property (strong, nonatomic) IBOutlet UIImageView *userThumbnail;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *line0;
@property (strong, nonatomic) IBOutlet UILabel *line1;
@property (strong, nonatomic) IBOutlet UILabel *line2;

@end

@implementation HaikuWallCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadHaikuFromPFObject:(PFObject*) object {
    self.pfObject = object;
    self.username.text = [object objectForKey:@"username"];
    self.line0.text = [object objectForKey:@"line0"];
    self.line1.text = [object objectForKey:@"line1"];
    self.line2.text = [object objectForKey:@"line2"];
}


- (NSString*)getHaikuAuthorUsername {
    return self.username.text;
}

@end
