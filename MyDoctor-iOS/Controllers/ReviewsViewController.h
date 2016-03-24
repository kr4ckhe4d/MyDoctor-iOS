//
//  ReviewsViewController.h
//  MyDoctor-iOS
//
//  Created by Appmonkeyz on 3/24/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *doctorProfilePic;
@property (nonatomic,retain) UIImage *theImage;
@property (nonatomic,retain) NSDictionary *reviews;
@property (nonatomic,retain) NSString *doctorName;
@property (nonatomic,retain) NSString *doctorSpecialities;
@end
