//
//  TopicsModel.h
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "BaseModel.h"

@interface TopicsModel : BaseModel

//end
@property (nonatomic,assign)NSInteger end;
//*seqId*/
@property (nonatomic,assign)NSInteger sequenceId;
//id
@property (nonatomic,strong)NSString *_id;
//图片地址
@property (nonatomic,strong)NSString *iconUrl;
//标题
@property (nonatomic,strong)NSString *title;
//描述
@property (nonatomic,strong)NSString *digest;
//*多少人关注*/
@property (nonatomic,assign)NSInteger decayHeat;


@end
