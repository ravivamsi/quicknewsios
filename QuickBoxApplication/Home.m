//
//  Home.m
//  QuickBoxApplication
//
//  Created by Media park  on 18/05/2017.
//  Copyright © 2017 QuickBox. All rights reserved.
//

#import "Home.h"

@interface Home ()
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *sources;
@property (weak, nonatomic) IBOutlet UIImageView *country_click;
@property (weak, nonatomic) IBOutlet UIImageView *sources_click;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (weak, nonatomic) IBOutlet UIView *countryviewviewclick;
@property (weak, nonatomic) IBOutlet UIView *sourcesviewclick;


@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _loader.hidden=true;
    
    //initialyzing data structures
    source_id=[[NSMutableArray alloc]init];
    source_name=[[NSMutableArray alloc]init];
    country_id=[[NSMutableArray alloc]init];
    country_name=[[NSMutableArray alloc]init];
    [self getsources];
     [self loadCountries];
    
    //implement click listner on show sources drop down image
    UITapGestureRecognizer *rtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourcesShow)];
    rtap.numberOfTapsRequired = 1;
    _sources_click.userInteractionEnabled = YES;
    [_sources_click addGestureRecognizer:rtap];
    //////////////////////////////////////////////////////////////
    
    
    //implement click listner on show sources whole view
    UITapGestureRecognizer *rtap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourcesShow)];
    rtap3.numberOfTapsRequired = 1;
    _sourcesviewclick.userInteractionEnabled = YES;
    [_sourcesviewclick addGestureRecognizer:rtap3];
    //////////////////////////////////////////////////////////////
    
    
    
    //implement click listner on show countries drop down image
    UITapGestureRecognizer *rtap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCountries)];
    rtap1.numberOfTapsRequired = 1;
    _country_click.userInteractionEnabled = YES;
    [_country_click addGestureRecognizer:rtap1];
    ////////////////////////////////////////////////////////////////
   
   
    //implement click listner on show countries whole image view
    UITapGestureRecognizer *rtap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCountries)];
    rtap2.numberOfTapsRequired = 1;
    _countryviewviewclick.userInteractionEnabled = YES;
    [_countryviewviewclick addGestureRecognizer:rtap2];
    
   /* self.countryviewviewclick.layer.borderWidth = 1;
    
    self.countryviewviewclick.layer.borderColor = UIColor.blackColor.CGColor;
    self.countryviewviewclick.layer.cornerRadius=5;
    self.countryviewviewclick.layer.masksToBounds=true;
*/
    }
-(void)showCountries
{

    UIAlertController *departureActnSht = [UIAlertController alertControllerWithTitle:@"Select Country"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    for (int j =0 ; j<country_name.count; j++)
    {
        NSString *titleString = [country_name objectAtIndex:j];
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [_country setText:[action title]];
            [self reloadCountries:[action title]];
            
        }];
        [departureActnSht addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        // [self dismissViewControllerAnimated:departureActnSht completion:nil];
    }];
    [departureActnSht addAction:cancelAction];
    
    [self presentViewController:departureActnSht animated:YES completion:nil];

}

-(void)loadCountries
{

    [country_name addObject:@"Australia"];
    [country_name addObject:@"Germany"];
    [country_name addObject:@"United Kingdom"];
    [country_name addObject:@"India"];
    [country_name addObject:@"Italy"];
    [country_name addObject:@"United States of America"];
    
    [country_id addObject:@"au"];
        [country_id addObject:@"de"];
        [country_id addObject:@"gb"];
        [country_id addObject:@"in"];
        [country_id addObject:@"it"];
        [country_id addObject:@"us"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//web api methods
-(void)getsources
{
    _loader.hidden=false;
    [_loader startAnimating];
  
    NSError *error;
   //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    //Create an URLRequest
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://newsapi.org/v1/sources"];
    NSURL *url = components.URL;
    // NSURL *url = [NSURL URLWithString:@"https://api.sportarb.com/account/settings"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //Create POST Params and add it to HTTPBody
    // NSString *params = [NSString stringWithFormat:@"app=0.1.0&payload=%@",encryptedBase64Data];
    [urlRequest setHTTPMethod:@"GET"];
    // [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDict);
        
        _loader.hidden=true;
        [_loader stopAnimating];
        [self parsejson:responseDict];
    }];
    [dataTask resume];
    
}

                                 
-(void)reloadCountries:(NSString *)title
{
    
    NSString *c_id=[[NSString alloc]init];
    for(int i=0;i<country_name.count;i++)
    {
        if ([title isEqualToString:[country_name objectAtIndex:i]]) {
            c_id=[country_id objectAtIndex:i];
            break;
        }
    
    }
    NSLog(@"id%@",c_id);
    
    
    
    _loader.hidden=false;
    [_loader startAnimating];
    //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    //Create an URLRequest
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://newsapi.org/v1/sources"];
    NSURLQueryItem *search = [NSURLQueryItem queryItemWithName:@"country" value:c_id];
    components.queryItems = @[ search ];
    NSURL *url = components.URL;
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //Create POST Params and add it to HTTPBody
    // NSString *params = [NSString stringWithFormat:@"app=0.1.0&payload=%@",encryptedBase64Data];
    [urlRequest setHTTPMethod:@"GET"];
    // [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDict);
        
        _loader.hidden=true;
        [_loader stopAnimating];
        [self parsejson:responseDict];
    }];
    [dataTask resume];

}

-(void)parsejson:(NSDictionary *)json
{

    source_name=[[NSMutableArray alloc ]init];
    source_id=[[NSMutableArray alloc]init];
    if ([[json objectForKey:@"status"] isEqualToString:@"ok"]) {
        NSArray *sources=[json objectForKey:@"sources"];
        for(NSDictionary *data in sources)
        {
            [source_name addObject:[data objectForKey:@"name"]];
            [source_id addObject:[data objectForKey:@"id"]];
        }
        [_sources setText:@"Select Source"];
        
    }else{
        NSLog(@"status not ok");
    }

}

- (IBAction)loadNews:(id)sender {
    
    int count=0;
    NSUserDefaults *settimgs=[NSUserDefaults standardUserDefaults];
    for(int i=0;i<source_name.count;i++)
    {
        if ([[source_name objectAtIndex:i] isEqualToString:_sources.text]) {
            count++;
            [settimgs setObject:[source_id objectAtIndex:i] forKey:@"s_id"];
            [settimgs synchronize];
            NSLog(@"source_id= %@",[source_id objectAtIndex:i]);
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"listofarticles"];
            [self presentViewController:vc animated:YES completion:NULL];
            break;
            
        }
    }
    if (count==0) {
        [self showMessage:@"Please Select a Source"];
    }
}
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

- (void)sourcesShow {
    UIAlertController *departureActnSht = [UIAlertController alertControllerWithTitle:@"Select Source"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    for (int j =0 ; j<source_name.count; j++)
    {
        NSString *titleString = [source_name objectAtIndex:j];
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [_sources setText:[action title]];
            
        }];
        [departureActnSht addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        // [self dismissViewControllerAnimated:departureActnSht completion:nil];
    }];
    [departureActnSht addAction:cancelAction];
    
    [self presentViewController:departureActnSht animated:YES completion:nil];
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
