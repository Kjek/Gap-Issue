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
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh {
    [self fetchCatFacts];
}

- (void)fetchCatFacts {
    [[CatFactService sharedInstance] fetchCatFacts:^(id _Nullable responseObject) {
        for (id item in responseObject) {
            
        }
        NSLog(@"Fetched cat fact");
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    NSString *text = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:section];
    if ([text length] > 0) {
        UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
        [headerIndexText.textLabel setTextColor:[UIColor blackColor]];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
