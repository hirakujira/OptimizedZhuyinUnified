/* Generated by RuntimeBrowser
 Image: /System/Library/PrivateFrameworks/TextInputUI.framework/TextInputUI
 */

@class TUIKBGraphSerialization, UIKBTree;

@interface TUIKeyboardLayoutFactory : NSObject {
    TUIKBGraphSerialization * _decoder;
    NSMutableDictionary * _internalCache;
    void * _layoutsLibraryHandle;
}

@property (retain) TUIKBGraphSerialization *decoder;
@property (retain) NSMutableDictionary *internalCache;
@property (nonatomic, readonly) void*layoutsLibraryHandle;

+ (id)layoutsFileName;
+ (TUIKeyboardLayoutFactory *)sharedKeyboardFactory;

- (void)dealloc;
- (TUIKBGraphSerialization *)decoder;
- (id)init;
- (NSMutableDictionary *)internalCache;
- (NSString *)keyboardPrefixForWidth:(double)arg1 andEdge:(bool)arg2;
- (UIKBTree *)keyboardWithName:(NSString *)arg1 inCache:(NSMutableDictionary *)arg2;
- (void*)layoutsLibraryHandle;
- (void)setDecoder:(TUIKBGraphSerialization *)arg1;
- (void)setInternalCache:(NSMutableDictionary *)arg1;

@end
