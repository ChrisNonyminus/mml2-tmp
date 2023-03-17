#ifndef DECOMP_H
#define DECOMP_H

// taken from sotn decomp
// https://github.com/Xeeynamo/sotn-decomp/blob/master/include/include_asm.h

#define STRINGIFY_(x) #x
#define STRINGIFY(x) STRINGIFY_(x)

#ifndef PERMUTER

#ifndef INCLUDE_ASM

#define INCLUDE_ASM(FOLDER, NAME)                                              \
    __asm__(".section .text\n"                                                 \
            "\t.align\t2\n"                                                    \
            "\t.globl\t" #NAME "\n"                                            \
            "\t.ent\t" #NAME "\n" #NAME ":\n"                                  \
            ".include \"" FOLDER "/" #NAME ".s\"\n"                            \
            "\t.set reorder\n"                                                 \
            "\t.set at\n"                                                      \
            "\t.end\t" #NAME);
#endif

// omit .global
__asm__(".include \"macro.inc\"\n");

#else
#define INCLUDE_ASM(FOLDER, NAME)
#endif

#endif