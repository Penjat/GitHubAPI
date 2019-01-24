//
//  ViewController.m
//  GitHubAPI
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic)NSArray<NSDictionary *> *myRepos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/Penjat/repos"]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSArray *repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        self.myRepos = repos;
        
        for (NSDictionary *repo in repos) { // 4
            
            NSString *repoName = repo[@"name"];
            NSLog(@"repo: %@", repoName);
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // This will run on the main queue
                [self.myTableView reloadData];
            }];
            
        }
    }];
    
    [dataTask resume]; // 6
    
}




- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.text =  self.myRepos[indexPath.row][@"name"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myRepos.count;
}



















@end
