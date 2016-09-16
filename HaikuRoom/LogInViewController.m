//
//  LogInViewController.m
//  HaikuRoom
//
//  Created by Selina Liu on 4/21/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonAction:(id)sender {
    //authenticate user credentials
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                // Do stuff after successful login: segue to Haiku Wall
                [self performSegueWithIdentifier:@"logInSegue" sender:self];
                self.usernameField.text = @"";
                self.passwordField.text = @"";
            } else {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertController* alert = [UIAlertController
                                            alertControllerWithTitle:@"Log In Failure"
                                            message:errorString
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                            handler:nil];
                [alert addAction:alertAction]; 
                [self presentViewController:alert animated:YES completion:nil];
                // The login failed. Check error to see why.
            }
        }];
}
- (IBAction)signUpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:self];
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
