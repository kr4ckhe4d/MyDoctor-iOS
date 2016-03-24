//
//  DoctorProfileViewController.m
//  MyDoctor-iOS
//
//  Created by Appmonkeyz on 3/23/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "DoctorProfileViewController.h"
#import "RateView.h"
#import "ReviewsViewController.h"

@interface DoctorProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *profilePictureBackground;
@property (weak, nonatomic) IBOutlet UIImageView *doctorPhoto;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecialities;
@property (weak, nonatomic) IBOutlet UIView *ratingsView;
@property (weak, nonatomic) IBOutlet UIButton *btnShowReviews;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteReview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
NSDictionary *doctorInformation;
NSDictionary *doctorHospitals;
NSURLSessionDataTask *getJSONTask;
NSMutableDictionary *imageDictionary;
NSMutableDictionary *doctorReviews;
@implementation DoctorProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"doc id is %ld",(long)self.doctorId);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.profilePictureBackground.layer.cornerRadius = self.profilePictureBackground.frame.size.width/2;
    
//    UIImageView *profilePic = (UIImageView *)[self.viewContent viewWithTag:5];
    self.doctorPhoto.clipsToBounds = YES;
    self.doctorPhoto.layer.cornerRadius = self.doctorPhoto.frame.size.height / 2;
    self.doctorPhoto.layer.borderWidth = 1.5f;
    self.doctorPhoto.layer.borderColor = [UIColor grayColor].CGColor;
    //self.doctorPhoto.image = [UIImage imageNamed:@"stethoscope.jpg"];
    
    // 1
    NSString *dataUrl = [NSString stringWithFormat:@"http://52.58.12.56/dr-app/web/api/doctor/%ld",(long)self.doctorId];
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    // 2
    getJSONTask = [[NSURLSession sharedSession]
                    dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        doctorInformation = [NSDictionary dictionaryWithDictionary:json];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            doctorInformation = [NSDictionary dictionaryWithDictionary:json];
                            
                            NSLog(@"%@", [[doctorInformation valueForKey:@"doctor"] valueForKey:@"profileImage"]);
                            NSString *imageURL = [[doctorInformation valueForKey:@"doctor"] valueForKey:@"profileImage"];
                            self.doctorPhoto.image = [self imageNamed:imageURL cache:YES];
                            self.doctorName.text = [NSString stringWithFormat:@"Dr. %@",[[doctorInformation valueForKey:@"doctor"] valueForKey:@"name"]];
                            
                            if ([[doctorInformation valueForKey:@"speciality"] count]!=0) {
                                
                            NSMutableString *specialitiesList = [NSMutableString stringWithFormat:@"%@",[[[doctorInformation valueForKey:@"speciality"] objectAtIndex:0] valueForKey:@"specialityName"]];
                            if ([[doctorInformation valueForKey:@"speciality"] count]>0) {
                                
                            for(NSArray *i in [doctorInformation valueForKey:@"speciality"]){
                                [specialitiesList appendFormat:@", %@",[i valueForKey:@"specialityName"]];
                            }
                            }
                            
                            self.lblSpecialities.text = specialitiesList;
                            }
                        });
                    }];
        // 3
    [getJSONTask resume];
    
    RateView* rv = [RateView rateViewWithRating:4];
    
    rv.starSize = self.ratingsView.frame.size.height;
    rv.rating = [self getDoctorRating:(int)self.doctorId]/2;
    rv.starFillColor = [UIColor orangeColor];
    rv.starNormalColor = [UIColor whiteColor];
    rv.starBorderColor = [UIColor orangeColor];
    rv.center = CGPointMake(self.ratingsView.frame.size.width/2, self.ratingsView.frame.size.height/2);
    [self.ratingsView addSubview:rv];
    
    self.btnShowReviews.layer.cornerRadius = 3;
    self.btnWriteReview.layer.cornerRadius = 3;
}

#pragma mark - button actions
- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShowReviews:(id)sender {
    [self performSegueWithIdentifier:@"REVIEWS" sender:self];
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ReviewsViewController *reviewsViewController = (ReviewsViewController *)segue.destinationViewController;
    reviewsViewController.theImage = self.doctorPhoto.image;
    reviewsViewController.doctorName = self.doctorName.text = [NSString stringWithFormat:@"Dr. %@",[[doctorInformation valueForKey:@"doctor"] valueForKey:@"name"]];
    reviewsViewController.doctorSpecialities = self.lblSpecialities.text;
    reviewsViewController.reviews = [NSDictionary dictionaryWithDictionary:doctorReviews];
}

#pragma mark - custom methods
//Caching doctor profile pictures
- (UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
    UIImage* retImage = [imageDictionary objectForKey:imageNamed];
    if (retImage == nil)
    {
        retImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
        if (cache)
        {
            if (imageDictionary == nil)
                imageDictionary = [NSMutableDictionary new];
            
            [imageDictionary setObject:retImage forKey:imageNamed];
        }
    }
    return retImage;
}

- (CGFloat)getDoctorRating:(int)doctorId{
    NSString *dataUrl = [NSString stringWithFormat:@"http://52.58.12.56/dr-app/web/api/review/%d/1",doctorId];
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    doctorReviews = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [[doctorReviews valueForKey:@"doctorRating"] floatValue];
}

#pragma mark - table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger noOfHospitals = [[doctorInformation valueForKey:@"hospital"] count];
    return noOfHospitals*2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==1) {
        return 2;
    }
    else{
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row%2==1) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.userInteractionEnabled = NO;
    }
    else{
        cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        //cell.alpha = 0.3;
        UIImageView *rightArrow = (UIImageView *)[cell viewWithTag:5];
        //rightArrow.frame = CGRectMake(cell.frame.size.width-cell.frame.size.height/2, cell.frame.size.height/2, 2, 2);
        rightArrow.image = [UIImage imageNamed:@"rightArrow"];
        cell.userInteractionEnabled = YES;
        cell.textLabel.text = [[[doctorInformation valueForKey:@"hospital"] objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.textLabel.textColor = [UIColor blackColor];


    }
    //NSLog(@"%@",doctorInformation);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Row number is: %ld", indexPath.row/2);
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
