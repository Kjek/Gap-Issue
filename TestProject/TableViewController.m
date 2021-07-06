//
//  TableViewController.m
//  TestProject
//
//

#import "TableViewController.h"
#import "CatFactService.h"
#import "LabelTableViewCell.h"

@interface TableViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *cellIdentifiers;
@property (nonatomic, strong) NSArray *headers;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh {
    if (self.shouldFetchData) { // When doing any API calls the section gets a height for some reason.
        [self fetchCatFacts];
    } else {
        [self populateData:@[@{@"text": @"Test data and stuff"}, @{@"text": @"Test data and stuff"}, @{@"text": @"Test data and stuff"}]];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

- (void)fetchCatFacts {
    [[CatFactService sharedInstance] fetchCatFacts:^(id _Nullable responseObject) {
        [self populateData:responseObject];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError * _Nullable error) {

    }];
}

- (void)populateData:(NSArray *)responseObject {
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *cellIdentifiers = [NSMutableArray array];
    
    for (NSDictionary *catFact in responseObject) {
        [items addObject:catFact[@"text"]];
        [cellIdentifiers addObject:@"LabelTableViewCell"];
    }
    
    self.headers = @[@"Some cat facts"];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

@end
