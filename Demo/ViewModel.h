//
//  ViewModel.h
//  Demo
//
//  Created by Hong Zhang on 2018/5/30.
//  Copyright © 2018年 Hong Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "AFNetworking.h"
#import "ReactiveObjC.h"

typedef void(^CompleteHandle)(void);

@interface ViewModel : NSObject 

@property (nonatomic,strong)NSMutableArray<Model *> *dataSource;

@property (nonatomic,strong)RACCommand *command;

@property (nonatomic,strong)NSMutableDictionary *param;


@property (nonatomic,assign)NSInteger page;

@end
