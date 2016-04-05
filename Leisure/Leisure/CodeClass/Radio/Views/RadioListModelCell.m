//
//  RadioListModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioListModelCell.h"
#import "RadioListModel.h"

@implementation RadioListModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(RadioListModel *)model {
    
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
//    self.countLabel.text = [model.count stringValue];
    [self.countBtn setTitle:model.count.stringValue forState:UIControlStateNormal];
    self.unameLabel.text = [NSString stringWithFormat:@"by:%@",model.userInfo.uname];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    
    
}


@end
