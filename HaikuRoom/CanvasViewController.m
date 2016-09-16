//
//  CanvasViewController.m
//  Haikuteer
//
//  Created by Selina Liu on 4/22/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "CanvasViewController.h"
#import <Parse/Parse.h>
@interface CanvasViewController () {
    CGSize sqSize;
    UIColor* borderColor;
}
@property (strong, nonatomic) IBOutlet UIImageView *detectionView;

@end

@implementation CanvasViewController
    const int sqSide = 375;

- (void)viewDidLoad {
    borderColor = [UIColor colorWithRed:200.0/225.0 green:200.0/225.0 blue:200.0/225.0 alpha:1.0f];
    red = 125.0/255.0;
    green = 125.0/255.0;
    blue = 125.0/255.0;
    brush = 6.0;
    opacity = 1.0;
    sqSize = CGSizeMake(sqSide, sqSide);
    [self.detectionView.layer setBorderColor: [borderColor CGColor]];
    [self.detectionView.layer setBorderWidth: 1.0];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch* touch = [touches anyObject];
    lastPoint = [touch locationInView:self.detectionView];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.detectionView];

    //UIGraphicsBeginImageContext(self.view.frame.size);
    UIGraphicsBeginImageContext(sqSize);
    
    //[self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, sqSide, sqSide)];
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!mouseSwiped) {
        //UIGraphicsBeginImageContext(self.view.frame.size);
        UIGraphicsBeginImageContext(sqSize);
        
        //[self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, sqSide, sqSide)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    //[self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.mainImage.image drawInRect:CGRectMake(0, 0, sqSide, sqSide) blendMode:kCGBlendModeNormal alpha:1.0];
    
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, sqSide, sqSide) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)postImageButtonAction:(id)sender {
    
    UIImage* origImage = self.mainImage.image;
    UIImage* thumbnailImage = [CanvasViewController createThumbnailImageFrom:origImage];
    NSData* origData = UIImageJPEGRepresentation(origImage, 1.0f);
    NSData* thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 1.0f);
    
    PFFile* origImageFile = [PFFile fileWithName:@"image.jpg" data:origData];
    PFFile* thumbnailImageFile = [PFFile fileWithName:@"thumb.jpg" data:thumbnailData];
    NSString* currUsername = [PFUser currentUser].username;
    
    PFObject* imageResponse = [PFObject objectWithClassName:@"ImageResponse"];
    [imageResponse setObject:origImageFile forKey:@"origImage"];
    [imageResponse setObject:thumbnailImageFile forKey:@"thumbnailImage"];
    [imageResponse setObject:self.haikuObjectId forKey:@"haikuObjectId"];
    [imageResponse setObject:currUsername forKey:@"ownerUsername"];
    [imageResponse saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
        if (!error) {
            NSLog(@"image saved and uploaded");
            [self.delegate refreshData];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

+ (UIImage*) createThumbnailImageFrom: (UIImage*) image {
    double dimen = 120.0;
    CGSize thumbSize = CGSizeMake(dimen, dimen);
    
    UIGraphicsBeginImageContext(thumbSize);
    [image drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
    UIImage* thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (thumbnail == nil) {
        NSLog(@"thumbnail is not created: couldn't scale the image");
    }
    return thumbnail;
}

- (IBAction)eraserButtonAction:(id)sender {
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
    brush = 10.0;
}


- (IBAction)colorButtonAction:(id)sender {
    UIButton * PressedButton = (UIButton*)sender;
    switch(PressedButton.tag) {
        case 0: //(grey)
            red = 125.0/255.0;
            green = 125.0/255.0;
            blue = 125.0/255.0;
            break;
        case 1: //251, 197, 233 (pink)
            red = 251.0/255.0;
            green = 197.0/255.0;
            blue = 233.0/255.0;
            break;
        case 2: //248, 235, 115 (yellow)
            red = 248.0/255.0;
            green = 235.0/255.0;
            blue = 115.0/255.0;
            break;
        case 3: //94, 179, 233 (blue)
            red = 94.0/255.0;
            green = 179.0/255.0;
            blue = 233.0/255.0;
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
