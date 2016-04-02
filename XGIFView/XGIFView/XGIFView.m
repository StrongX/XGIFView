//
//  XGIFView.m
//  XGIFView
//
//  Created by xlx on 16/3/31.
//  Copyright © 2016年 xlx. All rights reserved.
//

#import "XGIFView.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>

@implementation XGIFView
{
    float selfWidth;
    float selfHeight;
    NSURL *gifURL;
    NSMutableArray *imageArray;
    NSMutableArray *delayTimes;
    CGFloat totalTime;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    selfWidth = frame.size.width;
    selfHeight = frame.size.height;
    imageArray = [@[] mutableCopy];
    delayTimes = [@[] mutableCopy];
    totalTime = 0;
    return self;
}


-(void)setGifImageWithLocalName:(NSString *)gifImageWithLocalName{
    _gifImageWithLocalName = gifImageWithLocalName;
    gifURL = [[NSBundle mainBundle] URLForResource:gifImageWithLocalName withExtension:@"gif"];
    [self createGIFFrames];
}

-(void)setGifNetWorkURL:(NSString *)gifNetWorkURL{
    _gifNetWorkURL = gifNetWorkURL;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filename = [XGIFView getmd5WithString:gifNetWorkURL];
    NSString *localPath = [NSString stringWithFormat:@"%@/Library/Caches/XGIF",NSHomeDirectory()];
    if([manager fileExistsAtPath:localPath]){
        localPath = [NSString stringWithFormat:@"%@/%@.gif",localPath,filename];
        if ([manager fileExistsAtPath:localPath]) {
            gifURL = [NSURL fileURLWithPath:localPath];
            [self createGIFFrames];
        }else{
            [self downloadGifFromNetWork];
        }
    }else{
        [manager createDirectoryAtPath:localPath withIntermediateDirectories:true attributes:nil error:nil];
        [self downloadGifFromNetWork];
        
    }
}
-(void)downloadGifFromNetWork{
    NSString *filename = [XGIFView getmd5WithString:_gifNetWorkURL];
    NSString *localPath = [NSString stringWithFormat:@"%@/Library/Caches/XGIF/%@.gif",NSHomeDirectory(),filename];
    NSString *newStr = [_gifNetWorkURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:newStr];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak XGIFView *wself = self;
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [data writeToFile:localPath atomically:true];
            gifURL = [NSURL fileURLWithPath:localPath];
            [wself createGIFFrames];
        });
        
    }];
    [task resume];
   
}
-(void)createGIFFrames{
    CFURLRef url = (__bridge CFURLRef)gifURL;
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    size_t imageCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < imageCount; ++i) {
        
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [imageArray addObject:(__bridge id)frame];
        CGImageRelease(frame);
        NSDictionary *sourceDict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        NSNumber *width = [sourceDict valueForKey:(NSString *)kCGImagePropertyPixelWidth];
        NSNumber *height = [sourceDict valueForKey:(NSString *)kCGImagePropertyPixelHeight];
        if (selfWidth/selfHeight != width.floatValue/height.floatValue) {
            [self setFrameFitTosacle:width.floatValue height:height.floatValue];
        }
        NSDictionary *gifDict = [sourceDict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        NSNumber *time = [gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime];
        [delayTimes addObject:time];
        totalTime += time.floatValue;
    }
    [self showGifAnimate];
}

-(void)showGifAnimate{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    CGFloat currentTime = 0;
    NSMutableArray *timesKey = [@[]mutableCopy];
    for (int i = 0; i < delayTimes.count; ++i) {
        [timesKey addObject:[NSNumber numberWithFloat:(currentTime / totalTime)]];
        currentTime += [delayTimes[i] floatValue];
    }
    [animation setKeyTimes:timesKey];
    NSMutableArray *imagesKey = [@[]mutableCopy];
    for (int i = 0; i < imageArray.count; ++i) {
        [imagesKey addObject:imageArray[i]];
    }
    [animation setValues:imagesKey];
    animation.duration = totalTime;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = false;
    [self.layer addAnimation:animation forKey:@"XGIFAnimate"];
    
}
-(void)setFrameFitTosacle:(CGFloat)width height:(CGFloat)height{
    CGRect frame = self.frame;
    if (width>height) {
        selfHeight = selfHeight*(height/width);
    }else{
        selfWidth = selfWidth*(width/height);
    }
    frame.size = CGSizeMake(selfWidth, selfHeight);
    self.frame = frame;
}
+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];
    }
    return [outPutStr lowercaseString];
}
+(void)clearCache{
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/XGIF",NSHomeDirectory()];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileNames = [manager contentsOfDirectoryAtPath:filePath error:nil];
    for (NSString *name in fileNames) {
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",filePath,name] error:nil];
    }
}
@end
