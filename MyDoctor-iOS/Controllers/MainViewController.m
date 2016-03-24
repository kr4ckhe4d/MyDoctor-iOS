//
//  MainViewController.m
//  MyDoctor-iOS
//
//  Created by Appmonkeyz on 3/16/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "MainViewController.h"
#import "RateView.h"
#import "DoctorProfileViewController.h"

@interface MainViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *background;
//@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *applogo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchBarBackground;



@end
UISearchBar *searchBar;
UITextField *textField;
UIButton *cancelButton;
UITableView *testView;
NSURLSessionDataTask *downloadTask;

NSDictionary *searchResult;
NSDictionary *reviews;
NSInteger row;

NSMutableDictionary *staticImageDictionary;

NSURLSessionConfiguration *sessionConfig;
NSURLSession *session;
NSURLSessionDownloadTask *getImageTask;
@implementation MainViewController

- (void)viewDidLoad {
    // Set the application logo on the Main view
    self.applogo.image = [UIImage imageNamed:@"appLogo"];
    
    // Set search results TableView background alpha
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    
    // Setting Main View background Image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgroundImage"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // create blur effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    // add the effect view to the image view
    [self.background addSubview:effectView];
    
    // Cancel button of search
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(-260.0, 20.0+self.searchBarBackground.frame.size.height/2, 60.0, 37.0)];
    [self.view addSubview:cancelButton];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self
               action:@selector(cancelButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // Search TextField
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, self.view.frame.size.height/2, self.view.frame.size.width-20, 37.0)];
    [self.view addSubview:textField];
    [textField setPlaceholder:@"Search by name"];
    [textField setBackgroundColor:[UIColor greenColor]];
   
    // Setting up the bottom border line of the search TextField
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor orangeColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    textField.backgroundColor = [UIColor clearColor];
    
    // Search Text Field change event
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    // Search TextField keyboardDidShow Action
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Search Results tableView touched action
    UITapGestureRecognizer *tableViewTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapAction:)];
    tableViewTapped.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewTapped];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView setHidden:YES];
    [self cancelButtonAction:nil];
}

#pragma mark - button actions

- (IBAction)btnRate:(id)sender {
//    // 1
//    NSString *dataUrl = @"http://52.58.12.56/dr-app/web/api/doctors?keyword=ja";
//    NSURL *url = [NSURL URLWithString:dataUrl];
//    
//    // 2
//    downloadTask = [[NSURLSession sharedSession]
//                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                              NSLog(@"%@", [[json valueForKey:@"result"] valueForKey:@"doctor"]);
//                                          }];
//    
//    // 3
//    [downloadTask resume];
    NSLog(@"%ld",(long)[self getDoctorRating:2]);
}

#pragma mark - custom methods
//Caching doctor profile pictures
- (UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
    UIImage* retImage = [staticImageDictionary objectForKey:imageNamed];
    if (retImage == nil)
    {
        retImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
        if (cache)
        {
            if (staticImageDictionary == nil)
                staticImageDictionary = [NSMutableDictionary new];
            
            [staticImageDictionary setObject:retImage forKey:imageNamed];
        }
    }
    return retImage;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.tableView setHidden:NO];
        [self.tableView setFrame:CGRectMake(0, 20+textField.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
        [textField setFrame:CGRectMake(10.0,self.searchBarBackground.frame.size.height/2, self.searchBarBackground.frame.size.width-cancelButton.frame.size.width, 37)];
        [cancelButton setFrame:CGRectMake(self.searchBarBackground.frame.size.width-cancelButton.frame.size.width, textField.frame.size.height/2, 60.0, 37.0)];
    } completion:nil];
}

- (IBAction)cancelButtonAction:(id)sender{
    [self.view endEditing:YES];
    [self.tableView setHidden:YES];
    
    
    textField.text = nil;
    searchResult = nil;
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [cancelButton setFrame:CGRectMake(-260.0, 20.0+textField.frame.size.height/2, 60.0, 37.0)];
        [textField setFrame:CGRectMake(10.0, self.view.frame.size.height/2, self.view.frame.size.width-10, 37.0)];
        
    } completion:nil];
}

