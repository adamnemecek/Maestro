//
//  Common.m
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

#import "Common.h"

#if DEBUG

void _dbgLog(const char* pszFile, int line, NSString* fmt, ...) {
    char threadname[32] = "main";
    if (!pthread_main_np()) {
        mach_port_t tid = pthread_mach_thread_np(pthread_self());
        sprintf(threadname, "%d", tid);
    }
    
    va_list ap;
    va_start(ap, fmt);
    NSString* log = [[NSString alloc] initWithFormat:fmt arguments:ap];
    va_end(ap);
    
    const char* end = strrchr(pszFile, '/');
    fprintf(stderr, "[dbgLog %s-%s:%d] %s\n", threadname, end ? end+1 : pszFile, line, [log UTF8String]);
}

#endif


NSString* currentVersion(void) {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#define kImage_Playmode_Ascending   @"playmode_Ascending"
#define kImage_Playmode_Descending  @"playmode_Descending"
#define kImage_Playmode_Chord       @"playmode_Chord"

UIImage *imageForPlaymode(PLAYMODE playmode) {
    NSString *playmodeImageTitle;
    switch (playmode) {
        case PLAYMODE_ASCENDING:
            playmodeImageTitle = kImage_Playmode_Ascending;
            break;
        case PLAYMODE_DESCENDING:
            playmodeImageTitle = kImage_Playmode_Descending;
            break;
        case PLAYMODE_CHORD:
            playmodeImageTitle = kImage_Playmode_Chord;
            break;
    }
    return [UIImage imageNamed:playmodeImageTitle];
}

float tempoFromType(TEMPO tempo) {
    switch (tempo) {
        case SLOW:
            return 1.0;
            break;
        case MEDIUM:
            return 0.60;
            break;
        case FAST:
            return 0.30;
            break;
    }
}








