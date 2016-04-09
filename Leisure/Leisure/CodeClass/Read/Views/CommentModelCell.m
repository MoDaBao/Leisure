//
//  CommentModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CommentModelCell.h"
#import "CommentModel.h"

@implementation CommentModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(CommentModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.icon]];
    self.unameLabel.text = model.userInfo.uname;
    self.addtimeLabel.text = model.addtime_f;
    self.contentLabel.text = model.content;
}


@end
