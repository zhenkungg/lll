//
//  FindView.m
//  Life
//
//  Created by lanou on 16/5/25.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "FindView.h"
#import "CategoryModel.h"
#import "ShowFindViewController.h"

@interface FindView ()

@property (nonatomic,strong)ZJScrollPageView *scroll;

@end

@implementation FindView

- (void)setArr:(NSMutableArray *)arr{
    if (self.arr != arr) {
        _arr = arr;
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc]init];
        style.showLine = YES;
        style.selectedTitleColor = [UIColor orangeColor];
        style.gradualChangeTitleColor = YES;
        style.titleFont = [UIFont systemFontOfSize:12];
        style.titleMargin = 12;
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            CategoryModel *model = arr[i];
            ShowFindViewController *show = [[ShowFindViewController alloc]init];
            if (i == 0) {
                show.stringURL = recommendURL;
            }
            show._id = model._id;
            show.title = model.title;
            [array addObject:show];
        }
        self.scroll = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) segmentStyle:style childVcs:array parentViewController:_viewControl];
        [self addSubview:self.scroll];
    }
}

@end
