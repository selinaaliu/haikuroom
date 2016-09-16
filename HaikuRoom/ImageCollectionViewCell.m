//
//  ImageCollectionViewCell.m
//  Haikuteer
//
//  Created by Selina Liu on 4/23/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end


@implementation ImageCollectionViewCell

- (void)setThumbnailImage:(UIImage *)image {
    self.imageView.image = image; 
}
@end
