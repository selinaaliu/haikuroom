//
//  HaikuWallCell.h
//  HaikuRoom
//
//  Created by Selina Liu on 4/21/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface HaikuWallCell : UITableViewCell
@property (strong, nonatomic) PFObject *pfObject; //to be passed to detailed view
- (void) loadHaikuFromPFObject:(PFObject*) object;
- (NSString*)getHaikuAuthorUsername; 
@end
