//
//  TopicListModelCell.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TopicListModelCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIButton *commentCountBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
