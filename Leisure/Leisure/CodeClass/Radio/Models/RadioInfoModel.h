//
//  RadioInfoModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioInfoModel : BaseModel

@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSNumber *musicvisitnum;
@property (nonatomic, copy) NSString *radioid;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) RadioUserInfoModel *userInfo;

@end
