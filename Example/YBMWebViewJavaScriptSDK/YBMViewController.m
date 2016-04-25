//
//  YBMViewController.m
//  YBMWebViewJavaScriptSDK
//
//  Created by junwen.deng on 01/11/2016.
//  Copyright (c) 2016 junwen.deng. All rights reserved.
//

#import "YBMViewController.h"
#import "YBMWebViewJavaScriptSDK-umbrella.h"


@interface YBMViewController ()<UIWebViewDelegate>

@property (strong, nonatomic)YBMWebViewJavascriptBridge *bridge;

@end

@implementation YBMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.bridge = [YBMWebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self];
    [self.view addSubview:webView];
    [self loadExample:webView];
}



- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}
- (void)loadExample:(UIWebView *)webview{

    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    //
    //    [webView loadRequest:request];
    //
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webview loadHTMLString:appHtml baseURL:baseURL];
}

- (NSDictionary *)testFunction:(NSDictionary *)reqeustData{
    NSLog(@"%@水电费水电费是",reqeustData);
    return nil;
}

- (void)webBack{
    NSLog(@"sdfsdf");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
