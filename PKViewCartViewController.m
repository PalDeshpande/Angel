//
//  PKViewCartViewController.m
//  Angels
//
//  Created by Pallavi Keskar on 1/18/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKViewCartViewController.h"
#import "Product.h"
#import "PKCartCell.h"
#import "PKCheckoutItemCell.h"
#import "PKSubtotalCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PKStoreViewController.h"
#import "PKStripeViewController.h"
@interface PKViewCartViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIView *continueButtonView;
@property (strong, nonatomic)PKStoreViewController *order;
@property (nonatomic) float amountDue;
@end

@implementation PKViewCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self calculateAmountDue];
    //self.totalField.text = [ NSString stringWithFormat:@"$ %f", self.amountDue];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBOutlets

- (IBAction)proceedToCheckOutButtonPressed:(UIButton *)sender {
    
}

- (IBAction)editCartButtonPressed:(UIButton *)sender {
}

#pragma mark - tableviewdataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"    Products " : @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"coUNT %lu", (unsigned long)[self.orders count]);
    return (section == 0) ? [self.orders count] : 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0){
        PKCheckoutItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        NSDictionary *items = [[NSDictionary alloc] init];
        items =  self.orders[indexPath.row];
        
        Product *product = items[@"product"];
        NSString *productName = product.productName;
        
        cell.productNameLabel.text = productName;
        cell.productQuantityLabel.text = [items[@"quantity"] stringValue];
        cell.priceLabel.text = [items[@"price"] stringValue];
        //cell.productPicture.image = product.productPicture;
        return cell;
    }else{
        
        PKSubtotalCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
        cell.totalLabel.text = [ NSString stringWithFormat:@"$ %f", self.amountDue];
        return cell;
    }
    
    return nil;
    
}

#pragma mark - tableviewDelegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"before delete, %@", self.orders);
        [self.orders removeObjectAtIndex:indexPath.row];
        NSLog(@"after delete, %@", self.orders);
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self calculateAmountDue];
        [tableView reloadData];
    }else
    {
        NSLog(@"Unhandled editing style! %ld", editingStyle);
    }
}

#pragma mark - helper methods

-(void)calculateAmountDue
{
    self.amountDue = 0;
    for (NSDictionary *item in self.orders) {
        Product *product = item[@"product"];
        self.amountDue = self.amountDue + product.price;
    }
    NSLog(@"amount due %f", self.amountDue);
}

-(void)clearCart
{
    for (Product *product in self.orders) {
        [self.orders removeObject:product];
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PKStripeViewController class]]) {
        PKStripeViewController *stripeVC = segue.destinationViewController;
        stripeVC.delegate = self;
    }
}




@end
