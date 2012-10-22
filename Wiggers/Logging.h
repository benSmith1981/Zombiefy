//
//  Logging.h
//  Zombify
//
//  Created by Ben on 10/22/12.
//
//

#ifndef Zombify_Logging_h
#define Zombify_Logging_h


//  Logging.h
//  TheSun
//
//  Created by Martin Lloyd on 20/09/2012.
//
//

// The general purpose logger. This ignores logging levels.
#define Warn(xx, ...)  NSLog(@"%s(%d): " xx, _PRETTY_FUNCTION_, _LINE_, ##_VA_ARGS_)

#ifdef DEBUG
#define Debug(xx, ...)  NSLog(@"%s(%d): " xx, _PRETTY_FUNCTION_, _LINE_, ##_VA_ARGS_)
#define Assert(condition, desc, ...)                                                                    \
do                                                                                                      \
{                                                                                                       \
if (!(condition))                                                                                   \
{                                                                                                   \
LogCriticalError(kComponentAssert, @"* Assertion failure: " desc, ##_VA_ARGS_);             \
assert(false);                                                                                  \
}                                                                                                   \
}                                                                                                       \
while(0)
#else
#define Debug(xx, ...)  ((void)0)
#define Assert(condition, desc, ...) ((void)0)
#endif // #ifdef DEBUG

#endif


