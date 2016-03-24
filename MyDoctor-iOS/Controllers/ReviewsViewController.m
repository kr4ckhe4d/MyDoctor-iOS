//
//  ReviewsViewController.m
//  MyDoctor-iOS
//
//  Created by Appmonkeyz on 3/24/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "ReviewsViewController.h"
#import "RateView.h"

@interface ReviewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *profilePicBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorName;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorSpecialities;
@property (weak, nonatomic) IBOutlet UIView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.profilePicBackground.layer.cornerRadius = self.profilePicBackground.frame.size.width/2;
    self.doctorProfilePic.clipsToBounds = YES;
    self.doctorProfilePic.layer.cornerRadius = self.doctorProfilePic.frame.size.height / 2;
    self.doctorProfilePic.layer.borderWidth = 1.5f;
    self.doctorProfilePic.layer.borderColor = [UIColor clearColor].CGColor;
    self.doctorProfilePic.image = self.theImage;
    
    self.lblDoctorName.text = self.doctorName;
    self.lblDoctorSpecialities.text = self.doctorSpecialities;
    
    NSLog(@"%@",self.reviews);
    
    RateView* rv = [RateView rateViewWithRating:4];
    
    rv.starSize = self.ratingsView.frame.size.height;
    rv.rating = [[self.reviews valueForKey:@"doctorRating"] floatValue]/2;
    rv.starFillColor = [UIColor orangeColor];
    rv.starNormalColor = [UIColor whiteColor];
    rv.starBorderColor = [UIColor orangeColor];
    rv.center = CGPointMake(self.ratingsView.frame.size.width/2, self.ratingsView.frame.size.height/2);
    [self.ratingsView addSubview:rv];
    
    self.lblRating.text = [NSString stringWithFormat:@"%.1f",[[self.reviews valueForKey:@"doctorRating"] floatValue]/2];
}

#pragma mark - custom methods


#pragma mark - button actions
- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table view delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %2 == 1) {
        return  2;
    }
    else{
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row%2 == 1) {
        cell.userInteractionEnabled = NO;
    }
    else{
        cell.backgroundColor = [UIColor grayColor];
        cell.userInteractionEnabled = YES;

    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
