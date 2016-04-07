//
//  RadioPlayInfoModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioPlayInfoModelCell.h"
#import "RadioPlayInfoModel.h"

@implementation RadioPlayInfoModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(RadioPlayInfoModel *)model {
    self.titleLabel.text = model.title;
    self.authNameLabel.text = [NSString stringWithFormat:@"by:%@",model.authorInfo.uname];
    if (self.selected) {
        self.markView.backgroundColor = [UIColor orangeColor];
    } else {
        self.markView.backgroundColor = [UIColor clearColor];
    }
}

@end
