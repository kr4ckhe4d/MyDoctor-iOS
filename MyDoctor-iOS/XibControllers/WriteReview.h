//
//  WriteReview.h
//  MyDoctor-iOS
//
//  Created by Nipuna H Herath on 4/7/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RateView.h"

@interface WriteReview : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *reviewTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextView *textReview;

@property (retain,nonatomic) NSString *revTitle;

@end
