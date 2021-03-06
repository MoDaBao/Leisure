//
//  ProductUserInfoModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface ProductUserInfoModel : BaseModel

//头像地址
@property (nonatomic, copy) NSString *icon;
//用户名
@property (nonatomic, copy) NSString *uname;
//用户id
@property (nonatomic, copy) NSString *uid;

@end
