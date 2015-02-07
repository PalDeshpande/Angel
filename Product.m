//
//  Product.m
//  Angels
//
//  Created by Pallavi Keskar on 1/16/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "Product.h"

@implementation Product

-(id)init
{
    self = [self initWithData:nil andImage:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data andImage:(UIImage *)image
{
    self = [super init];
    self.productName = data[@"productName"];
    self.productType = data[@"productType"];
    self.petType = data[@"petType"];
    self.price = [data[@"price"]floatValue];
    
    self.productPicture = image;
    return self;
}

@end
