//
//  HaikuDetailsViewController.h
//  Haikuteer
//
//  Created by Selina Liu on 4/22/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RefreshProtocol.h"
@interface HaikuDetailsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RefreshProtocol>
@property (strong, nonatomic) IBOutlet UILabel *line0;
@property (strong, nonatomic) IBOutlet UILabel *line1;
@property (strong, nonatomic) IBOutlet UILabel *line2;
@property (strong, nonatomic) IBOutlet UILabel *authorNameDisplay;

@property (strong, nonatomic) PFObject* pfObject;
@end
