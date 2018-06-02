//
//  TableViewCell.h
//  Demo
//
//  Created by Hong Zhang on 2018/6/1.
//  Copyright © 2018年 Hong Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "ReactiveObjc.h"

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic,strong)Model *model;

@property (nonatomic,strong)RACSubject *subject;



@end
