/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ZXParsedResultType.h"
#import "ZXResult.h"

/**
 * Abstract class representing the result of decoding a barcode, as more than
 * a String -- as some type of structured data. This might be a subclass which represents
 * a URL, or an e-mail address. parseResult() will turn a raw
 * decoded string into the most appropriate type of structured representation.
 *
 * Thanks to Jeff Griffin for proposing rewrite of these classes that relies less
 * on exception-based mechanisms during parsing.
 */
@interface ZXParsedResult : NSObject

@property (nonatomic, assign, readonly) ZXParsedResultType type;

- (id)initWithType:(ZXParsedResultType)type;
+ (id)parsedResultWithType:(ZXParsedResultType)type;
- (NSString *)displayResult;
+ (void)maybeAppend:(NSString *)value result:(NSMutableString *)result;
+ (void)maybeAppendArray:(NSArray *)value result:(NSMutableString *)result;

@end
