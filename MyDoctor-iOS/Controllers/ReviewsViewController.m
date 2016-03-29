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
    return [[self.reviews  valueForKey:@"result"] count]*2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %2 == 1) {
        // Fetch yourText for this row from your data source..
        return 10;
    }
    else{
        NSString *yourText = [[[self.reviews  valueForKey:@"result"] objectAtIndex:indexPath.row/2] valueForKey:@"review"];
        
        CGSize lableWidth = CGSizeMake(300, CGFLOAT_MAX); // 300 is fixed width of label. You can change this value
     
        CGRect requiredSize = [yourText boundingRectWithSize:lableWidth options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Times New Roman" size:19]} context:nil];
        // Here, you will have to use this requiredSize and based on that, adjust height of your cell. I have added 10 on total required height of label and it will have 5 pixels of padding on top and bottom. You can change this too.
        int calculatedHeight = requiredSize.size.height+55;
        return (float)calculatedHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row%2 == 1) {
        cell.userInteractionEnabled = NO;
    }
    else{
        cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        cell.userInteractionEnabled = YES;
        //cell.textLabel.text = [[[self.reviews  valueForKey:@"result"] objectAtIndex:indexPath.row/2] valueForKey:@"review"];
        //cell.textLabel.numberOfLines = 0;
        //[cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *doctorSpeciality = (UILabel *)[cell viewWithTag:5];
        doctorSpeciality.text = [NSString stringWithFormat:@"- %@",[[[self.reviews  valueForKey:@"result"] objectAtIndex:indexPath.row/2] valueForKey:@"socialId"]];
        
        UILabel *review = (UILabel *)[cell viewWithTag:6];
        review.text = [[[self.reviews  valueForKey:@"result"] objectAtIndex:indexPath.row/2] valueForKey:@"review"];
        [review setLineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *title = (UILabel *)[cell viewWithTag:8];
        title.text = [[[self.reviews  valueForKey:@"result"] objectAtIndex:indexPath.row/2] valueForKey:@"title"];
        [title setLineBreakMode:NSLineBreakByWordWrapping];
        
        RateView* rv = [RateView rateViewWithRating:4];
        rv.starSize = 15;
        rv.rating = [[self.reviews valueForKey:@"doctorRating"] floatValue]/2;
        rv.starFillColor = [UIColor orangeColor];
        rv.starNormalColor = [UIColor whiteColor];
        rv.starBorderColor = [UIColor orangeColor];
        [[cell viewWithTag:7] addSubview:rv];
        [cell viewWithTag:7].backgroundColor = [UIColor clearColor];
        cell.userInteractionEnabled = NO;
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
