//
//  TableViewCell.m
//  Demo
//
//  Created by Hong Zhang on 2018/6/1.
//  Copyright © 2018年 Hong Zhang. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(Model *)model
{
    _model = model;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
    self.title.text = model.origin_title;
    
    self.subTitle.text = model.subtitle;
    
    self.desc.text = model.summary;
    
}

@end
