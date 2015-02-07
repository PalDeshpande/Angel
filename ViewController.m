//
//  ViewController.m
//  Angels
//
//  Created by Pallavi Keskar on 1/15/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>

#import "PKProfileViewController.h"

@interface ViewController ()

@property NSMutableData *imageData;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated
{
    self.spinner.hidden = YES;
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User already logged in");
        
        [self updateUserInformation];
    }
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    NSArray *permissionArray = @[ @"user_about_me", @"user_location"];
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error) {
        [self.spinner stopAnimating];
        self.spinner.hidden = NO;
        
            if (!user) {
                
                NSString *errorMessage = nil;
                if (!error) {
                    NSLog(@"Uh oh. User cancelled the Facebook login");
                    errorMessage = @"Uh oh. User cancelled the Facebook login";
                }else
                {
                    NSLog(@"Error ocurred: %@", error);
                    errorMessage = [error localizedDescription];
                }
                
                UIAlertView *alert  = [[UIAlertView alloc]
                                       initWithTitle:@"login error"
                                       message:errorMessage
                                       delegate:nil
                                       cancelButtonTitle:@"Dismiss"
                                       otherButtonTitles:nil];
                [alert show];
            }else{
                if (user.isNew) {
                    NSLog(@"User with facebook signed up and logged in");
                }else
                {
                    NSLog(@"User with facebook logged in");
                }
                
                
                [self updateUserInformation];
                
            }

            }];
}

#pragma mark -helper methods

-(void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSDictionary *resultDictionary = (NSDictionary *)result;
                //NSString *facebookID = resultDictionary[@"id"];
                //NSURL *picturURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
                if (resultDictionary[@"name"]) {
                    userProfile[@"name"] = resultDictionary[@"name"];
                }
                
                if (resultDictionary[@"first_name"]) {
                    userProfile[@"firstName"] = resultDictionary[@"first_name"];
                }
                
                if (resultDictionary[@"location"][@"name"]) {
                    userProfile[@"location"] = resultDictionary[@"location"][@"name"];
                }
                
                
                
                [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                [[PFUser currentUser] save];
                BOOL isRegistseredUser = [self isItARegisteredUser];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (isRegistseredUser) {
                        [self performSegueWithIdentifier:@"loginToFeed" sender:self];
                    }else
                    {
                        [self performSegueWithIdentifier:@"loginToProfile" sender:self];
                    }
                });
            });
            
        
            }
    }];
}


-(BOOL )isItARegisteredUser
{
    //__block BOOL result = nil;
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId]];
    //[query whereKey:@"petType" notEqualTo:@"undefined"];
    
    PFObject *object =[query getObjectWithId:[[PFUser currentUser] objectId]];
    
    if ([object objectForKey:@"petType"]) {
        return YES;
    }else{
        return NO;
    }
    
}

@end
