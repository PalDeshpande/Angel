//
//  PKStoreViewController.h
//  Angels
//
//  Created by Pallavi Keskar on 1/15/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface PKStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *products;

@end
