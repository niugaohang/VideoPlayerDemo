//
//  ViewController.m
//  VideoPlayerDemo
//
//  Created by 牛高航 on 15/8/27.
//  Copyright (c) 2015年 牛高航. All rights reserved.
//


#import "ViewController.h"
#import "Header.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray      *_listArr;
    
    int                 _page;
}

@property(nonatomic, strong) UITableView *tableView;

@end



@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [Tool initWithNavViewWith:@"视频列表" selfView:self];

    [self initTableView];

    _listArr=@[@"111",@"222",@"333",@"111",@"222",@"333",@"111",@"222",@"333",@"111",@"222",@"333"];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    self.tableView.hidden = YES;
    
    [self setupTableview];
}
-(void)setupTableview{
    //添加下拉的动画图片
    //设置下拉刷新回调
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; ++i) {
        UIImage *image = [UIImage imageNamed:@"icon_listheader_animation_1"];
        [idleImages addObject:image];
    }
    [self.tableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    UIImage *image1 = [UIImage imageNamed:@"icon_listheader_animation_1"];
    [refreshingImages addObject:image1];
    UIImage *image2 = [UIImage imageNamed:@"icon_listheader_animation_2"];
    [refreshingImages addObject:image2];
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
    
    //设置正在刷新是的动画图片
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    
    //马上进入刷新状态
    [self.tableView.gifHeader beginRefreshing];
}

-(void)loadNewData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getRecommendData];
    });
}
//请求推荐课程数据
-(void)getRecommendData
{
    
//    [_listArr removeAllObjects];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSString *urlStr= @"";
        
        AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        manager.operationQueue.maxConcurrentOperationCount = 1;

        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [_tableView reloadData];
                    [self.tableView.header endRefreshing];
                });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            fail(operation,error);
        }];
        [self.tableView.header endRefreshing];
    });
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listArr.count != 0)
    {
        return _listArr.count;
    }
    return 0;
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (_listArr.count != 0)
    {
        
        cell.textLabel.text = @"See You Again";

    }
    return cell;

}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_listArr.count != 0)
    {
        PlayerViewController *playVC = [[PlayerViewController alloc]init];
        
        [self.navigationController pushViewController:playVC animated:YES];
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
