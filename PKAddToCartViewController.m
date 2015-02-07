//
//  PKAddToCartViewController.m
//  Angels
//
//  Created by Pallavi Keskar on 1/16/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKAddToCartViewController.h"

@interface PKAddToCartViewController () <UITextFieldDelegate>



@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation PKAddToCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.quantity.delegate = self;
    self.productImage.image = self.product.productPicture;
    self.productName.text = self.product.productName;
    self.productPrice.text = [NSString stringWithFormat:@"$%f", self.product.price];
    self.quantity.text = [NSString stringWithFormat:@"%i", 1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBoulet actions
- (IBAction)addButtonPressed:(UIButton *)sender {
    
    [self.delegate addItemToCart:self.product andQuantity:[self.quantity.text intValue]];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.delegate didCancel];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.quantity resignFirstResponder];
    return YES;
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
