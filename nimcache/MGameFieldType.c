/* Generated by Nimrod Compiler v0.9.5 */
/*   (c) 2014 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:
   gcc -c  -w  -I/usr/lib/nimrod -o /home/andreysh/Projects/nimrod/stone_head/nimcache/MGameFieldType.o /home/andreysh/Projects/nimrod/stone_head/nimcache/MGameFieldType.c */
#define NIM_INTBITS 64
#include "nimbase.h"
static N_INLINE(void, nimFrame)(TFrame* s);
static N_INLINE(void, popFrame)(void);
extern TFrame* frameptr_13038;

static N_INLINE(void, nimFrame)(TFrame* s) {
	(*s).prev = frameptr_13038;
	frameptr_13038 = s;
}

static N_INLINE(void, popFrame)(void) {
	frameptr_13038 = (*frameptr_13038).prev;
}
N_NOINLINE(void, MGameFieldTypeInit)(void) {
	nimfr("MGameFieldType", "MGameFieldType.nim")
	popFrame();
}

N_NOINLINE(void, MGameFieldTypeDatInit)(void) {
}

