//
//  CarouselVIew.m
//  轮播图
//
//  Created by 栾斌 on 16/5/11.
//  Copyright © 2016年 栾斌. All rights reserved.
//
#import "CarouselVIew.h"
#import "JT3DScrollView.h"
@interface CarouselVIew ()<UIScrollViewDelegate>

@property(nonatomic,retain)JT3DScrollView *scrollView;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)UILabel *textLable;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
//当前显示的下标
@property(nonatomic,assign)NSInteger curPage;
//存放当前显示的图片
@property(nonatomic,retain)NSMutableArray *curArray;
@property(nonatomic,retain)NSTimer *timer;

@end
@implementation CarouselVIew

-(id)initWithFrame:(CGRect)frame
{
    _width = frame.size.width;
    _height = frame.size.height;
    if (self = [super initWithFrame:frame]) {
        [self initWithScrollView];
        [self initWithPageControl];
        [self initWithTextLable];
    }
    return self;
    
}
//创建scrollView
-(void)initWithScrollView
{
    self.scrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    self.scrollView.effect = JT3DScrollViewEffectDepth;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_width*3, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(_width, 0);
    _scrollView.backgroundColor = [UIColor blackColor];
    self.curArray = [NSMutableArray arrayWithCapacity:3];
    //遍历创建显示的三张图片
    for(int i=0;i<3;i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_width*i, 0 , _width, _height)];

        [_scrollView addSubview:imageView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    tap.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tap];
    
    [self addSubview:_scrollView];
    
}
//点击手势触发的方法
- (void)toDetail{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTopicsDetail" object:self.array[self.curPage]];
}


//创建pageControl
-(void)initWithPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(_width-80, _height-25, 70, 30)];
    [self addSubview:_pageControl];
    
}
//创建文字信息
-(void)initWithTextLable
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _height -25, _width ,25 )];
    view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    [self addSubview:view];
    self.textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, _height -25, _width ,25 )];
    self.textLable.textColor = [UIColor whiteColor];
    self.textLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.textLable];

    
}

//实现array的set方法设置数据源
-(void)setArray:(NSArray *)array
{
    _array = [array copy];
    //获取数据源
    [self updateCurViewWithPage:0];
    self.pageControl.numberOfPages = array.count;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoupdate:) userInfo:nil repeats:YES];
}

//替换数据源的方法
-(void)updateCurViewWithPage:(NSInteger)page
{
    //page = 0
    //获取上一张图片的下标
    NSInteger  per =  [self updateCurPage:page-1];
    //当前显示的下标
    self.curPage = [self updateCurPage:page];
    //获取下一张图片的下标
    NSInteger last = [self updateCurPage:page+1];
    //当前显示的数据源
    [self.curArray removeAllObjects];
    [self.curArray addObject:self.array[per]];
    [self.curArray addObject:self.array[_curPage]];
    [self.curArray addObject:self.array[last]];
    //获取scrollView上的所有子试图
    NSArray *subarray = self.scrollView.subviews;
    for (int i = 0; i< 3; i++) {
        UIImageView *imageView = subarray[i];
        TopicsModel *model = self.curArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        if(i == 1)
        {
            self.textLable.text = [self.curArray[1] title];
        }
    }
    //显示中间一张
    self.scrollView.contentOffset = CGPointMake(_width, 0);
    self.pageControl.currentPage = _curPage;
}

//专门计算下标的方法
-(NSInteger)updateCurPage:(NSInteger)page
{
    NSInteger count = (page + self.array.count)%self.array.count;
//    NSLog(@"%ld",count);
    return count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    
    if (x >= _width*2) {
        [self updateCurViewWithPage:_curPage+1];
    }else if(x <= 0)
    {
        [self updateCurViewWithPage:_curPage-1];
    }
    
}
//自动播放下一页
-(void)autoupdate:(id)sender
{

    CGPoint point = self.scrollView.contentOffset;
    point.x = _width * 2;
    self.scrollView.contentOffset = point;

}

//开始拖动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

//开始减速
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoupdate:) userInfo:nil repeats:YES];
    
}

@end
