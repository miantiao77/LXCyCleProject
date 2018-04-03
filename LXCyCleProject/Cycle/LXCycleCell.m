//
//  LXCycleCell.m
//  002-RunTime运行时初探
//
//  Created by lx on 2018/4/2.
//  Copyright © 2018年 yintu. All rights reserved.
//

#import "LXCycleCell.h"

@implementation LXCycleCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    _imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView];
}
- (void)layoutSubviews
{
    [_imgView setFrame:self.bounds];
}
@end
