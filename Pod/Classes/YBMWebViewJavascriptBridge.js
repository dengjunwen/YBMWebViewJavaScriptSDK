YBMWebViewJavascriptBridge = {
callHandler: function(handlerName, jsonData, callback) {
    try {
        var json = eval("(" + jsonData + ")");
        jsonData = json;
    } catch(e) {}
    var json = {
        'handlerName': handlerName,
        'data': jsonData
    };
    window.location = ("objc://?" + JSON.stringify(json));
    objcCallBack = function(response) {
        callback(response);
    }
},
testF: function() {
    alert("haha")
}
};