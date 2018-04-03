//
//  LXCycleView.h
//  002-RunTime运行时初探
//
//  Created by lx on 2018/4/2.
//  Copyright © 2018年 yintu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXCycleView : UIView
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame datas:(NSArray *)datas;
@property (nonatomic,assign) UICollectionViewScrollDirection  scrollDirection;
@end
