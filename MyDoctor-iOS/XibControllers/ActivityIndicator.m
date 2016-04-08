//
//  ActivityIndicator.m
//  MyDoctor-iOS
//
//  Created by Nipuna H Herath on 4/7/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "ActivityIndicator.h"

@interface ActivityIndicator(){
    CGSize _intrinsicContentSize;
}
@end

@implementation ActivityIndicator

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ActivityIndicator" owner:self options:nil];
        self.bounds = self.view.bounds;
        _intrinsicContentSize = self.bounds.size;
        
        [self addSubview:self.view];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGSize)intrinsicContentSize{
    return _intrinsicContentSize;
}
@end
