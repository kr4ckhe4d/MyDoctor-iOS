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
#import "HospitalProfileViewController.h"

@interface DoctorProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *profilePictureBackground;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *vwProfilePicBackground;
@property (weak, nonatomic) IBOutlet UIView *vwTopView;
@property (weak, nonatomic) IBOutlet UIView *writeReviewView;
@property (weak, nonatomic) IBOutlet UIView *ratingsView;
@property (weak, nonatomic) IBOutlet UIView *vwWriteReviewBackground;

@property (weak, nonatomic) IBOutlet UIImageView *doctorPhoto;

@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecialities;

@property (weak, nonatomic) IBOutlet UIButton *btnShowReviews;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteReview;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *reviewTitle;

@end
NSDictionary *doctorInformation;
NSDictionary *doctorHospitals;
NSURLSessionDataTask *getJSONTask;
NSMutableDictionary *imageDictionary;
NSMutableDictionary *doctorReviews;
NSMutableString *specialitiesList;

RateView* ratingInput;
@implementation DoctorProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Doctor ID is %ld",(long)self.doctorId);
    [self.tableView reloadData];
    [self.writeReviewView setHidden:YES];
    [self.vwWriteReviewBackground setHidden:YES];
    
    // Setting doctor's profile picture and its background
    
    self.profilePictureBackground.layer.cornerRadius = self.profilePictureBackground.frame.size.height/2;
    
    self.doctorPhoto.clipsToBounds = YES;
    self.doctorPhoto.layer.cornerRadius = self.doctorPhoto.frame.size.height / 2;
    self.doctorPhoto.layer.borderWidth = 1.5f;
    self.doctorPhoto.layer.borderColor = [UIColor grayColor].CGColor;
    
    // Retrieving doctor details from API
    
    NSString *dataUrl = [NSString stringWithFormat:@"http://52.58.12.56/dr-app/web/api/doctor/%ld",(long)self.doctorId];
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    getJSONTask = [[NSURLSession sharedSession]
                   dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       
                       if(data !=nil){
                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                       
                       doctorInformation = [NSDictionary dictionaryWithDictionary:json];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           doctorInformation = [NSDictionary dictionaryWithDictionary:json];
                           
                           NSLog(@"Doctor profile picture URL: %@", [[doctorInformation valueForKey:@"doctor"] valueForKey:@"profileImage"]);
                           NSString *imageURL = [[doctorInformation valueForKey:@"doctor"] valueForKey:@"profileImage"];
                           self.doctorPhoto.image = [self imageNamed:imageURL cache:YES];
                           self.doctorName.text = [NSString stringWithFormat:@"Dr. %@",[[doctorInformation valueForKey:@"doctor"] valueForKey:@"name"]];
                           
                           if ([[doctorInformation valueForKey:@"speciality"] count]!=0) {
                               
                               specialitiesList = [NSMutableString stringWithFormat:@"%@",[[[doctorInformation valueForKey:@"speciality"] objectAtIndex:0] valueForKey:@"specialityName"]];
                            
                               [self.tableView reloadData];
                               self.lblSpecialities.text = specialitiesList;
                           }
                       });
                   }
                   }];
    [getJSONTask resume];
    
    // Set up doctors rating view
    
    RateView* rv = [RateView rateViewWithRating:4];
    rv.starSize = self.ratingsView.frame.size.height;
    rv.rating = [self getDoctorRating:(int)self.doctorId]/2;
    rv.starFillColor = [UIColor orangeColor];
    rv.starNormalColor = [UIColor whiteColor];
    rv.starBorderColor = [UIColor orangeColor];
    rv.center = CGPointMake(self.view.frame.size.width/2, self.ratingsView.frame.size.height/2);
    [self.ratingsView addSubview:rv];
    
    // Set button corner radius
    self.btnShowReviews.layer.cornerRadius = 3;
    self.btnWriteReview.layer.cornerRadius = 3;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.writeReviewView.frame = CGRectMake(self.writeReviewView.frame.origin.x, self.writeReviewView.frame.origin.y+500, self.writeReviewView.frame.size.width, self.writeReviewView.frame.size.height);
}

#pragma mark - button actions
- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnCancelReview:(id)sender {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.writeReviewView setFrame:CGRectMake(self.writeReviewView.frame.origin.x, self.writeReviewView.frame.origin.y+500, self.writeReviewView.frame.size.width, self.writeReviewView.frame.size.height)];
        
        //[self.writeReviewView setHidden:YES];
        [self.vwWriteReviewBackground setHidden:YES];
    } completion:^(BOOL finished) {
        [self.writeReviewView setHidden:YES];
    }];
    
}

