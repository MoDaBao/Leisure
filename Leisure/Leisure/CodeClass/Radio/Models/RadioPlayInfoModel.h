//
//  RadioPlayInfoModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"
#import "RadioShareInfoModel.h"

@interface RadioPlayInfoModel : BaseModel

@property (nonatomic, copy) NSString *imgUrl;  // 图片
@property (nonatomic, copy) NSString *musicUrl; // 音频地址
@property (nonatomic, copy) NSString *sharepic;
@property (nonatomic, copy) NSString *sharetext;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *ting_contentid;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *webview_url;  //内容地址

@property (nonatomic, strong) RadioUserInfoModel *authorInfo; // 作者信息
@property (nonatomic, strong) RadioUserInfoModel *userInfo;  // 用户信息
@property (nonatomic, strong) RadioShareInfoModel *shareInfo;

@end
