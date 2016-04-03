//
//  TopicCounterListModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCounterListModel : BaseModel

//评论数
@property (nonatomic, copy) NSString *comment;
//喜欢次数
@property (nonatomic, copy) NSString *like;
//被查看次数
@property (nonatomic, copy) NSString *view;

@end
