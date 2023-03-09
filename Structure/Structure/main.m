//
//  main.m
//  Structure
//
//  Created by Changhao Li on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import <App/App-Swift.h>

int main(int argc, char *argv[]) {
#if DEBUG
    // Enable network diagnostic logs in debug mode.
    setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
#endif
    @autoreleasepool {
        // We log both to console and syslog, this is why we use both NSLog() and print()
        NSString *const logMessage = @"Application Starting";
        NSLog(logMessage);
        CFShowStr((__bridge CFStringRef)logMessage);

        // Call the main function and start the app
        UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
