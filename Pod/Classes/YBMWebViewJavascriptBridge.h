//
//  YBMWebViewJavascriptBridge.h
//  Pods
//
//  Created by yp-tc-m-2549 on 16/1/15.
//
//

#import <Foundation/Foundation.h>

#define YBM_WEBVIEW_BRIDGE_OBJECT NSObject<UIWebViewDelegate>
#define YBM_WEBVIEW_DELEGATE_TYPE id<UIWebViewDelegate>


@interface YBMWebViewJavascriptBridge : YBM_WEBVIEW_BRIDGE_OBJECT

+ (instancetype)bridgeForWebView:(UIWebView *)webView webViewDelegate:(YBM_WEBVIEW_DELEGATE_TYPE)delegate;

@end
