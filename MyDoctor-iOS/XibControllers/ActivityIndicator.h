//
//  ActivityIndicator.h
//  MyDoctor-iOS
//
//  Created by Nipuna H Herath on 4/7/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicator : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@end
