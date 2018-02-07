# WKWebViewLoadJS
#### 描述
这里主要是以baidu.com为例，然后通过WKWebView进行加载，将自己写的js注入到baidu.com，然后将菜单(关注、新闻、小说...)单独提出来，放到了Menu里面。  
#### 样例
在手动添加js前,有关注、新闻、小说等菜单：    
![formal](https://raw.githubusercontent.com/ScottZg/MarkDownResource/master/wkwebviewloadjs/webformal.gif)   
将customjs.js和fetch.js添加到WKWebView之后，去掉这些菜单，并且将菜单数据放到menu里面：   
![web view load local js](https://raw.githubusercontent.com/ScottZg/MarkDownResource/master/wkwebviewloadjs/webloadjs.gif)   

#### 实现   
主要使用了WKUserScript，具体实现如下：    

```objective-c
- (void)addUserScriptToUserContentController:(WKUserContentController *)userContentController {
    NSString *hideTableContentScriptString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"customjs" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:hideTableContentScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    [userContentController addUserScript:script];
    
    NSString *getMenuString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"fetch" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *fetchScript = [[WKUserScript alloc] initWithSource:getMenuString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:fetchScript];
    
    [userContentController addScriptMessageHandler:self name:@"didFetchTableOfContents"];
}
```
在获取数据的时候使用的是messageHandler，这里的handler的name很重要，对应着fetch.js里面的：   

```html
webkit.messageHandlers.didFetchTableOfContents.postMessage(entries);
```

#### 参考  
1.[WWDC](https://developer.apple.com/videos/play/wwdc2014/206/)

