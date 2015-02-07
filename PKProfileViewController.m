//
//  PKProfileViewController.m
//  Angels
//
//  Created by Pallavi Keskar on 1/15/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKProfileViewController.h"
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>

@interface PKProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *petNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *typeOfPetTextField;
@end

@implementation PKProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.petNameTextField.text = [[PFUser currentUser] objectForKey:@"petName"];
    self.typeOfPetTextField.text = [[PFUser currentUser] objectForKey:@"petType"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(UIButton *)sender
{
    NSLog(@"PFuser id %@", [PFUser currentUser]);
    [[PFUser currentUser] setObject:self.petNameTextField.text forKey:@"petName"];
    [[PFUser currentUser] setObject:self.typeOfPetTextField.text forKey:@"petType"];
    [[PFUser currentUser] saveInBackground];
    [self performSegueWithIdentifier:@"profileToStore" sender:nil];
}

#pragma mark - helper methods



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
