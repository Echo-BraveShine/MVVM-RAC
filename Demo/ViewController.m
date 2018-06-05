//
//  ViewController.m
//  Demo
//
//  Created by Hong Zhang on 2018/5/14.
//  Copyright © 2018年 Hong Zhang. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"
#import "Model.h"
#import "MJRefresh.h"
#import "ReactiveObjc.h"
#import "TableViewCell.h"
#import "UIView+Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
static NSString *cellID = @"Cell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)ViewModel *viewModel;

@property (nonatomic,strong)UITextField *textField;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.textField;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClick)];
    
    [self.view addSubview:self.tableView];
    
   
    
}

-(void)searchItemClick
{
    [self.textField resignFirstResponder];
    
    self.viewModel.param[@"q"] = self.textField.text;
    
    [self.viewModel.dataSource removeAllObjects];
    
    [self.tableView reloadData];
    
    [self loadData];
}

-(void)loadData
{
    @weakify(self)
    
    [[self.viewModel.command execute:@(1)] subscribeError:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
}

-(void)loadMoreData
{
    @weakify(self)

    [[self.viewModel.command execute:@(self.viewModel.page + 1)] subscribeError:^(NSError * _Nullable error) {
         @strongify(self)
        [self.tableView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    Model *model = self.viewModel.dataSource[indexPath.row];
    
    cell.model = model;
    @weakify(self)
    [[[cell.collectionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self)
        [self.tableView beginUpdates];
        [self.viewModel.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        [self.tableView reloadData];
    }];
    
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [tableView fd_heightForCellWithIdentifier:cellID configuration:^(TableViewCell * cell) {
//        Model *model = self.viewModel.dataSource[indexPath.row];
//        
//        cell.model = model;
//    }];
//}




-(void)dealloc
{
    NSLog(@"dealloc");
}
-(ViewModel *)viewModel
{
    if (!_viewModel) {
        
        _viewModel = [[ViewModel alloc]init];
    }
    return _viewModel;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
       
        _tableView.estimatedRowHeight = 200;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer.automaticallyHidden = YES;
    }
    return _tableView;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
        _textField.placeholder = @"请输入搜索内容";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}

@end
