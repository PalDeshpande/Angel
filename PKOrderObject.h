//
//  PKOrderObject.h
//  Angels
//
//  Created by Pallavi Keskar on 1/16/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface PKOrderObject : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) Product *product;
@property (nonatomic) int quantity;

@end
