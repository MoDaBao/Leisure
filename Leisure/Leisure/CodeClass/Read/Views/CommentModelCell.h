//
//  CommentModelCell.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CommentModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end
