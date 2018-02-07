//
//  ViewController.m
//  WKWebViewLoadJS
//
//  Created by zhanggui on 2018/2/6.
//  Copyright © 2018年 zhanggui. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "MenuViewController.h"
#import "MenuModel.h"
@interface ViewController ()<WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong)WKWebView *webView;

@property (nonatomic,strong)MenuViewController *menuVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
     _menuVC = [[MenuViewController alloc] init];
}
- (IBAction)menuAction:(id)sender {
//    [_menuVC chooseFinishWithBlock:^(MenuModel *model) {
//        NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:model.url]];
//        [self.webView loadRequest:request];
//    }];
    
    
    [self.navigationController pushViewController:_menuVC animated:YES];
}
#pragma mark - WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.body);
    if ([message.name isEqualToString:@"didFetchTableOfContents"]) {
        [_menuVC didFinishLoadingTableOfContents:message.body];
    }

}


#pragma mark - private method
- (void)addUserScriptToUserContentController:(WKUserContentController *)userContentController {
    NSString *hideTableContentScriptString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"customjs" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:hideTableContentScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    [userContentController addUserScript:script];
    
    NSString *getMenuString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"fetch" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *fetchScript = [[WKUserScript alloc] initWithSource:getMenuString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:fetchScript];
    
    [userContentController addScriptMessageHandler:self name:@"didFetchTableOfContents"];
}
#pragma makr - UIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    completionHandler();
}

#pragma mark - Lazy load
- (WKWebView *)webView {
    if (!_webView) {

        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        NSString *myScriptSource =@"alert('hello,world')";
//        WKUserContentController *contentController = [[WKUserContentController alloc] init];
//
//        WKUserScript *myUserScript = [[WKUserScript alloc] initWithSource:myScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
//
//        [contentController addUserScript:myUserScript];
        
        [self addUserScriptToUserContentController:config.userContentController];
        
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.allowsLinkPreview = YES;
        _webView.UIDelegate = self;

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [_webView loadRequest:request];
        request = nil;
    }
    return _webView;
}

@end
