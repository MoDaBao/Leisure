//
//  RadioUserInfoModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface RadioUserInfoModel : BaseModel

//头像
@property (nonatomic, copy) NSString *icon;
//用户id
@property (nonatomic, copy) NSString *uid;
//用户名
@property (nonatomic, copy) NSString *uname;

@end
