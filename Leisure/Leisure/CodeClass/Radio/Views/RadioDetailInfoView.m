//
//  RadioDetailInfoView.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioDetailInfoView.h"

@implementation RadioDetailInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(RadioInfoModel *)model {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.icon]];
    self.unameLabel.text = model.userInfo.uname;
    self.musicvisitnumLabel.text = model.musicvisitnum.stringValue;
    self.descLabel.text  = model.desc;
}

@end
