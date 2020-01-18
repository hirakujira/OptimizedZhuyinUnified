#import "KBDumper.h"
#import "TUIKeyboardLayoutFactory.h"
#import "firmware.h"

@implementation KBDumper
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.version = [NSString stringWithFormat:@"%.2f", kCFCoreFoundationVersionNumber];
        self.keyboardNames = [[NSMutableArray alloc] initWithArray:@[
                            @"iPhone-Portrait-Zhuyin",
                            @"iPhone-PortraitChoco-Zhuyin",
                            @"iPhone-PortraitTruffle-Zhuyin",
                            @"iPhone-Landscape-Zhuyin",
                            @"iPhone-Caymen-Zhuyin",
                            @"iPhone-LandscapeChoco-Zhuyin",
                            @"iPhone-LandscapeTruffle-Zhuyin"
                            ]];
        #ifdef __x86_64__
        self.filePath = @"/Users/Hiraku/Desktop/tw.hiraku.optimizedzhuyin.keyboardinfo.plist";
        #else
        self.filePath = @"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.keyboardinfo.plist";
        #endif
        self.config = [self loadConfigFromPath:self.filePath];
    }
    return self;
}

- (void)parseKeyboardName
{   
    for (NSString *keyboardName in self.keyboardNames)
    {
        self.keyboard = [self loadKeyboardWithName:keyboardName];

        NSMutableDictionary *keyboardInfo = [[NSMutableDictionary alloc] init];
        [self setupGeometryRowConfig:[self getSubtrees:self.keyboard withType:UIKBTreeGeometryList] target:keyboardInfo];

        if (!self.config[self.version])
        {
            self.config[self.version] = [[NSMutableDictionary alloc] init];
        }
        self.config[self.version][keyboardName] = keyboardInfo;
    }
    [self.config writeToFile:self.filePath atomically:YES];
}

- (NSMutableDictionary *)loadConfigFromPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return [[NSMutableDictionary alloc] init];
}

- (UIKBTree *)loadKeyboardWithName:(NSString *)name
{
    return [[NSClassFromString(@"TUIKeyboardLayoutFactory") sharedKeyboardFactory] keyboardWithName:name inCache:nil];
}

- (void)setupGeometryRowConfig:(NSArray *)geometryRows target:(NSMutableDictionary *)targetDict
{
    for (NSString *name in geometryRows)
    {
        NSLog(@"OptimizedZhuyin rows %@", geometryRows);
        if ([name hasSuffix:@"Eleven-on-Eleven-Geometry-List"])
        {
            targetDict[@"Row1-Geometry-List"] = name;
        }
        else if ([name hasSuffix:@"Five-Row-Zhuyin-Row-Two-Geometry-List"])
        {
            targetDict[@"Row2-Geometry-List"] = name;
        }
        else if ([name hasSuffix:@"Five-Row-Zhuyin-Row-Three-Geometry-List"])
        {
            targetDict[@"Row3-Geometry-List"] = name;
        }
        else if ([name hasSuffix:@"Left-Aligned-Ten-on-Eleven-Geometry-List"])
        {
            targetDict[@"Row4-Geometry-List"] = name;
        }
        else if ([name hasSuffix:@"Eleven-Delete-Geometry-List"]) 
        {
            targetDict[@"Delete-Geometry-List"] = name;
        }
    }
}

- (NSMutableArray *)getSubtrees:(UIKBTree *)tree withType:(UIKBTreeType)type {
    NSMutableArray *subtrees = [[NSMutableArray alloc] init];

    if (tree.type == UIKBTreeKeyboard)
    {
        self.parentInfo = [[NSMutableDictionary alloc] init];
    }
    
    for (UIKBTree *subtree in tree.subtrees)
    {
        if ([subtree respondsToSelector:@selector(type)])
        {
            if (subtree.type == type)
            {
                // NSLog(@"Get Target Subtree type: %d, Name: %@", subtree.type, subtree);
                self.parentInfo[subtree.name] = tree.name;
                [subtrees addObject:subtree.name];
            }
            else if (subtree.type > type)
            {
                continue;
            }
            else if (subtree.subtrees.count)
            {
                // NSLog(@"Get Parent type: %d, Name: %@", subtree.type, subtree);
                NSMutableArray *next_subtrees = [self getSubtrees:subtree withType:type];
                if (!next_subtrees.count)
                {
                    continue;
                }
                [subtrees addObjectsFromArray:next_subtrees];
            }
        }
    }
    return subtrees;
}

- (UIKBTree *)getSubtree:(UIKBTree *)tree withType:(UIKBTreeType)type name:(NSString *)name {
    for (UIKBTree *subtree in tree.subtrees)
    {
        if ([subtree respondsToSelector:@selector(name)])
        {
            if (subtree.type == type && [subtree.name rangeOfString:name].location != NSNotFound) {
            // NSLog(@"Get Target Subtree type: %d, Name: %@", subtree.type, subtree);
                return subtree;
            }
            else if (subtree.type > type)
            {
                continue;
            }
            else {
                if (subtree.subtrees.count)
                {
                    UIKBTree *result = [self getSubtree:subtree withType:type name:name];
                    if (!result)
                    {
                        continue;
                    }
                }
            }
        }
    }
    return nil;
}

- (BOOL)verify
{
    int success = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    {
        NSMutableDictionary *verifyDict = [self loadConfigFromPath:self.filePath];
        if (verifyDict[self.version])
        {
            for (NSString *keyboardName in self.keyboardNames)
            {
                NSMutableDictionary *keyboardDict = verifyDict[self.version][keyboardName];
                if ([keyboardDict[@"Row1-Geometry-List"] length] && 
                    [keyboardDict[@"Row2-Geometry-List"] length] &&
                    [keyboardDict[@"Row3-Geometry-List"] length] &&
                    [keyboardDict[@"Row4-Geometry-List"] length] &&
                    [keyboardDict[@"Delete-Geometry-List"] length])
                {
                    success++;
                    continue;
                }
                NSLog(@"OptimizedZhuyin: Failed to load keyboard info. Keyboard name: %@", keyboardName);
            }
        }
    }
    return success == self.keyboardNames.count;
}
@end