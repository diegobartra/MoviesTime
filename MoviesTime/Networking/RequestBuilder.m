//
//  RequestBuilder.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/28/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "RequestBuilder.h"
#import "JSONParser.h"

static NSString *const Host = @"api.themoviedb.org";
static NSString *const ApiKey = @"1f54bd990f1cdfb230adb312546d765d";

@implementation RequestBuilder

+ (NSURL *)urlForPath:(NSString *)path queryItems:(NSArray *)queryItems {

    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = Host;
    components.path = [NSString stringWithFormat:@"/3%@", path];
    
    NSMutableArray *mQueryItems = [NSMutableArray array];
    
    NSURLQueryItem *apiKeyQueryItem = [NSURLQueryItem queryItemWithName:@"api_key" value:ApiKey];
    [mQueryItems addObject:apiKeyQueryItem];
    
    if (queryItems && [queryItems count]) {
        [mQueryItems addObjectsFromArray:queryItems];
    }
    
    components.queryItems = [mQueryItems copy];
    
    NSLog(@"%@", [components.URL absoluteString]);
    return components.URL;
}

+ (NSURL *)URLForPath:(NSString *)path {

    return [self urlForPath:path queryItems:nil];
}

+ (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)url HTTPMethod:(NSString *)HTTPMethod
                                    HTTPBody:(NSDictionary *)HTTPBody HTTPHeaders:(NSDictionary *)HTTPHeaders {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = HTTPMethod;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (HTTPBody) {
        NSData *jsonData = [JSONParser dataWithJSONObject:HTTPBody];
        request.HTTPBody = jsonData;
    }
    
    if (HTTPHeaders) {
        
        for (NSString *key in HTTPHeaders) {
            NSString *value = HTTPHeaders[key];
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    
    return request;
}

+ (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)url HTTPMethod:(NSString *)HTTPMethod HTTPBody:(NSDictionary *)HTTPBody {

    return [self buildRequestWithURL:url HTTPMethod:HTTPMethod HTTPBody:HTTPBody HTTPHeaders:nil];
}

+ (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)url HTTPMethod:(NSString *)HTTPMethod HTTPHeaders:(NSDictionary *)HTTPHeaders {

    return [self buildRequestWithURL:url HTTPMethod:HTTPMethod HTTPBody:nil HTTPHeaders:HTTPHeaders];
}

+ (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)url HTTPMethod:(NSString *)HTTPMethod {

    return [self buildRequestWithURL:url HTTPMethod:HTTPMethod HTTPBody:nil HTTPHeaders:nil];
}

+ (NSURLRequest *)GET:(NSString *)path queryItems:(NSArray *)queryItems {

    NSURL *URL = [self urlForPath:path queryItems:queryItems];
    NSMutableURLRequest *request =  [self buildRequestWithURL:URL HTTPMethod:@"GET"];
    
    return request;
}

+ (NSURLRequest *)GET:(NSString *)path {

    return [self GET:path queryItems:nil];
}

+ (NSURLRequest *)POST:(NSString *)path bodyObject:(NSDictionary *)bodyObject {

    NSURL *URL = [self URLForPath:path];
    NSMutableURLRequest *request = [self buildRequestWithURL:URL HTTPMethod:@"POST" HTTPBody:bodyObject];
    
    return request;
}

+ (NSURLRequest *)PUT:(NSString *)path bodyObject:(NSDictionary *)bodyObject {

    NSURL *URL = [self URLForPath:path];
    NSMutableURLRequest *request = [self buildRequestWithURL:URL HTTPMethod:@"PUT" HTTPBody:bodyObject];
    
    return request;
}

+ (NSURLRequest *)DELETE:(NSString *)path {

    NSURL *URL = [self URLForPath:path];
    NSMutableURLRequest *request = [self buildRequestWithURL:URL HTTPMethod:@"DELETE"];
    
    return request;
}

@end
