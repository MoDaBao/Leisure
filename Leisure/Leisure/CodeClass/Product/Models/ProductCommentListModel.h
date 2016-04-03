//
//  ProductCommentListModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"
#import "ProductUserInfoModel.h"

@interface ProductCommentListModel : BaseModel

//评论时间
@property (nonatomic, copy) NSString *addtime_f;
//评论内容
@property (nonatomic, copy) NSString *content;
//评论的id
@property (nonatomic, copy) NSString *contentid;
//发表评论的用户信息

@property (nonatomic, strong) ProductUserInfoModel *userInfo;



@end
