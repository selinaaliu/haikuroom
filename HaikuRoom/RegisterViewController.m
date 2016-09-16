//
//  RegisterViewController.m
//  HaikuRoom
//
//  Created by Selina Liu on 4/21/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonAction:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"registerLogInSegue" sender:self];

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
        }
    }];
}

/* to be included in button action method

*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
