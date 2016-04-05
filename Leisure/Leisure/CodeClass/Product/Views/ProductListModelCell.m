//
//  ProductListModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ProductListModelCell.h"
#import "ProductListModel.h"

@implementation ProductListModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(ProductListModel *)model {
    self.titlelabel.text = model.title;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
}


@end
