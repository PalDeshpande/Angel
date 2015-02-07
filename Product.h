//
//  Product.h
//  Angels
//
//  Created by Pallavi Keskar on 1/16/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PRODUCT_NAME = @"productName"
#define PRODUCT_TYPE = @"productType"
#define PRICE = @"price"
#define PICTURE = @"productPicture"

@interface Product : NSObject

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSString *petType;
@property (nonatomic) float price;

@property (strong, nonatomic) UIImage *productPicture;

-(id)initWithData:(NSDictionary *)data andImage:(UIImage *)image;


@end
