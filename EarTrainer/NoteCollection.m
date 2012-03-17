// Describes a collection of notes
// Ambiguous class that can be a chord/interval

#import "NoteCollection.h"
#import "Note.h"

@implementation NoteCollection

@synthesize notes = _notes;
@synthesize shortName = _shortName;
@synthesize longName = _longName;
@synthesize index = _index;

- (id)initWithIndex:(NSInteger)index {
    self = [super init];
    _index = index;
    return self;
}

- (NSString *)getNoteNames {
    NSString *notes = [NSString stringWithString:@""];
    int noteCount = 0;
    for (Note *note in _notes) {
        noteCount++;
        NSString *formattedString = (noteCount == _notes.count) ? [NSString stringWithFormat:@"%@",note.name] : [NSString stringWithFormat:@"%@ - ",note.name];
        notes = [notes stringByAppendingString:formattedString];
    }
    return notes;
}

+ (NSArray *)longNames {
    return [NSArray array];
}

+ (NSArray *)shortNames {
    return [NSArray array];
}
@end
