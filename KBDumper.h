#import <UIKit/UIKit.h>
#import "UIKBTree.h"

typedef enum {
    UIKBTreeNothing = 0,
    UIKBTreeKeyboard = 1,
    UIKBTreeKeyplane = 2,
    UIKBTreeKeylayout = 3,
    UIKBTreeKeyset = 4,
    UIKBTreeGeometrySet = 5,
    UIKBTreeAttrrbiteSet = 6,
    UIKBTreeKeyRow = 7,
    UIKBTreeGeometryList= 7,
    UIKBTreeKey = 8,
} UIKBTreeType;


@interface KBDumper : NSObject
- (id)init;
- (void)parseKeyboardName;
- (BOOL)verify;
- (UIKBTree *)loadKeyboardWithName:(NSString *)name;
- (UIKBTree *)getSubtree:(UIKBTree *)tree withType:(UIKBTreeType)type name:(NSString *)name;
- (NSMutableArray *)getSubtrees:(UIKBTree *)tree withType:(UIKBTreeType)type;
- (NSMutableDictionary *)loadConfigFromPath:(NSString *)path;
- (void)setupGeometryRowConfig:(NSArray *)geometryRows target:(NSMutableDictionary *)targetDict;
@property (nonatomic, retain) NSMutableArray *keyboardNames;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSMutableDictionary *config;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) UIKBTree *keyboard;
@property (nonatomic, retain) NSMutableDictionary *parentInfo;
@end