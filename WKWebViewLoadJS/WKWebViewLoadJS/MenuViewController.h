//
//  MenuViewController.h
//  WKWebViewLoadJS
//
//  Created by zhanggui on 2018/2/6.
//  Copyright © 2018年 zhanggui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuModel;

typedef void(^chooseFinishedBlock) (MenuModel *model);
@interface MenuViewController : UITableViewController


- (void)didFinishLoadingTableOfContents:(id)msg;

@property (nonatomic,copy)chooseFinishedBlock myBlock;
- (void)chooseFinishWithBlock:(chooseFinishedBlock)block;
@end
