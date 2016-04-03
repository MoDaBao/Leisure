//
//  TopicUserInfoModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface TopicUserInfoModel : BaseModel
//用户图标
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uname;

@end
