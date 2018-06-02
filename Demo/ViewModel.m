//
//  ViewModel.m
//  Demo
//
//  Created by Hong Zhang on 2018/5/30.
//  Copyright © 2018年 Hong Zhang. All rights reserved.
//

#import "ViewModel.h"

//#define url @"https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&start=0&count=100&client=&udid="

#define url @"https://api.douban.com/v2/book/search"
@implementation ViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        [self bind];
    }
    return self;
}

-(void)bind
{
    @weakify(self)
    self.command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(NSNumber * input) {
        NSLog(@"page-->%@",input);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            self.param[@"start"] = input;
            self.param[@"count"] = @(5);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:url parameters:self.param progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (input.integerValue == 1) {
                    [self.dataSource removeAllObjects];
                    self.page = 1;
                }else{
                    self.page ++;
                }
                NSLog(@"%@",responseObject);
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                [manager.session finishTasksAndInvalidate];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
                [manager.session finishTasksAndInvalidate];
                NSLog(@"%@",error);
            }];
            return nil;
        }];
        return [signal map:^id _Nullable(id  _Nullable value) {
            @strongify(self)
            for (NSDictionary *dict in value[@"books"]) {
                Model *model = [[Model alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSource  addObject:model];
            }
            return self.dataSource;
        }];
    }];
}


-(NSMutableArray<Model *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)param
{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

@end
