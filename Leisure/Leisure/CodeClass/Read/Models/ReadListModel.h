//
//  ReadListModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface ReadListModel : BaseModel

@property (nonatomic, copy) NSString *coverimg; // 图像
@property (nonatomic, copy) NSString *enname; // 副名称
@property (nonatomic, copy) NSString *name; // 名称
@property (nonatomic, copy) NSString *type; // 主题

@end
