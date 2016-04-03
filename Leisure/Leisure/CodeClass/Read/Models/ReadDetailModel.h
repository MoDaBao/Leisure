//
//  ReadDetailModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface ReadDetailModel : BaseModel

@property (nonatomic, copy) NSString *coverimg; //图片地址
@property (nonatomic, copy) NSString *content; //内容简介
@property (nonatomic, copy) NSString *contentID; //蚊帐的id
@property (nonatomic, copy) NSString *name; //主图
@property (nonatomic, copy) NSString *title; //文章的标题

@end
