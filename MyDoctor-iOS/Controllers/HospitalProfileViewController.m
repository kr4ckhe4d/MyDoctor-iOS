//
//  HospitalProfileViewController.m
//  MyDoctor-iOS
//
//  Created by Nipuna H Herath on 4/4/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "HospitalProfileViewController.h"
#import "RateView.h"
#import "OpenInGoogleMapsController.h"
#import "WriteReview.h"

@interface HospitalProfileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblHospitalName;
@property (weak, nonatomic) IBOutlet UILabel *lblHospitalAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblHospitalWebsite;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UIImageView *hospitalImage;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIButton *btnHospitalReviews;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteReviews;

@end
NSDictionary *reviewResults;
UIView *writeReviewBackground;
NSMutableDictionary *staticImageDictionaryHospital;
@implementation HospitalProfileViewController
//@synthesize passedDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SFSFSDFSFSDFS");
    NSLog(@"%@", self.passedDictionary);
    
    UIImage *doctorImage = [self imageNamed:[self.passedDictionary valueForKey:@"image"] cache:YES];
    _hospitalImage.image = doctorImage;
    
    _btnWriteReviews.layer.cornerRadius = 3;
    _btnHospitalReviews.layer.cornerRadius = 3;
    
    // Do any additional setup after loading the view.
}

#pragma mark - view will appear

-(void)viewWillAppear:(BOOL)animated{
    [self.lblHospitalName setText:[self.passedDictionary valueForKey:@"name"]];
    [self.lblHospitalAddress setText:[self.passedDictionary valueForKey:@"address"]];
    [self.lblHospitalWebsite setText:[self.passedDictionary valueForKey:@"website"]];
    
    // Set up doctors rating view
    
    RateView* rv = [RateView rateViewWithRating:4];
    rv.starSize = self.rateView.bounds.size.height;
    float hospitalRating = [[self.passedDictionary valueForKey:@"id"] intValue];
    rv.rating = [self getHospitalRating:hospitalRating]/2;
    rv.starFillColor = [UIColor orangeColor];
    rv.starNormalColor = [UIColor whiteColor];
    rv.starBorderColor = [UIColor orangeColor];
    rv.center = CGPointMake(self.view.center.x-20, self.rateView.frame.size.height/2);
    [self.rateView addSubview:rv];
    //UILabel *rating = (UILabel *)[self.rateView viewWithTag:4];
    self.rating.frame = CGRectMake(10, self.rateView.frame.size.height/2, 60, 45);
    self.rating.text = [NSString stringWithFormat:@"%0.1f",hospitalRating/2];
    //[self.rateView addSubview:rating];
}

#pragma mark - custom methods
-(float)getHospitalRating:(int)hospitalID{
    NSString *dataUrl = [NSString stringWithFormat:@"http://52.58.12.56/dr-app/web/api/review/%d/2",hospitalID];
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    reviewResults = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    return [[reviewResults valueForKey:@"total"] floatValue];
}

//Caching doctor profile pictures
- (UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
    UIImage* retImage = [staticImageDictionaryHospital objectForKey:imageNamed];
    if (retImage == nil)
    {
        retImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
        if (cache)
        {
            if (staticImageDictionaryHospital == nil)
                staticImageDictionaryHospital = [NSMutableDictionary new];
            
            [staticImageDictionaryHospital setObject:retImage forKey:imageNamed];
        }
    }
    return retImage;
}

#pragma mark - button actions

- (IBAction)btnBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnWriteReview:(id)sender {
    writeReviewBackground = [[UIView alloc]initWithFrame:self.view.frame];
    writeReviewBackground.backgroundColor = [UIColor lightGrayColor];
    writeReviewBackground.tag = 11;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view addSubview:writeReviewBackground];
        }
                     completion:nil];

    WriteReview *writeReview = [[WriteReview alloc] init];
    
    writeReview.revTitle = @"LOL";
    writeReview.view.layer.cornerRadius = 3.0;
    [writeReviewBackground addSubview:writeReview];
    
    CGPoint center = writeReview.center;
    center.y = self.view.bounds.size.height*2;
    center.x = self.view.bounds.size.width/2;
    writeReview.center = center;
    
    writeReview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:writeReview
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:8.0
                              ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:writeReview
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-8.0
                              ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:writeReview
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-70.0
                              ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:writeReview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:100
                              ]];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [writeReview layoutIfNeeded];
                         //[[[writeReview superview] viewWithTag:11] removeFromSuperview];
                     }
                     completion:nil];
}

#pragma mark - table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==1) {
        return 4;
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
        cell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        cell.userInteractionEnabled = YES;
        cell.textLabel.textColor = [UIColor blackColor];
        
        if(indexPath.row == 2){
            UIImageView *rightArrow = (UIImageView *)[cell viewWithTag:5];
            rightArrow.image = [UIImage imageNamed:@"rightArrow"];
            
            UILabel *lblGetDirections = (UILabel *)[cell viewWithTag:6];
            [lblGetDirections setText:@"Get Directions"];
        }
        if(indexPath.row == 0){
            UILabel *lblPhoneNumber = (UILabel *)[cell viewWithTag:7];
            [lblPhoneNumber setText:[NSString stringWithFormat:@"+94 %@",[self.passedDictionary valueForKey:@"telephone"]]];
            
            UILabel *lblCallNow = (UILabel *)[cell viewWithTag:6];
            [lblCallNow setText:@"Call Now"];
        }
        
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        int tel =[[self.passedDictionary valueForKey:@"telephone"] intValue];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%d",tel]]];
    }
    if(indexPath.row == 2)
    {
        CLLocationDegrees latitude = [[self.passedDictionary valueForKey:@"latitude"] floatValue];
        CLLocationDegrees longitude = [[self.passedDictionary valueForKey:@"longitude"] floatValue];
        
        GoogleDirectionsDefinition *defn = [[GoogleDirectionsDefinition alloc] init];
        defn.startingPoint =nil;
        defn.destinationPoint = [GoogleDirectionsWaypoint
                                 waypointWithLocation:CLLocationCoordinate2DMake(latitude, longitude)];
        defn.travelMode = kGoogleMapsTravelModeDriving;
        [[OpenInGoogleMapsController sharedInstance] openDirections:defn];
    }
}

#pragma mark - hide keyboard
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [writeReviewBackground removeFromSuperview];
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
