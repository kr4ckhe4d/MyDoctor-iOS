//
//  MainViewController.m
//  MyDoctor-iOS
//
//  Created by Appmonkeyz on 3/16/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "MainViewController.h"

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
@implementation MainViewController

- (void)viewDidLoad {
    self.applogo.image = [UIImage imageNamed:@"appLogo"];
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    //NSLog(@"%f",[[UIApplication sharedApplication] statusBarFrame].size.height);
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgroundImage"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //NSLog(@"x = %f y = %f height = %f width = %f",self.textField.frame.origin.x,self.textField.frame.origin.x,self.textField.bounds.size.height,self.textField.bounds.size.width);
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(-260.0, 20.0+self.searchBarBackground.frame.size.height/2, 60.0, 37.0)];
    [self.view addSubview:cancelButton];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self
               action:@selector(cancelButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, self.view.frame.size.height/2, self.view.frame.size.width-20, 37.0)];
    [self.view addSubview:textField];
    [textField setPlaceholder:@"Search by name"];

    [textField setBackgroundColor:[UIColor greenColor]];
    
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    // add the effect view to the image view
    [self.background addSubview:effectView];
  
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor orangeColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    textField.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    UITapGestureRecognizer *tableViewTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapAction:)];
    [self.tableView addGestureRecognizer:tableViewTapped];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView setHidden:YES];
}

#pragma mark - button actions

- (IBAction)btnRate:(id)sender {
    // 1
    NSString *dataUrl = @"http://52.58.12.56/dr-app/web/api/doctors?keyword=ja";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    // 2
    downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"%@", [[json valueForKey:@"result"] valueForKey:@"doctor"]);
                                          }];
    
    // 3
    [downloadTask resume];
}

#pragma mark - custom methods

- (void)keyboardDidShow: (NSNotification *) notif{
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        //[self.view addSubview:testView];
        //testView.backgroundColor = [UIColor whiteColor];
        //testView.alpha = 0.7;
        //        CGPoint _centre = textField.center;
        //        _centre.y = 20 + textField.bounds.size.height/2;
        //        textField.center = _centre;
        [self.tableView setHidden:NO];
        
        [self.tableView setFrame:CGRectMake(0, 20+textField.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
        [textField setFrame:CGRectMake(10.0,self.searchBarBackground.frame.size.height/2, 250, 37)];
        [cancelButton setFrame:CGRectMake(260.0, textField.frame.size.height/2, 60.0, 37.0)];
        
    } completion:nil];
}

- (IBAction)cancelButtonAction:(id)sender{
    [self.view endEditing:YES];
    [self.tableView setHidden:YES];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [cancelButton setFrame:CGRectMake(-260.0, 20.0+textField.frame.size.height/2, 60.0, 37.0)];
        [textField setFrame:CGRectMake(10.0, self.view.frame.size.height/2, self.view.frame.size.width-10, 37.0)];
        
    } completion:nil];
}

- (void)tableViewTapAction:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

#pragma mark - table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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

#pragma mark - hide keyboard

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
//    [UIView animateWithDuration:0.6 delay:0.1 options:nil animations:^{
//        CGPoint _centre = searchBar.center;
//        _centre.y -= 80;
//        searchBar.center = _centre;
//    } completion:nil];
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
