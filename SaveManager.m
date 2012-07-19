//  Created by Kendrick Caranicas on 4/17/11.
//  Copyright 2011 Shugyo Studios. All rights reserved.

#import "SaveManager.h"

@implementation SaveManager

#pragma mark -
#pragma mark LIFECYCLE
#pragma mark -

- (id)init
{
	self = [super init];
	if(self == nil) return nil;	
	
	return self;	
}


- (void)dealloc
{	
	[super dealloc];	
}

#pragma mark -
#pragma mark SAVING
#pragma mark -

+ (void) saveObject:(id)_obj withRootPath:(NSString*)_root withFileName:(NSString*)_fileName
{
	NSString * path = [SaveManager createPath:_root withFileName:_fileName];
	NSMutableDictionary * rootObject;
	rootObject = [NSMutableDictionary dictionary];
	[rootObject setValue:_obj  forKey:_fileName];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

+ (void)savaData:(NSData *)dataToSave forURL:(NSURL *)urlOfData
{	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fileName = [urlOfData lastPathComponent];
	NSString *fullPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:kSAVE_ROOT] stringByAppendingString:[[urlOfData path] stringByDeletingLastPathComponent]];
	
	NSError *error = nil;
	
	BOOL pathCreationResult = [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];
	
	if (!error)
	{
		if (pathCreationResult == YES)
		{
			NSString *dateString = [NSDate date];
			BOOL fileCreationResult = [[NSFileManager defaultManager] createFileAtPath:[fullPath stringByAppendingPathComponent:fileName] contents:dataToSave attributes:[NSDictionary dictionaryWithObject:dateString forKey:NSFileModificationDate]];
			
			if (fileCreationResult == YES)
			{ NSLog(@"File Created"); }
			else 
			{NSLog(@"File Not Created");}
		}
		
		else 
		{ NSLog(@"Path Not Created"); }		
	}
	
	else 
	{ NSLog(@"There was an error, you log it out");}
}


#pragma mark Loading Saved
+ (id) loadObjectWithRootPath:(NSString*)_root withFileName:(NSString*)_fileName
{
	NSString * path = [SaveManager createPath:_root withFileName:_fileName];
	NSDictionary* rootObject = nil;
	rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];    
	
	if(rootObject)
		return [rootObject valueForKey:_fileName];
    
	else 
		return nil;
}

+ (NSData *)savedDataForURL:(NSURL *)url
{
	NSData *resourceData = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *fullPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:kSAVE_ROOT] stringByAppendingString:[[url path] stringByDeletingLastPathComponent]];
	NSString *fileName = [((NSURL*)url) lastPathComponent];
	
    
	NSLog(@"will load file at path : %@", [fullPath stringByAppendingPathComponent:fileName]);	
	
	BOOL doesFileExist = [[NSFileManager defaultManager] fileExistsAtPath:[fullPath stringByAppendingPathComponent:fileName]];
    
	if (doesFileExist)
	{
        NSLog(@"File Exists");
		resourceData = [[NSFileManager defaultManager] contentsAtPath:[fullPath stringByAppendingPathComponent:fileName]];
	}
	else 
	{
		NSLog(@"File Not There");
	}
    
	return resourceData;
}

#pragma mark Pathing
+ (NSString*) createPath:(NSString*)_fileStructure withFileName:(NSString*)_fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString* folder = [NSString stringWithString:_fileStructure];
	NSError* err = nil;
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO)
	{ [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&err]; }
	
	NSLog(@"Pathing Error: %@", [err localizedDescription]);
    
	return [folder stringByAppendingPathComponent: _fileName];    
}

@end
