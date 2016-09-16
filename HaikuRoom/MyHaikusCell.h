//
//  MyHaikusViewCell.h
//  HaikuRoom
//
//  Created by Selina Liu on 4/22/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MyHaikusCell : UITableViewCell
@property (strong, nonatomic) PFObject* pfObject; 
- (void)loadHaikuFromPFObject:(PFObject*) object;
@end
