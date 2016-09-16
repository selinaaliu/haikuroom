//
//  WallViewController.m
//  HaikuRoom
//
//  Created by Selina Liu on 4/21/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "HaikuWallViewController.h"
#import "HaikuWallCell.h"
#import "HaikuDetailsViewController.h"
#import <Parse/Parse.h>

@interface HaikuWallViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* tableDataSource;


@end

@implementation HaikuWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableDataSource = [[NSMutableArray alloc] init];
    [self fetchHaikusFromDatabase];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataSource count]; 
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HaikuWallCell* cell = (HaikuWallCell*) [tableView dequeueReusableCellWithIdentifier:@"WallCell" forIndexPath:indexPath];
    //if cell is nil, initiate a new haikuwallcell  with
    //reuse identifier
    
    //update the cell based on indexpath
    [self updateHaikuWallCell:cell atIndexPath:indexPath]; 
    return cell;
}

- (void) updateHaikuWallCell:(HaikuWallCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    //cell.imageView.image = [UIImage imageNamed:@"japfan"];
    [cell loadHaikuFromPFObject:[self.tableDataSource objectAtIndex:indexPath.row]];
}


- (void) fetchHaikusFromDatabase {
    PFQuery* query = [PFQuery queryWithClassName:@"Haiku"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error) {
        if (!error) {
            if ([self.tableDataSource count] > 0) {
                [self.tableDataSource removeAllObjects];
            }
            for (PFObject* object in objects) {
                [self.tableDataSource addObject:object];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        } else {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HaikuWallCell* cell = (HaikuWallCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"seeHaikuDetails" sender:cell];

}

- (IBAction)logOutButtonAction:(id)sender {
    //before logging user out, double check with user again with a UIAlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging Out"
                                            message:@"Are you sure you want to log out?"
                                            delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Log out", nil];
    [alert show];

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
    } else {
        [PFUser logOutInBackground];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES]; 
    [self fetchHaikusFromDatabase];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchHaikusFromDatabase];
    [refreshControl endRefreshing];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"seeHaikuDetails"]) {
        HaikuWallCell* cell = (HaikuWallCell*) sender;
        HaikuDetailsViewController* destVC = (HaikuDetailsViewController*) [segue destinationViewController];
        destVC.pfObject = cell.pfObject; 
        
        
    }
}


@end
