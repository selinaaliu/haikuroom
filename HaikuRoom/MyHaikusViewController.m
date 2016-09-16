//
//  MyHaikusViewController.m
//  HaikuRoom
//
//  Created by Selina Liu on 4/22/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "MyHaikusViewController.h"
#import <Parse/Parse.h>
#import "MyHaikusCell.h"
#import "AddHaikuViewController.h"
@interface MyHaikusViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* tableDataSource;
@property BOOL editing;
@end

@implementation MyHaikusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editing = NO;
    self.tableDataSource = [[NSMutableArray alloc] init];
    [self fetchHaikusFromDatabase];
    // Do any additional setup after loading the view.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Display Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataSource count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyHaikusCell* cell = (MyHaikusCell*)[tableView dequeueReusableCellWithIdentifier:@"myHaikuCell" forIndexPath:indexPath];
    [self updateMyHaikusCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) updateMyHaikusCell: (MyHaikusCell*) cell atIndexPath: (NSIndexPath*) indexPath {
    [cell loadHaikuFromPFObject:[self.tableDataSource objectAtIndex:indexPath.row]];
}

- (void) fetchHaikusFromDatabase {
    PFQuery* query = [PFQuery queryWithClassName:@"Haiku"];
    [query orderByDescending:@"createdAt"];
    PFUser* currentUser = [PFUser currentUser];
    [query whereKey:@"username" equalTo:currentUser.username];
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

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchHaikusFromDatabase];
    [refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self fetchHaikusFromDatabase];
}

#pragma mark - Edit Table View

- (IBAction)editHaikusAction:(id)sender {
    self.editing = !self.editing;
    [self.tableView setEditing:(self.editing) animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyHaikusCell* cell = (MyHaikusCell*) [tableView cellForRowAtIndexPath:indexPath];
        PFObject* pf = cell.pfObject;
        [pf deleteInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
            if (!error) {
                [self.tableDataSource removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                self.editing = NO;
                [self.tableView setEditing:self.editing animated:YES];
            } else {
                NSLog(@"error in deleting haiku from database.");
            }
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addNewHaikuSegue"]) {
        AddHaikuViewController* destvc = (AddHaikuViewController*) [segue destinationViewController];
        destvc.delegate = self;
    }
}


@end
