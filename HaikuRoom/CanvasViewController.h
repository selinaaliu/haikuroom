//
//  CanvasViewController.h
//  Haikuteer
//
//  Created by Selina Liu on 4/22/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshProtocol.h"

@interface CanvasViewController : UIViewController {
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (strong, nonatomic) NSString *haikuObjectId;
@property id<RefreshProtocol> delegate;

@end
