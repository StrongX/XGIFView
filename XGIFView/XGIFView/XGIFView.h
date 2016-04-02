//
//  XGIFView.h
//  XGIFView
//
//  Created by xlx on 16/3/31.
//  Copyright © 2016年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGIFView : UIView

/**
 *  清除缓存
    Clear cache create by XGIFView
 */
+(void)clearCache;
/**
 *  从本地加载Gif
    Load from local
 */
@property (nonatomic, strong) NSString  *gifImageWithLocalName;

/**
 *  从网络端加载Gif
    Load from the network
 */
@property (nonatomic, strong) NSString *gifNetWorkURL;

@end
