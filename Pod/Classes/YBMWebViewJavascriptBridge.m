//
//  YBMWebViewJavascriptBridge.m
//  Pods
//
//  Created by yp-tc-m-2549 on 16/1/15.
//
//

#import "YBMWebViewJavascriptBridge.h"
#import "NSString+jsonString.h"
#import <objc/runtime.h>

#define KCustomScheme @"objc"

@implementation YBMWebViewJavascriptBridge
{
    __weak UIWebView *_weakWebView;
    __weak id _webViewDelegate;
}


+ (instancetype)bridgeForWebView:(UIWebView *)webView webViewDelegate:(YBM_WEBVIEW_DELEGATE_TYPE)delegate{
    
    YBMWebViewJavascriptBridge *bridge = [[YBMWebViewJavascriptBridge alloc] init];
    
    [bridge setupBridgeWithWebView:webView webViewDelegate:delegate];
    
    return bridge;
}

- (void)setupBridgeWithWebView:(UIWebView *)webView webViewDelegate:(YBM_WEBVIEW_DELEGATE_TYPE)delegate{
    
    _weakWebView = webView;
    
    _webViewDelegate = delegate;
    
    [_weakWebView setDelegate:self];
}

#pragma mark --UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewDelegate webView:webView didFailLoadWithError:error];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([self isObjCHandle:request.URL]) {
    
        NSString *jsonStr = [request.URL resourceSpecifier];

        jsonStr = [jsonStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsDictionary = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        NSString *selName = jsDictionary[@"handlerName"];
        
        NSLog(@"%@",selName);
        
        NSDictionary *selData = jsDictionary[@"data"];
        
        if ([selData isEqual:[NSNull null]]) {
            selData = nil;
        }
        
        if (_webViewDelegate && [_webViewDelegate respondsToSelector:NSSelectorFromString(selName)]) {
            ;
            //调用方法
            id response = [self addTarget:_webViewDelegate performFunctionWithName:selName withObject:selData];
            
            [self evaluatingDatawithWebView:webView withResponse:response];

        }else{
            NSLog(@"未添加数据代理");
        }
        return NO;
    }
    
    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (id)addTarget:(id)target performFunctionWithName:(NSString *)functionName withObject:(id)object{
    if (target  && [target respondsToSelector:NSSelectorFromString(functionName)]) {
        SEL selector = NSSelectorFromString(functionName);
        Method method = class_getInstanceMethod([target class], selector);
        const char *returnType = method_copyReturnType(method);
        IMP imp = [target methodForSelector:selector];
        char *voidType = "v";
        if (strcmp(returnType, voidType) == 0) {
            //无返回值类型
            void (*func)(id, SEL, NSDictionary *) = (void *)imp;
            func(target, selector, object);
        }else{
            id (*func)(id, SEL, NSDictionary *) = (void *)imp;
            return func(target, selector, object);
        }
        return nil;
        //这个方法有警告，用上面的方法代替，出去警告
        //[self performSelector:NSSelectorFromString(functionName) withObject:requestData];
    }
    return nil;
}

- (void)evaluatingDatawithWebView:(UIWebView *)webView withResponse:(id)response{
   
    if (_weakWebView != webView) {
        return;
    }
    if (!response) {
        return;
    }
    NSString *jsonString = [NSString jsonStringWithObject:response];
        
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:objcCallBack('%@')",jsonString]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *jsStr = @"YBMWebViewJavascriptBridge = {"
    "callHandler : function(handlerName,jsonData,callback){"
    "try{"
    "var json = eval(\"(\"+jsonData+\")\");jsonData = json;"
    "}"
    "catch(e){"
    "}"
    "var json = {"
    "'handlerName':handlerName,'data':jsonData"
    "};"
    "objcCallBack = function(response){"
    "callback(response);"
    "};"
    "window.location = (\"objc:\"+JSON.stringify(json));"
    "}"
    "};";
    

    [self evaluatingJavaScript:jsStr];
    
    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (_webViewDelegate && [_webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewDelegate webViewDidStartLoad:webView];
    }
}

- (NSString *)evaluatingJavaScript:(NSString *)javaScript{
    return [_weakWebView stringByEvaluatingJavaScriptFromString:javaScript];
}

- (BOOL)isObjCHandle:(NSURL *)url{
    
    if ([[url scheme] isEqualToString:KCustomScheme]) {
        return YES;
    }else{
        return NO;
    }
    
}

@end
