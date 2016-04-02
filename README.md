# XGIFView
this is a View which can show the GIF Image

![](https://github.com/StrongX/XGIFView/blob/master/XGIFView/gifDemo.gif)
> XGIFView can show the GIF Image from local resource or downLoad from netWork.
if you provide the http url, XGIFView can downLoad from netWork and save to local.

#install
you just need to downLoad the XGIFView from github and drag the XGIFView.h and XGIFView.m to your project.

#How to use
if you have the gif file in you project,you can do like this:
```
 XGIFView *gifView = [[XGIFView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
 gifView.gifImageWithLocalName = @"gifDemo";
 gifView.center = self.view.center;
 [self.view addSubview:gifView];
```
if you have a http url which is suffix with ‘.gif’,you can do like this:
```
XGIFView *gifView = [[XGIFView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
gifView.gifNetWorkURL = DemoURL;
gifView.center = self.view.center;
[self.view addSubview:gifView];
```
#clear cache
XGIFView will save the gif file from http url,and you can clear cache like this:
```
[XGIFView clearCache];
```
