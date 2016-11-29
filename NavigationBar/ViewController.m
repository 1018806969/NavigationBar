//
//  ViewController.m
//  NavigationBar
//
//  Created by txx on 16/11/29.
//  Copyright © 2016年 txx. All rights reserved.
//
//导航栏是公有的，所以你可能需要在ViewWillDisappear中，再把导航栏设置为你需要的样子。


#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView *backgroundImage;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController
//注意释放tableView的Delegate，不然你进进出出时候会发现哪里好像不太对
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate = self ;
}
-(void)viewWillDisAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tableView.delegate = nil ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"first page";
    
    //1.设置导航栏透明
    //这个backgroundImage就是导航栏上呈现效果的子试图，因此设置为无图片就会可以看到透明，而设置backgroundColor却不行。
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //2.设置导航栏下面的线透明
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //3.获取呈现效果的backgroundImage，然后设置他的透明度，实现渐变
    //方法：通过for...in遍历NavigationBar的子试图，然后获取，其实它是subViews的第一个子试图，
    //     于是定义一个属性强引用他
    _backgroundImage = self.navigationController.navigationBar.subviews.firstObject;
    
    [self.view addSubview:self.tableView];
    
}
//4.在代理方法中修改属性的值
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    _backgroundImage.backgroundColor = [UIColor redColor];
    _backgroundImage.alpha = alpha;
    
    //可以动态的修改状态栏和标题的颜色和导航栏更匹配
    //    if (alpha > 1) {
    //        //标题颜色
    //        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    //        //导航栏子控件颜色
    //        self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    //
    //    }else
    //    {
    //        //标题颜色
    //        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    //        //导航栏子控件颜色
    //        self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    //    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser_id = @"reuser";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser_id];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuser_id];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld---%ld",(long)indexPath.row,(long)indexPath.section];
    return cell ;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
    }
    return _tableView ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
