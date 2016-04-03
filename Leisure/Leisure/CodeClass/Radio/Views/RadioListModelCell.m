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
    self.countLabel.text = [model.count stringValue];
    self.unameLabel.text = [NSString stringWithFormat:@"by:%@",model.userInfo.uname];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:model.coverimg];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               self.coverImageView.image = [UIImage imageWithData:data];
           });
        }];
        
        [task resume];
        
        
    });
    
    
}


@end
