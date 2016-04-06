//
//  TopicListModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TopicListModelCell.h"
#import "TopicListModel.h"

@implementation TopicListModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setDataWithModel:(TopicListModel *)model {
    
    self.titleLabel.text = model.title;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    [self.commentCountBtn setTitle:[NSString stringWithFormat:@"  %@",model.counter.comment.stringValue] forState:UIControlStateNormal];
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.addtime_f;
}

@end
