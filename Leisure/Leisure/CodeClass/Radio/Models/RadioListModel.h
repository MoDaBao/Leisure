//
//  RadioListModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioListModel : BaseModel

//收听次数
@property (nonatomic, strong) NSNumber *count;
//图片地址
@property (nonatomic, copy) NSString *coverimg;
//内容简介
@property (nonatomic, copy) NSString *desc;
//标记是否是最新
@property (nonatomic, assign) BOOL isNew;
//电台的id
@property (nonatomic, copy) NSString *radioid;
//标题
@property (nonatomic, copy) NSString *title;
//用户信息
@property (nonatomic, strong) RadioUserInfoModel *userInfo;

@end
