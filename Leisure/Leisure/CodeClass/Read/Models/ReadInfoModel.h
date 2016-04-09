//
//  ReadInfoModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"
#import "ReadInfoCounterModel.h"
#import "ReadShareinfoModel.h"

@interface ReadInfoModel : BaseModel

@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, copy) NSMutableString *html;

@property (nonatomic, strong) ReadInfoCounterModel *counter;
@property (nonatomic, strong) ReadShareInfoModel *shareInfo;

@end
