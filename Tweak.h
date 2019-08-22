#import <objc/runtime.h>
#import <dlfcn.h> 
#import <firmware.h>
#import <substrate.h>
#import "Tweak.h"

#define iOS11 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_11_0
// #define iOS12 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_12_0

@interface CPBitmapStore : NSObject
- (id)allGroups;
- (void)removeImagesInGroups:(id)groups;
- (void)purge;
@end

@interface UIKBTree : NSObject
@property(retain, nonatomic) NSMutableArray* subtrees;
@property(retain, nonatomic) NSMutableDictionary* properties;
@property(retain, nonatomic) NSString* name;
@property(nonatomic) int type;
- (UIKBTree *)initWithType:(int)type withName:(NSString *)name withProperties:(NSDictionary *)properties withSubtrees:(NSMutableArray *)subtrees withCache:(id)cache;
- (void)setRepresentedString:(NSString *)string;
- (NSString *)representedString;
- (void)setDisplayString:(NSString *)displayString;
- (NSString *)displayString;
- (void)setPaddedFrame:(CGRect)paddedFrame;
- (void)setFrame:(CGRect)frame;
- (CGRect)frame;
- (CGRect)paddedFrame;
- (BOOL)setObject:(id)object forProperty:(NSDictionary *)property;
- (id)variantDisplayString;
- (id)variantPopupBias;
- (int)variantType;
- (void)setName:(NSString *)name;
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

static NSString *licensePath = @"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.license.plist"; 
static NSString *demoPath = @"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.demo.plist"; 
static BOOL showAlert = YES;
NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.plist"];
static double ss;