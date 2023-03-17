#ifndef DECOMP_H
#define DECOMP_H

// taken from sotn decomp
// https://github.com/Xeeynamo/sotn-decomp/blob/master/include/include_asm.h

#define STRINGIFY_(x) #x
#define STRINGIFY(x) STRINGIFY_(x)

#ifndef PERMUTER

#ifndef INCLUDE_ASM

#define INCLUDE_ASM(FOLDER, NAME)                                              \
__asm__( \
    ".text\r\n" \
    "\t.align\t2\r\n" \
    "\t.set noreorder\r\n" \
    "\t.set noat\r\n" \
    ".include \""FOLDER"/"#NAME".s\"\r\n" \
    "\t.set reorder\r\n" \
    "\t.set at\r\n" \
);
#endif

// omit .global
__asm__(".include \"macro.inc\"\n");

#else
#define INCLUDE_ASM(FOLDER, NAME)
#endif

#endif