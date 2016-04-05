//
//  ProductListModelCell.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProductListModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;


@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;


@end
