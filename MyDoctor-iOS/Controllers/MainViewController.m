//
//  MainViewController.m
//  MyDoctor-iOS
//
//  Created by Appmonkeyz on 3/16/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *applogo;

@end
UISearchBar *searchBar;
@implementation MainViewController

- (void)viewDidLoad {
    self.applogo.image = [UIImage imageNamed:@"appLogo"];
    
    //NSLog(@"%f",[[UIApplication sharedApplication] statusBarFrame].size.height);
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgroundImage"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
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
    border.frame = CGRectMake(0, self.textField.frame.size.height - borderWidth, self.textField.frame.size.width, self.textField.frame.size.height);
    border.borderWidth = borderWidth;
    [self.textField.layer addSublayer:border];
    self.textField.layer.masksToBounds = YES;
    self.textField.backgroundColor = [UIColor clearColor];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)btnRate:(id)sender {
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
        [searchBar setPlaceholder:@"Search a Doctor"];
        [self.view addSubview:searchBar];
        [searchBar becomeFirstResponder];
    
    UITableView *testView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+self.textField.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view addSubview:testView];
    
        [UIView animateWithDuration:0.6 delay:0.1 options:nil animations:^{
            CGPoint _centre = searchBar.center;
            _centre.y = 20 + searchBar.bounds.size.height/2;
            searchBar.center = _centre;
            testView.backgroundColor = [UIColor whiteColor];
            testView.alpha = 0.5;
        } completion:nil];
}

#pragma mark - hide keyboard

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.6 delay:0.1 options:nil animations:^{
        CGPoint _centre = searchBar.center;
        _centre.y -= 80;
        searchBar.center = _centre;
    } completion:nil];
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
