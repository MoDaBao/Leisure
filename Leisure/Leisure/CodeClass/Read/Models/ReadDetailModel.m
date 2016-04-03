//
//  ReadDetailModel.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadDetailModel.h"

@implementation ReadDetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.contentID = value;
    }
}

@end
