//
//  Common.h
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

typedef enum {
    C2,
    C3,
    C4,
    C5
}OCTAVE;

typedef enum {
    U,
    m2,
    M2,
    m3,
    M3,
    P4,
    TT,
    P5,
    m6,
    M6,
    m7,
    M7,
    P8
}INTERVALS;

typedef enum {
    maj,
    min,
    aug,
    dim,
    maj7,
    min7,
    mM7,
    dom7,
    augM7,
    aug7,
    hDim7,
    dim7
}CHORDS;

typedef enum {
    PLAYMODE_ASCENDING,
    PLAYMODE_DESCENDING,
    PLAYMODE_CHORD
}PLAYMODE;

typedef enum {
    SLOW,
    MEDIUM,
    FAST
}TEMPO;

#if DEBUG 
#include "pthread.h"
#define dbgLog(args...) _dbgLog(__FILE__, __LINE__, args)
void _dbgLog(const char* pszFile, int line, NSString* fmt, ...);
#define dbgAssert(arg) assert(arg)
#else
#define dbgLog(args...)	{}
#define dbgAssert(arg) {}
#endif

NSString* currentVersion(void);

float tempoFromType(TEMPO);