- (IBAction)btnWriteReview:(id)sender {
    self.btnSubmit.layer.cornerRadius = 3.0;
    self.btnCancel.layer.cornerRadius = 3.0;
    self.writeReviewView.layer.cornerRadius = 3.0;
    
    
    
    [self.vwWriteReviewBackground setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    
    self.textView.delegate = self;
    self.textView.text = @"Type your comments here";
    self.textView.textColor = [UIColor colorWithWhite:0.3 alpha:0.2]; //optional
    
    ratingInput = [RateView rateViewWithRating:0];
    ratingInput.starSize = [self.writeReviewView viewWithTag:6].frame.size.height;
    //rv.rating = [self getDoctorRating:(int)self.doctorId]/2;
    ratingInput.canRate = YES;
    ratingInput.starFillColor = [UIColor orangeColor];
    ratingInput.starNormalColor = [UIColor whiteColor];
    ratingInput.starBorderColor = [UIColor orangeColor];
    ratingInput.center = CGPointMake([self.writeReviewView viewWithTag:6].frame.size.width/2, [self.writeReviewView viewWithTag:6].frame.size.height/2);
    [[self.writeReviewView viewWithTag:6] addSubview:ratingInput];
    
    // Search TextField
    [self.reviewTitle setPlaceholder:@"Review title"];
    [self.reviewTitle setBackgroundColor:[UIColor greenColor]];
    
    // Setting up the bottom border line of the search TextField
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor orangeColor].CGColor;
    border.frame = CGRectMake(0, self.reviewTitle.frame.size.height - borderWidth, self.reviewTitle.frame.size.width, self.reviewTitle.frame.size.height);
    border.borderWidth = borderWidth;
    [self.reviewTitle.layer addSublayer:border];
    self.reviewTitle.layer.masksToBounds = YES;
    self.reviewTitle.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.writeReviewView setHidden:NO];
        [self.vwWriteReviewBackground setHidden:NO];
        
        [self.writeReviewView setFrame:CGRectMake(self.writeReviewView.frame.origin.x, self.writeReviewView.frame.origin.y-500, self.writeReviewView.frame.size.width, self.writeReviewView.frame.size.height)];

        
    } completion:nil];

}

- (IBAction)btnShowReviews:(id)sender {
    [self performSegueWithIdentifier:@"REVIEWS" sender:self];
}

- (IBAction)btnSubmit:(id)sender {
    float x = ratingInput.rating;
    NSLog(@"Rating : %0.1f", x);
}


#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"REVIEWS"]){
        ReviewsViewController *reviewsViewController = (ReviewsViewController *)segue.destinationViewController;
        reviewsViewController.theImage = self.doctorPhoto.image;
        reviewsViewController.doctorName = self.doctorName.text = [NSString stringWithFormat:@"Dr. %@",[[doctorInformation valueForKey:@"doctor"] valueForKey:@"name"]];
        reviewsViewController.doctorSpecialities = self.lblSpecialities.text;
        reviewsViewController.reviews = [NSDictionary dictionaryWithDictionary:doctorReviews];
    }
    else if([segue.identifier isEqualToString:@"HOSPITAL_PROFILE"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HospitalProfileViewController *hospitalProfileViewController = (HospitalProfileViewController *)segue.destinationViewController;
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[doctorInformation valueForKey:@"hospital"] objectAtIndex:indexPath.row/2]];
       // NSLog(@"Hospital id is: %@", dic);
        hospitalProfileViewController.passedDictionary = dic;
        
        
    }
    
    
    
    
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
        cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        //cell.alpha = 0.3;
        UIImageView *rightArrow = (UIImageView *)[cell viewWithTag:5];
        //rightArrow.frame = CGRectMake(cell.frame.size.width-cell.frame.size.height/2, cell.frame.size.height/2, 2, 2);
        rightArrow.image = [UIImage imageNamed:@"rightArrow"];
        cell.userInteractionEnabled = YES;
        cell.textLabel.text = [[[doctorInformation valueForKey:@"hospital"] objectAtIndex:indexPath.row/2] valueForKey:@"name"];
        cell.textLabel.textColor = [UIColor blackColor];


    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"HOSPITAL_PROFILE" sender:self];
    
   // NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[doctorInformation valueForKey:@"hospital"] objectAtIndex:indexPath.row/2]];
   // NSLog(@"Hospital id is: %@", dic);
}

#pragma mark - hide keyboard

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.textView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - keyboard actions
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type your comments here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type your comments here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"Text View characters: %lu",(unsigned long)self.textView.text.length);
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
