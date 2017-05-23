//
//  Description.m
//  QuickBoxApplication
//
//  Created by Media park  on 18/05/2017.
//  Copyright © 2017 QuickBox. All rights reserved.
//

#import "Description.h"

@interface Description ()
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UITextView *textview;

@end

@implementation Description

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *rtap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goback)];
    rtap1.numberOfTapsRequired = 1;
    _backimage.userInteractionEnabled = YES;
    [_backimage addGestureRecognizer:rtap1];
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [_textview setText:[settings objectForKey:@"description"]];
}
- (IBAction)back:(id)sender {
    [self goback];
}
-(void)goback
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"listofarticles"];
    [self presentViewController:vc animated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any relistofarticlessources that can be recreated.
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