- (NSInteger)getDoctorRating:(int)doctorId{
    NSString *dataUrl = [NSString stringWithFormat:@"http://52.58.12.56/dr-app/web/api/review/%d/1",doctorId];
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    reviews = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [[reviews valueForKey:@"doctorRating"] integerValue];
}

- (void)textFieldDidChange:(id)sender{
    NSInteger numberOfCharacters = [textField.text length];
    if (numberOfCharacters >= 2) {
        // 1
        NSString *dataUrl = [NSString stringWithFormat:@"http://52.58.12.56/dr-app/web/api/doctors?keyword=%@",[textField text]];
        NSURL *url = [NSURL URLWithString:dataUrl];
        
        // 2
        downloadTask = [[NSURLSession sharedSession]
                        dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                            searchResult = [NSDictionary dictionaryWithDictionary:json];
                            NSLog(@"%@", [[searchResult valueForKey:@"result"] objectAtIndex:0]);
                            
                                //row = 0;
                            
                            [self.tableView reloadData];
                                });
                        }];
        
        // 3
        [downloadTask resume];

    }
    else{
        searchResult = nil;
        [self.tableView reloadData];
    }
}

- (void)tableViewTapAction:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[searchResult valueForKey:@"result"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewForFooter = [UIView new];
    [viewForFooter setBackgroundColor:[UIColor clearColor]];
    return viewForFooter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = cell.frame.size.height/2;
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *doctorName = (UILabel *)[cell viewWithTag:1];
    doctorName.text = [[[[searchResult valueForKey:@"result"] objectAtIndex:indexPath.row] valueForKey:@"doctor"] valueForKey:@"name"];
    
    NSMutableString *specialitiesList = [NSMutableString stringWithFormat:@""];
    for(NSArray *i in [[[searchResult valueForKey:@"result"] objectAtIndex:indexPath.row] valueForKey:@"speciality"]){
        [specialitiesList appendFormat:@"%@, ",[i valueForKey:@"specialityName"]];
    }

    UILabel *doctorSpeciality = (UILabel *)[cell viewWithTag:2];
    doctorSpeciality.text = specialitiesList;
    
    UIImageView *doctorPhoto = (UIImageView *)[cell viewWithTag:3];
    doctorPhoto.clipsToBounds = YES;
    doctorPhoto.layer.cornerRadius = doctorPhoto.frame.size.height / 2;
    doctorPhoto.layer.borderWidth = 1.5f;
    doctorPhoto.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSString *imageURL = [[[[searchResult valueForKey:@"result"] objectAtIndex:indexPath.row] valueForKey:@"doctor"] valueForKey:@"profileImage"];
    
    RateView* rv = [RateView rateViewWithRating:4];
    //rv.rating = 3.4;
    int docId = [[[[[searchResult valueForKey:@"result"] objectAtIndex:indexPath.row] valueForKey:@"doctor"] valueForKey:@"id"] intValue];
    NSLog(@"doctir id is %d",docId);
    rv.starSize = 15;
    rv.rating = [self getDoctorRating:docId]/2;
    rv.starFillColor = [UIColor yellowColor];
    rv.starNormalColor = [UIColor whiteColor];
    rv.starBorderColor = [UIColor orangeColor];
    [[cell viewWithTag:4] addSubview:rv];
    
    UIImage *doctorImage = [self imageNamed:imageURL cache:YES];
    doctorPhoto.image = doctorImage;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self.tableView setHidden:YES];
    
    textField.text = nil;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [cancelButton setFrame:CGRectMake(-260.0, 20.0+textField.frame.size.height/2, 60.0, 37.0)];
        [textField setFrame:CGRectMake(10.0, self.view.frame.size.height/2, self.view.frame.size.width-10, 37.0)];
        
    } completion:nil];
    [self performSegueWithIdentifier:@"DOCTOR_PROFILE" sender:self];
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
   // NSLog(@"%ld",[[[[[searchResult valueForKey:@"result"] objectAtIndex:indexPath.row] valueForKey:@"doctor"] valueForKey:@"id"] integerValue]);
    DoctorProfileViewController *doctorProfileViewController = (DoctorProfileViewController *)segue.destinationViewController;
    doctorProfileViewController.doctorId = [[[[[searchResult valueForKey:@"result"] objectAtIndex:indexPath.row] valueForKey:@"doctor"] valueForKey:@"id"] integerValue];
}

#pragma mark - hide keyboard

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
