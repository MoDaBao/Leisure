//
//  TopicListModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TopicListModelCell.h"
#import "TopicListModel.h"

@interface TopicListModelCell ()

@property (nonatomic, strong) TopicListModel *topicListModel;

@end

@implementation TopicListModelCell
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setDataWithModel:(TopicListModel *)model {
    if (model.ishot) {
        self.topicListModel = model;
        NSString *s = [NSString stringWithFormat:@"精 %@", model.title];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, 1)];
        self.titleLabel.attributedText = str;
    } else {
        self.titleLabel.text = model.title;
    }
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    [self.commentCountBtn setTitle:[NSString stringWithFormat:@"  %@",model.counter.comment.stringValue] forState:UIControlStateNormal];
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.addtime_f;
}

@end
