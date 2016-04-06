//
//  RadioDetailModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface RadioDetailModel : BaseModel

@property (nonatomic, copy) NSString *coverimg; // 图片
@property (nonatomic, assign) BOOL isnew;  // 判断是否最新
@property (nonatomic, copy) NSString *musicUrl;   // 音频地址
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *musicVisit; // 访问次数

//@property (nonatomic, strong) RadioPlayInfoModel *playInfo; // 播放页面信息

@end
