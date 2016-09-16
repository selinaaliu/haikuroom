//
//  ImageCollectionViewFlowLayout.m
//  Haikuteer
//
//  Created by Selina Liu on 4/23/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "ImageCollectionViewFlowLayout.h"

@implementation ImageCollectionViewFlowLayout
const double d = 2.5;
- (id)init {
    if (!(self = [super init])) return nil;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.itemSize = CGSizeMake(120.5, 120.5);
    self.sectionInset = UIEdgeInsetsMake(1.5,d,d,d);
    
    self.minimumInteritemSpacing = d;
    self.minimumLineSpacing = d;
    return self;
}

@end
