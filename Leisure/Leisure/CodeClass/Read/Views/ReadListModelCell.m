//
//  ReadListModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadListModelCell.h"
#import "ReadListModel.h"

@implementation ReadListModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setDataWithModel:(ReadListModel *)model {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",model.name, model.enname];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:model.coverimg];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.coverImageView.image = [UIImage imageWithData:data];
            });
        }];
        
        [task resume];
        
    });
    
    
    
}


@end
