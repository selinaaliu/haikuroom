//
//  AddHaikuViewController.m
//  HaikuRoom
//
//  Created by Selina Liu on 4/21/15.
//  Copyright (c) 2015 Selina Liu. All rights reserved.
//

#import "AddHaikuViewController.h"
#import <Parse/Parse.h>

@interface AddHaikuViewController () <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *failureMessage;
@property (strong, nonatomic) NSString* placeholderText;
@end

@implementation AddHaikuViewController

NSString* invalidHaikuMsg1 = @"Your haiku doesn't conform to the 3-line format. Please revise your work.";
NSString* invalidHaikuMsg2 = @"You haikus is too short. Please revise your work.";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* str0 = @"I went in the woods";
    NSString* str1 = @"to meditate -";
    NSString* str2 = @"It was too cold";
    self.placeholderText = [NSString stringWithFormat:@"%@ \n%@\n%@", str0, str1, str2];
    // Do any additional setup after loading the view.
    self.textView.delegate = self;
    self.textView.text = self.placeholderText;
    self.textView.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postButtonAction:(id)sender {
    NSString* userHaiku = self.textView.text;
    NSArray* haikuLines = [userHaiku componentsSeparatedByString:@"\n"];
    
    BOOL hasEmptyLine = NO;
    BOOL lineTooShort = NO;
    for (int i = 0; i < haikuLines.count; i++) {
        if ([[haikuLines objectAtIndex:i] length] == 0) {
            hasEmptyLine = YES;
        } else if ([[haikuLines objectAtIndex:i] length] < 3) {
            lineTooShort = YES;
        }
    }
    if (haikuLines.count!=3 || hasEmptyLine) {
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Invalid format" message:invalidHaikuMsg1
                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction =
        [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (lineTooShort) {
        UIAlertController* alert =
        [UIAlertController alertControllerWithTitle:@"Invalid format" message:invalidHaikuMsg2
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction =
        [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else { //if poem is valid, i.e. has 3 non-empty lines
        PFObject* newHaiku = [PFObject objectWithClassName:@"Haiku"];
        [newHaiku setObject:[PFUser currentUser].username forKey:@"username"];
        [newHaiku setObject:[haikuLines objectAtIndex:0] forKey:@"line0"];
        [newHaiku setObject:[haikuLines objectAtIndex:1] forKey:@"line1"];
        [newHaiku setObject:[haikuLines objectAtIndex:2] forKey:@"line2"];
        [newHaiku saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                NSLog(@"Haiku Uploaded!");
                [self.delegate viewWillAppear:YES];
            } else{
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"Error: %@", errorString);
            }
        }];
        [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

//remove the placeholder text once the user puts cursor in the text box
- (void) textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.placeholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

//if text box is empty, shows the placeholder text.
- (void) textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholderText;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
