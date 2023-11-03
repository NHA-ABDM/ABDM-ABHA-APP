//
//  QRCaptureViewFactory.m
//  Runner
//
//  Created by xzp 2020/5/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "QRCaptureViewFactory.h"
#import "QRCapturePlatformView.h"

@interface QRCaptureViewFactory ()
    
@property(nonatomic, strong) NSObject<FlutterPluginRegistrar>* registrar;
    
@end

@implementation QRCaptureViewFactory

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
    }
    return self;
}

    
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[QRCapturePlatformView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args registrar:self.registrar];
}

@end
