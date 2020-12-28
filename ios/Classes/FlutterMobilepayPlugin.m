#import "FlutterMobilepayPlugin.h"
#if __has_include(<flutter_mobilepay/flutter_mobilepay-Swift.h>)
#import <flutter_mobilepay/flutter_mobilepay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_mobilepay-Swift.h"
#endif

@implementation FlutterMobilepayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMobilepayPlugin registerWithRegistrar:registrar];
}
@end
