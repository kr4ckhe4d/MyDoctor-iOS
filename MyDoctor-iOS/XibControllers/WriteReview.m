//
//  WriteReview.m
//  MyDoctor-iOS
//
//  Created by Nipuna H Herath on 4/7/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "WriteReview.h"
#include "RateView.h"
@interface WriteReview(){
    CGSize _intrinsicContentSize;
}
@end
RateView *rateviewxib;
@implementation WriteReview

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"WriteReview" owner:self options:nil];
        self.bounds = self.view.bounds;
        _intrinsicContentSize = self.bounds.size;
        
        [self addSubview:self.view];
        
    }
    return self;
}

-(void)didMoveToSuperview{
    NSLog(@"REVTITLE: %@",self.revTitle);
    rateviewxib = [RateView rateViewWithRating:0];
    rateviewxib.starSize = [self.view viewWithTag:7].frame.size.height;
    //rv.rating = [self getDoctorRating:(int)self.doctorId]/2;
    rateviewxib.canRate = YES;
    rateviewxib.starFillColor = [UIColor orangeColor];
    rateviewxib.starNormalColor = [UIColor whiteColor];
    rateviewxib.starBorderColor = [UIColor orangeColor];
    //rateviewxib.center = CGPointMake(([self.view viewWithTag:7].bounds.size.width/2), [self.view viewWithTag:7].frame.size.height/2);
    [[self.view viewWithTag:7] addSubview:rateviewxib];
    
    // Setting up the bottom border line of the search TextField
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor orangeColor].CGColor;
    border.frame = CGRectMake(0, self.reviewTitle.frame.size.height-4, self.view.bounds.size.width*2, 1);
    border.borderWidth = borderWidth;
    [self.reviewTitle.layer addSublayer:border];
    self.reviewTitle.layer.masksToBounds = YES;
    self.reviewTitle.backgroundColor = [UIColor clearColor];
    
    self.textReview.textContainer.maximumNumberOfLines=3;
}

-(CGSize)intrinsicContentSize{
    return _intrinsicContentSize;
}
#pragma mark - button actions
- (IBAction)btnCancel:(id)sender {
    CGPoint center = self.center;
    center.y = self.view.bounds.size.height*2;
    center.x = self.view.bounds.size.width/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.center = center;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.center = center;
}
- (IBAction)btnSubmitReview:(id)sender {
    [[[self superview] viewWithTag:11] removeFromSuperview];
}


#pragma mark - hide keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.textReview setContentOffset:CGPointZero animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
