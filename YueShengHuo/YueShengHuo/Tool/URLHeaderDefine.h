//
//  URLHeaderDefine.h
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#ifndef URLHeaderDefine_h
#define URLHeaderDefine_h

#pragma mark 保存网址

//*首页模块请求地址*/
#define carouselURL  @"http://course2.jaxus.cn/api/v2/course/topics?all=1&end=5&start=0"//轮播图
#define topicsURL  @"http://course2.jaxus.cn/api/v2/course/topics?all=1&end=5&start=0"//小图
#define goodsURL     @"http://course2.jaxus.cn/api/v2/mall/subject?start=0&end=20"//物品
#define goodsDetailURL @"http://course2.jaxus.cn/api/v2/mall/subject/"//物品详情
#define moreTopicsURL @"http://course2.jaxus.cn/api/v2/course/topics?all=1"//更多标签


//标签列表
#define topCategoryURL @"http://course2.jaxus.cn/api/v2/course/topic/detail?topicId="
//标签最热列表
#define topicHotURL @"http://course2.jaxus.cn/api/v2/course/topic/hot-courses?end=20&start=0&topicId=URL"

//标签最新列表
#define topicNewURL @"http://course2.jaxus.cn/api/v2/course/topic/new-courses?end=20&start=0&topicId=URL"


//*发现模块请求地址*/
#define recommendURL @"http://course2.jaxus.cn/api/v2/recommendation/course?length=20"//推荐地址

//分类模块请求地址
#define categoryURL @"http://course2.jaxus.cn/api/v2/course/category/all"

//分类列表
#define categorykindURL @"http://course2.jaxus.cn/api/v2/course/category/detail?categoryId="
//分类最热列表
#define categoryHotURL @"http://course2.jaxus.cn/api/v2/course/category/hot-courses?categoryId=URL&end=20&start=0"

//分类最新列表
#define categoryNewURL @"http://course2.jaxus.cn/api/v2/course/category/new-courses?categoryId=URL&end=20&start=0"
//分类详情请求地址
#define Detail_URL @"http://course2.jaxus.cn/api/v2/course?courseId="

//*我的模块请求地址*/

//*搜索模块请求地址*/
#define hotSearchURL @"http://course2.jaxus.cn/api/v2/search/hot"//得到热门搜索词
#define searchWordURL @"http://course2.jaxus.cn/api/v2/search?start=0&searchType=both&end=20&key="//搜索关键词


#endif /* URLHeaderDefine_h */
