//
//  ViewController.m
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import "ViewController.h"
//轮播器
#import "LBImageCarouselView.h"
//cell
#import "LBImageCell.h"
#import "LBXibImageCell.h"
//model
#import "LBImageModel.h"

//在此选择cell使用哪种形式创建：Cording(纯代码)--1，Xib--2，Storyboard--3
#define CELLTYPE 1
//此demo的图片总数为9
#define ImageCount 9
@interface ViewController ()
@property (nonatomic,strong) NSArray *modelArray;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) LBImageCarouselView *imageCarouseView;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //只需3句代码即可创建完成一个图片轮播器！
    [self createCarouselView];
}

//只需3句代码即可创建完成一个图片轮播器！
- (void)createCarouselView{
    NSArray *cellClassNameArr = @[@" ",@"LBImageCell",@"LBXibImageCell",@"LBStoryboardCell"];
    
    //创建轮播器,在代码，xib，storyboard三种方式中选择一种
    LBImageCarouselView *imageCarouseView = [[LBImageCarouselView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300) AndWithModelArray:self.modelArray AndWithClassNameOfCell:cellClassNameArr[CELLTYPE] AndWithCellType:CELLTYPE AndWithTimeInterval:2.0f AndSetingCellModel:^(id cell, id model) {
        LBImageCell *imageCell = (LBImageCell *)cell;
        LBImageModel *imageModel = (LBImageModel *)model;
        imageCell.imageModel = imageModel;
    }];
    
    //将pageControl放到轮播器上，让轮播器滚动和pageControl同步
    imageCarouseView.pageControl = _pageControl;
    //也可以通过此block，给轮播器中的cell重新设置对应的model
    imageCarouseView.setCellModelBlock = ^(id cell,id model){
        [self settingCellWithCell:cell Model:model AndCellType:CELLTYPE];
    };
    
    //将轮播器添加到父控件上
    [self.view addSubview:imageCarouseView];
    [self.view sendSubviewToBack:imageCarouseView];
    self.imageCarouseView = imageCarouseView;
}

- (void)settingCellWithCell:(id)cell Model:(id)model AndCellType:(LBCellType)cellType{
    switch (cellType) {
        case LBCording:{
            LBImageCell *imageCell = (LBImageCell *)cell;
            LBImageModel *imageModel = (LBImageModel *)model;
            imageCell.imageModel = imageModel;
        }
            break;
            
        case LBXib:{
            LBXibImageCell *imageCell = (LBXibImageCell *)cell;
            LBImageModel *imageModel = (LBImageModel *)model;
            imageCell.imageModel = imageModel;
        }
            break;
        case LBStoryboard:{
            
        }
            break;
        default:
            break;
    }
}

//创建pageControl
- (void)createUI{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(0, 400 - 40, self.view.bounds.size.width, 40);
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
  
    [self.view addSubview:_pageControl];
}

#pragma mark- 懒加载数据
- (NSArray *)modelArray{
    if (_modelArray == nil) {
        NSMutableArray *tmpArrM = [NSMutableArray arrayWithCapacity:ImageCount];
        for (NSInteger i = 0; i < ImageCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%zd.jpg",i];
            LBImageModel *model = [LBImageModel modelWithImageName:imageName];
            [tmpArrM addObject:model];
        }
        _modelArray = tmpArrM;
    }
    return _modelArray;
}




@end
