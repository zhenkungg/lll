//
//  CategoryView.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CategoryView.h"
#import "Model.h"
#import "DetailViewController.h"
#import "EntryCategory.h"

@interface CategoryView ()

@property(nonatomic,strong)ZJScrollPageView *scroll;

@end
@implementation CategoryView

-(void)setArray:(NSMutableArray *)array{
    if (self.array != array) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc]init];
        style.showLine = YES;
        style.scrollLineColor = RGBCOLOR(0, 255, 255, 0.8);
        style.selectedTitleColor = RGBCOLOR(0, 255, 255, 0.8);
        style.gradualChangeTitleColor = YES;
        style.titleFont = [UIFont systemFontOfSize:20];
        style.titleMargin = ScreenWidth/4;
        style.titleBigScale = 50;
        
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            Model *entryModel = array[i];
            DetailViewController *detailVC = [[DetailViewController alloc]init];
            NSString *path = [NSString string];
            NSString *hot = [NSString string];
            NSString *new = [NSString string];
            detailVC.ID = entryModel._id;
            detailVC.topID = entryModel.topId;
            if(i == 0) {
                if (entryModel.topId == nil) {
                    path = categoryHotURL;
                    hot = [path stringByReplacingOccurrencesOfString:@"URL" withString:detailVC.ID];
                }else{
                    path = topicHotURL;
                    hot = [path stringByReplacingOccurrencesOfString:@"URL" withString:detailVC.topID];
                }
                detailVC.hotURL = hot;
                detailVC.title = entryModel.title;
                detailVC.topID = entryModel.topId;
            }else{
                if (entryModel.topId == nil) {
                    path = categoryNewURL;
                    new = [path stringByReplacingOccurrencesOfString:@"URL" withString:detailVC.ID];
                }else{
                    path = topicNewURL;
                    new = [path stringByReplacingOccurrencesOfString:@"URL" withString:detailVC.topID];
                }
                detailVC.ID = entryModel._id;
                detailVC.neWithUrl = new;
                detailVC.title = entryModel.title;
                detailVC.topID = entryModel.topId;
            }
            [arr addObject:detailVC];
        }
        self.scroll = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) segmentStyle:style childVcs:arr parentViewController:_viewControl];
        
        [self addSubview:self.scroll];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
