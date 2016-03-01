//
//  LBImageCarouselView.h
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
cell的尺寸是根据轮播器的尺寸自动设定，在用xib和storyboard时可以先任意给定cell尺寸，cell内部组件可采用autolayout技术布局
 */
//以何种方式创建的cell
typedef enum{
    LBCording = 1,//纯代码
    LBXib,//xib
    LBStoryboard//storyboard
}LBCellType;

//这里不知道cell的类型和属性，将cell和model传递到controller中进行设置
typedef void(^sendBlock)(id cell,id model);

@interface LBImageCarouselView : UICollectionView
//用来设置自定义的cell的model，必须实现此block否则无法正常显示cell
@property(nonatomic,copy) sendBlock setCellModelBlock;
//你可以在父控件中设置好pageControl的frame，color等属性，然后将其传给此属性即可实现pageControl跟随滚动显示的效果
@property(nonatomic,strong) UIPageControl *pageControl;
//用来设置定时器的滚动速度
@property (nonatomic,assign) NSTimeInterval timeInterval;

/**
 用来创建轮播器的初始化方法
 参数：
 modelArray: 装cell模型的数组
 cellClassName: 自定义的cell的类名
 cellType: 用何种方式自定义的cell
 timeInterval: 自动翻页的速度，每timeInterval秒翻动一次
 */
- (instancetype)initWithFrame:(CGRect)frame AndWithModelArray:(NSArray *)modelArray AndWithClassNameOfCell:(NSString *)cellClassName AndWithCellType:(LBCellType)cellType AndWithTimeInterval:(NSTimeInterval)timeInterval;
@end
