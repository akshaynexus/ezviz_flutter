#import "FlutterEzvizPlugin.h"
#import <ezviz_flutter/ezviz_flutter-Swift.h>

@implementation FlutterEzvizPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    EzvizViewFactory *ezvizViewFactory = [[EzvizViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:ezvizViewFactory withId:@"ezviz_flutter_player"];
    [SwiftFlutterEzvizPlugin registerWithRegistrar:registrar];
}
@end
