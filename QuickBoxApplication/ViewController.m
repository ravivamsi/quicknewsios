//
//  ViewController.m
//  QuickBoxApplication
//
//  Created by Media park  on 18/05/2017.
//  Copyright © 2017 QuickBox. All rights reserved.
//
#import "ViewController.h"
#import "Customcell.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIImageView *sortclick;
@property (weak, nonatomic) IBOutlet UITextField *sortText;
@property (weak, nonatomic) IBOutlet UIView *mainview;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property (weak, nonatomic) IBOutlet UIView *sortviewclick;
@end
@implementation ViewController
- (IBAction)back:(id)sender {
    [self goback];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //implement click listner on sort drop down image
    UITapGestureRecognizer *rtap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSorts)];
    rtap1.numberOfTapsRequired = 1;
    _sortclick.userInteractionEnabled = YES;
    [_sortclick addGestureRecognizer:rtap1];
    /////////////////////////////////////////////////
    
    //implement click listner on sort drop down whole view
    UITapGestureRecognizer *rtap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSorts)];
    rtap2.numberOfTapsRequired = 1;
    _sortviewclick.userInteractionEnabled = YES;
    [_sortviewclick addGestureRecognizer:rtap2];
    /////////////////////////////////////////////////////
    
    
    //settting up sort options list
    sortOptions=[NSMutableArray arrayWithObjects:@"top",@"latest",@"popular", nil];
    
    //load articles from the web api
    [self reloadArticles:@"top"];
    
    
    //implement click listner on back image to move to on previous screen.
    UITapGestureRecognizer *rtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goback)];
    rtap.numberOfTapsRequired = 1;
    _backimage.userInteractionEnabled = YES;
    [_backimage addGestureRecognizer:rtap];
    ////////////////////////////////////////////////////////////////////////
}
//move to previous screen method
-(void)goback
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"home"];
    [self presentViewController:vc animated:YES completion:NULL];
    
}
////////////////////////////////////////////////////////////////////


//display list of sort options method
-(void)showSorts
{

    UIAlertController *departureActnSht = [UIAlertController alertControllerWithTitle:@"Select Option"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    for (int j =0 ; j<sortOptions.count; j++)
    {
        NSString *titleString = [sortOptions objectAtIndex:j];
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [_sortText setText:[action title]];
            [self reloadArticles:[action title]];
            
        }];
        [departureActnSht addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        // [self dismissViewControllerAnimated:departureActnSht completion:nil];
    }];
    [departureActnSht addAction:cancelAction];
    
    [self presentViewController:departureActnSht animated:YES completion:nil];

}
////////////////////////////////////////////////////////////////////////////////////////////


//load articles from the web rest api
-(void)reloadArticles:(NSString *)sortby
{
    
    self.mainview.hidden=true;
    _loader.hidden=false;
    [_loader startAnimating];
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    //Create an URLRequest
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://newsapi.org/v1/articles"];
    NSURLQueryItem *search = [NSURLQueryItem queryItemWithName:@"source" value:[settings objectForKey:@"s_id"]];
    NSURLQueryItem *search1 = [NSURLQueryItem queryItemWithName:@"apiKey" value:@"2df3c32ef6ff497b8c422bdf33fdcf71"];
    NSURLQueryItem *search2 = [NSURLQueryItem queryItemWithName:@"sortBy" value:sortby];
    components.queryItems = @[ search ,search1,search2];
    NSURL *url = components.URL;
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //Create GET Params and add it to HTTPBody
    [urlRequest setHTTPMethod:@"GET"];
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDict);
        _loader.hidden=true;
        [_loader stopAnimating];
        //calling method for json parsing of the repsponce
        [self parsejson:responseDict];
    }];
    //executing https GET request
    [dataTask resume];
}
//////////////////////////////////////////////////////////////////////////////////////////

//method to diaplsy message
- (void)showMessage:(NSString *)message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    //Add Buttons
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    
                                }];
    //Add your buttons to alert controller
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}
////////////////////////////////////////////////////////////////////////////////////////

//method to parse json data
-(void)parsejson:(NSDictionary *)json
{
    titles=[[NSMutableArray alloc]init];
    description=[[NSMutableArray alloc]init];
    if ([[json objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray *articles=[json objectForKey:@"articles"];
        for(NSDictionary *data in articles)
        {
            [titles addObject:[data objectForKey:@"title"]];
            NSString *des=[data objectForKey:@"description"];
            if (des==[NSNull null]) {
                [description addObject:@""];
            }else{
            [description addObject:[data objectForKey:@"description"]];
            }
        }
        self.mainview.hidden=false;
        [self.tableview reloadData];
    }else{
        NSLog(@"status false");
        [self showMessage:[json objectForKey:@"message"]];
    }
}
/////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//////////////////////////////////////////////////////////////////////////////////////////





//table view delegate methods
//called when a row is tapped by the user
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings setObject:[description objectAtIndex:indexPath.row] forKey:@"description"];
    [settings synchronize];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"description"];
    [self presentViewController:vc animated:YES completion:NULL];
}
////////////////////////////////////////////////////////


//returns the number of rows in section of the table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returning total numbers of article titles received from the web api
    return titles.count;
}
////////////////////////////////////////////////////////
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
/////////////////////////////////////////////////////////////////




//populating data in each row/cell of the table view of article titles
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Customcell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell"];
    // Configure Cell
    cell.title_link.text=[titles objectAtIndex:indexPath.row];
    return cell;
}
//////////////////////////////////////////////////////////////////////////
@end
