//
//  PKAddToCartViewController.h
//  Angels
//
//  Created by Pallavi Keskar on 1/16/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol PKAddToCartViewControllerDelegate <NSObject>

@required

-(void)addItemToCart:(Product *)product andQuantity:(int)quantity;
-(void)didCancel;

@end

@interface PKAddToCartViewController : UIViewController

@property (weak, nonatomic) id<PKAddToCartViewControllerDelegate> delegate;

@property (weak, nonatomic) Product *product;


@end
