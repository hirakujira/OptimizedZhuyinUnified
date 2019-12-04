#import <objc/runtime.h>
#import <dlfcn.h> 
#import <firmware.h>
#import <substrate.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/SpringBoard.h>
#import "Tweak.h"
#import "KBDumper.h"

#define iOS11 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_11_0
#define SETTINGS_PATH @"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.plist"

@interface CPBitmapStore : NSObject
- (id)allGroups;
- (void)removeImagesInGroups:(id)groups;
- (void)purge;
@end

@interface UIKeyboardCache : NSObject
+ (id)sharedInstance;
@end

@interface CALayer (OptimizedZhuyin)
-(void) _display;
@end

typedef enum {
	ZhuyinLayoutNative,
	ZhuyinLayoutCompress,
	ZhuyinLayoutComputer,
	// ZhuyinLayoutEten,
} ZhuyinLayout;

//==============================================================================
static ZhuyinLayout layout;
static BOOL isZhuyin;
static BOOL isLandscape;

static KBDumper *dumper;
static BOOL showVerifyError = NO;

NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.plist"];
static double ss;