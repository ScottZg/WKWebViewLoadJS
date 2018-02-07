//
//  MenuViewController.m
//  WKWebViewLoadJS
//
//  Created by zhanggui on 2018/2/6.
//  Copyright © 2018年 zhanggui. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuModel.h"
#import <SafariServices/SafariServices.h>
static NSString *CellIdentifier = @"Cellid";
static NSArray *makeEntrys(NSArray *entries) {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:entries.count];
    for (id entry in entries) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        id title = entry[@"title"];
        if (![title isKindOfClass:[NSString class]]) {
            continue;
        }
        id url= entry[@"urlString"];
        if (![url isKindOfClass:[NSString class]]) {
            continue;
        }
        MenuModel *model = [[MenuModel alloc] init];
        model.title = title;
        model.url = url;
        [arr addObject:model];
    }
    return arr;
}

@interface MenuViewController ()

@property (nonatomic,strong)NSArray *contentArr;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didFinishLoadingTableOfContents:(id)msg {
    if ([msg isKindOfClass:[NSArray class]]) {
        self.contentArr = makeEntrys(msg);
        [self.tableView reloadData];
    }else {
        NSLog(@"system error");
    }
    
}
- (void)chooseFinishWithBlock:(chooseFinishedBlock)block {
    self.myBlock = block;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.contentArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuModel *model =self.contentArr[indexPath.row];
    SFSafariViewController *controllr =[[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:model.url]];
    [self presentViewController:controllr animated:YES completion:nil];
//    [self.navigationController pushViewController:controllr animated:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    MenuModel *model = self.contentArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}
@end
