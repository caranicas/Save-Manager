//  Created by Kendrick Caranicas on 4/17/11.
//  Copyright 2011 Shugyo Studios. All rights reserved.


#define kSAVE_ROOT  	     @"~/Library/Application Support/SomePath/"
@interface SaveManager : NSObject 
{
    
}

+ (void) saveObject:(id)_obj withRootPath:(NSString*)_root withFileName:(NSString*)_fileName;
+ (id)   loadObjectWithRootPath:(NSString*)_root withFileName:(NSString*)_fileName;
+ (NSData *)savedDataForURL:(NSURL *)url;
+ (void)savaData:(NSData *)dataToSave forURL:(NSURL *)urlOfData;
+ (NSString*) createPath:(NSString*)_root withFileName:(NSString*)_fileName;

@end
