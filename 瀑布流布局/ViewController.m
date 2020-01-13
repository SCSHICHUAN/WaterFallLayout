//
//  ViewController.m
//  瀑布流布局
//
//  Created by 石川 on 2020/1/9.
//  Copyright © 2020 石川. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "SCFlowLayout.h"
#import "MJRefresh.h"
#import <SDWebImage/SDWebImage.h>

@interface ViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
SCFlowLayoutDelegate
>
@property(nonatomic,strong)UICollectionView *colloectionView;
@end

@implementation ViewController
-(UICollectionView *)colloectionView
{
    if (!_colloectionView) {
        SCFlowLayout *flowLayout = [[SCFlowLayout alloc] init];
        flowLayout.delegate = self;
        _colloectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _colloectionView.delegate =self;
        _colloectionView.dataSource = self;
        [_colloectionView registerClass:[CollectionViewCell class]  forCellWithReuseIdentifier:@"cell"];
        _colloectionView.backgroundColor = UIColor.whiteColor;
    }
    return _colloectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.colloectionView];
    
    
   self.colloectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       //Call this Block When enter the refresh status automatically
    }];
   self.colloectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    [self.colloectionView.mj_header beginRefreshing];
 
}
-(void)loadNewData
{
    [self.colloectionView.mj_header endRefreshing];
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    item.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578897122995&di=3665c1294f16d96c0d3968a0030936ce&imgtype=0&src=http%3A%2F%2Fpics3.baidu.com%2Ffeed%2F0b7b02087bf40ad15226e0a3a560e1daa8ecce06.jpeg%3Ftoken%3D79d882d1fd55d2b9abe7310a7b9d198e%26s%3DA301F30706EBB2F8D8F9D98703003083";

    return item;
}


#pragma SCFlowLayoutDelegate-根据图片输出每一个高度
- (CGFloat)waterFallLayout:(SCFlowLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth
{
    return 200;
}


@end
