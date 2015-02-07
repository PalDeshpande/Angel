//
//  PKStoreViewController.m
//  Angels
//
//  Created by Pallavi Keskar on 1/15/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKStoreViewController.h"
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>
#import "Product.h"
#import "PKAddToCartViewController.h"
#import "PKViewCartViewController.h"
#import "PKStoreInventoryCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PKStoreViewController () <PKAddToCartViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cartBarButtonItem;
@property (strong, nonatomic) IBOutlet UILabel *numberOfItems;

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *productPictures;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *orders;


@end


@implementation PKStoreViewController


#pragma mark -lazy instanitiation

-(NSMutableArray *)searchResults
{
    if(!_searchResults)
    {
        _searchResults = [[NSMutableArray alloc] init];
    }
    
    return _searchResults;
}

-(NSMutableArray *)orders
{
    if (!_orders) {
        _orders = [[NSMutableArray alloc] init];
    }
    return _orders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.layer.cornerRadius = 5;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
    NSString *petType = [[PFUser currentUser] objectForKey:@"petType"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ProductCatlog"];
    [query whereKey:@"petType" equalTo:petType];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                for (NSDictionary *myProduct in objects) {
                    PFFile *imageFile = myProduct[@"productPicture"];
                    NSData *imageData = [imageFile getData];
                    Product *product = [[Product alloc] initWithData:myProduct andImage:[UIImage imageWithData:imageData]];
                    NSLog(@"object %@", product);
                    [self.searchResults addObject:product];
                    NSLog(@"search results %@", self.searchResults);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
            
        
            
        }
    }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PKAddToCartViewController class]]) {
        PKAddToCartViewController *orderVC = segue.destinationViewController;
        orderVC.delegate = self;
        NSIndexPath *index = sender;
        orderVC.product = self.searchResults[index.row];
        
    }
    
    if ([segue.destinationViewController isKindOfClass:[PKViewCartViewController class]]) {
        PKViewCartViewController *viewCartVC = segue.destinationViewController;
        viewCartVC.orders = self.orders;
        
    }
    
    
}

#pragma mark - tableviewdataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"coUNT %lu", (unsigned long)[self.searchResults count]);
    return [self.searchResults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKStoreInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Product *product = self.searchResults[indexPath.row];
    cell.productName.text = product.productName;
    cell.price.text = [NSString stringWithFormat:@"$ %f",product.price];
    cell.productPicture.image = product.productPicture;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.textLabel.text = product.productName;
    //PFFile *imageFile = product[@"productPicture"];
    //NSData *imageData = [imageFile getData];
    //cell.imageView.image = product.productPicture;
    return cell;
    
}

#pragma mark - tableviewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"storeToOrder" sender:indexPath];
    
}

#pragma mark - PKAddToCartViewControllerDelegate

-(void)addItemToCart:(Product *)product andQuantity:(int)quantity
{
    
    int itemCount = 0;
    if ([self.orders count] == 0) {
        [self prepareOrederList:product andQuantity:(int)quantity];
    }else
    {
        NSString *newProduct = product.productName;
        for (int index =0; index < [self.orders count]; index++) {
            NSMutableDictionary *productList = self.orders[index];
            Product *product_temp = productList[@"product"];
            if ([product_temp.productName isEqualToString:newProduct]) {
                itemCount = [productList[@"quantity"] intValue] ;
                [self.orders removeObjectIdenticalTo:productList];
                itemCount = itemCount + (int)quantity;
                [self prepareOrederList:product andQuantity:(int)quantity];
                break;
            }else
            {
                [self prepareOrederList:product andQuantity:(int)quantity];
            }
        }
    }
   
    NSLog(@"oders %@", self.orders);
        self.numberOfItems.text = [NSString stringWithFormat:@"%i", itemCount];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareOrederList:(Product *)product andQuantity:(int)quantity
{
    NSMutableDictionary *order = [[NSMutableDictionary alloc] init];
    [order setObject:[NSNumber numberWithInt:quantity] forKey:@"quantity"];
    [order setObject:product forKey:@"product"];
    [self.orders addObject:order];
}

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
