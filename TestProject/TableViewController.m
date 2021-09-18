//
//  TableViewController.m
//  TestProject
//
//

#import "TableViewController.h"
#import "LabelTableViewCell.h"

@interface TableViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *cellIdentifiers;
@property (nonatomic, strong) NSArray *headers;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shouldFetchData ? @"Padding issue" : @"No padding issue";
    if (@available(iOS 15.0, *)) {
        [self.tableView setSectionHeaderTopPadding:0.0f]; // Not working
    }
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];  // this work!
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh {
    if (self.shouldFetchData) { // When doing any API calls the section gets a height for some reason.
        [self fetchJokes];
    } else { // No network calls here doesn't give the section height
        [self populateData:@{@"setup": @"Test data and stuff", @"delivery": @"and more data"}];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

- (void)fetchJokes {
    NSString *dataUrl = @"https://v2.jokeapi.dev/joke/Programming?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&type=twopart";
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
      dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSData * responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            [self populateData:jsonArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    [downloadTask resume];
}

- (void)populateData:(NSDictionary *)responseObject {
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *cellIdentifiers = [NSMutableArray array];
    
    NSString *jokeText = [NSString stringWithFormat:@"%@\n\n%@", responseObject[@"setup"], responseObject[@"delivery"]];
    [items addObject:jokeText];
    [cellIdentifiers addObject:@"LabelTableViewCell"];
//    for (NSDictionary *joke in responseObject) {
//        NSString *jokeText = [NSString stringWithFormat:@"%@\n\n%@", joke[@"setup"], joke[@"delivery"]];
//        [items addObject:jokeText];
//        [cellIdentifiers addObject:@"LabelTableViewCell"];
//    }
    
    self.headers = self.shouldFetchData ? @[@"Some bad jokes"] : @[@"Some mock data"];
    self.items = @[items];
    self.cellIdentifiers = @[cellIdentifiers];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [[self.cellIdentifiers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell.mainLabel setText:item];
    [cell setUserInteractionEnabled:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

@end
