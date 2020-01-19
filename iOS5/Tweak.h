#import "../UIKBTree.h"

#define SETTINGS_PATH @"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.plist"

typedef enum {
	ZhuyinLayoutNative,
	ZhuyinLayoutCompact,
	ZhuyinLayoutComputer,
	ZhuyinLayoutEten,
} ZhuyinLayout;

//==============================================================================
static ZhuyinLayout layout;
static BOOL isZhuyin;
static BOOL shiftMod;

static NSDictionary *etenMap = [NSDictionary dictionaryWithObjectsAndKeys:
								@"B", @"ㄅ", @"P", @"ㄆ", @"M", @"ㄇ", @"F", @"ㄈ",
								@"D", @"ㄉ", @"T", @"ㄊ", @"N", @"ㄋ", @"L", @"ㄌ",
								@"V", @"ㄍ", @"K", @"ㄎ", @"H", @"ㄏ",
								@"G", @"ㄐ", @"7", @"ㄑ", @"C", @"ㄒ",
								@",", @"ㄓ", @".", @"ㄔ", @"/", @"ㄕ", @"J", @"ㄖ",
								@";", @"ㄗ", @"'", @"ㄘ", @"S", @"ㄙ",
								@"E", @"ㄧ", @"X", @"ㄨ", @"U", @"ㄩ",
								@"A", @"ㄚ", @"O", @"ㄛ", @"R", @"ㄜ", @"Q", @"ㄟ",
								@"I", @"ㄞ", @"W", @"ㄝ", @"Z", @"ㄠ", @"Y", @"ㄡ",
								@"8", @"ㄢ", @"9", @"ㄣ", @"0", @"ㄤ", @"-", @"ㄥ", @"=", @"ㄦ",
								@"1", @"˙", @"2", @"ˊ", @"3", @"ˇ", @"4", @"ˋ",nil];

NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGS_PATH];

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

@interface UIKBTree (iOS5)
- (void)setKeyString:(NSString *)setKeyString;
@end

@interface UIKBShape
- (void)setFrame:(CGRect)frame;
- (void)setPaddedFrame:(CGRect)frame;
- (void)setKeyFrame:(CGRect)frame;
@end