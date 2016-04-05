//
//  ReadDetailModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadDetailModelCell.h"
#import "ReadDetailModel.h"

@implementation ReadDetailModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setDataWithModel:(ReadDetailModel *)model {
    
    self.titleLabel.text = model.title;
    
    self.contentLabel.text = model.content;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
 
    
}

@end
