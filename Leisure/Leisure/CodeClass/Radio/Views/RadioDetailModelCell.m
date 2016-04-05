//
//  RadioDetailModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioDetailModelCell.h"

@implementation RadioDetailModelCell

- (void)setDataWithModel:(RadioDetailModel *)model {
    self.titleLabel.text = model.title;
    self.musicVisit.text = model.musicVisit;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
}


@end
