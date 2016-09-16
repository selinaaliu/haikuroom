//
//  HaikuDetailsViewController.m
//  Haikuteer
//
//  Created by Selina Liu on 4/22/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "HaikuDetailsViewController.h"
#import "CanvasViewController.h"
#import "ImageCollectionViewFlowLayout.h"
#import "ImageCollectionViewCell.h"
@interface HaikuDetailsViewController ()
{
    NSString* authorUsername;
    NSString* haikuObjectId;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ImageCollectionViewFlowLayout* flowLayout;
@property (strong, nonatomic) NSMutableArray* dataSource; //just thumbnail images
@property (strong, nonatomic) NSMutableArray* imageResponses;

@property (strong, nonatomic) IBOutlet UIButton *drawButton;

@end

@implementation HaikuDetailsViewController

- (void)viewDidLoad {
    //display haiku
    self.line0.text = self.pfObject[@"line0"];
    self.line1.text = self.pfObject[@"line1"];
    self.line2.text = self.pfObject[@"line2"];
    authorUsername = [self.pfObject objectForKey:@"username"];
    self.authorNameDisplay.text = authorUsername;
    haikuObjectId = self.pfObject.objectId; 
    self.flowLayout = [[ImageCollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //CGFloat greyFloat = 200.0/255.0;
    self.collectionView.backgroundColor = [UIColor colorWithRed:229/255.0 green:185/255.0 blue:185/255.0 alpha:0.4];
    //load all photos
    self.dataSource = [[NSMutableArray alloc] init];
    self.imageResponses = [[NSMutableArray alloc] init];
    [self fetchImageResponsesFromDatabase];
    NSString* currUsername = [PFUser currentUser].username;
    if ([self.authorNameDisplay.text isEqualToString:currUsername]) {
        self.drawButton.hidden = YES;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addDrawingButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"goToCanvas" sender:self];
}

- (void) fetchImageResponsesFromDatabase {
    PFQuery* query = [PFQuery queryWithClassName:@"ImageResponse"];
    [query whereKey:@"haikuObjectId" equalTo:haikuObjectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            if ([self.dataSource count] > 0 && [self.imageResponses count] > 0) {
                [self.dataSource removeAllObjects];
                [self.imageResponses removeAllObjects];
            }
            for (PFObject* object in objects) {
                [self.imageResponses addObject:object];
                PFFile* thumbnailImageFile = object[@"thumbnailImage"];
                [thumbnailImageFile getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error) {
                    if (!error) {
                        UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                        [self.dataSource addObject:thumbnailImage];
                    }
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.collectionView reloadData];
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


#pragma mark - UICollectionView Datasource and Delegate methods
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UICollectionViewCell* ) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell* cell = (ImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:
                                     @"thumbnailCell" forIndexPath:indexPath];
    //other cell setups
    //cell.layer.borderWidth = 2.0f;
    //CGFloat greyFloat = 200.0/255.0;
    //cell.layer.borderColor = [UIColor colorWithRed:greyFloat green:greyFloat blue:greyFloat alpha:1.0].CGColor;

    [cell setThumbnailImage: [self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

-(void) refreshData {
    [self fetchImageResponsesFromDatabase];
    [self.collectionView reloadData];
}

-(void) viewWillAppear:(BOOL)animated {
    NSLog(@"haiku detailed view will appear");
    [super viewWillAppear:YES];
    //[self.collectionView reloadData];
}

-(void) viewDidAppear:(BOOL)animated {
    NSLog(@"haiku detailed view did appear");
    [super viewDidAppear:YES];
    [self.collectionView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"goToCanvas"]) {
        CanvasViewController* destVC = (CanvasViewController*)[segue destinationViewController];
        destVC.delegate = self; 
        destVC.haikuObjectId = haikuObjectId; 
        destVC.hidesBottomBarWhenPushed = YES;
    }
}

@end
