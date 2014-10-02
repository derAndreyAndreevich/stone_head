/* Generated by Nimrod Compiler v0.9.5 */
/*   (c) 2014 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:
   gcc -c  -w  -I/usr/lib/nimrod -o /home/andreysh/Projects/nimrod/stone_head/nimcache/graphics.o /home/andreysh/Projects/nimrod/stone_head/nimcache/graphics.c */
#define NIM_INTBITS 64
#include "nimbase.h"

#include <string.h>
typedef struct NimStringDesc NimStringDesc;
typedef struct TGenericSeq TGenericSeq;
typedef struct tslice79092 tslice79092;
struct  TGenericSeq  {
NI len;
NI reserved;
};
struct  NimStringDesc  {
  TGenericSeq Sup;
NIM_CHAR data[SEQ_DECL_SIZE];
};
struct  tslice79092  {
NI A;
NI B;
};
N_NIMCALL(void, glcolor_786005)(NimStringDesc* str);
N_STDCALL(void, glcolor4f_307802)(NF32 red, NF32 green, NF32 blue, NF32 alpha);
static N_INLINE(NF, HEX2F_79038)(NI x, NI y);
static N_INLINE(void, nimFrame)(TFrame* s);
static N_INLINE(void, popFrame)(void);
N_NIMCALL(NI, nsuParseHexInt)(NimStringDesc* s);
static N_INLINE(NimStringDesc*, HEX5BHEX5D_79085)(NimStringDesc* s, tslice79092 x);
N_NIMCALL(NimStringDesc*, copyStrLast)(NimStringDesc* s, NI start_70824, NI last);
N_NIMCALL(NimStringDesc*, copyStrLast)(NimStringDesc* s, NI first, NI last);
static N_INLINE(NI, addInt)(NI a, NI b);
N_NOINLINE(void, raiseOverflow)(void);
static N_INLINE(tslice79092, HEX2EHEX2E_95022)(NI a_95026, NI b_95028);
N_STDCALL(void, glbegin_494602)(NU32 mode);
N_NIMCALL(void, glvertex_792060)(NI x_792064, NI y_792066, NI z_792068, NI w_792070);
N_STDCALL(void, glvertex4i_613802)(NI32 x, NI32 y, NI32 z, NI32 w);
N_STDCALL(void, glvertex4f_168402)(NF32 x, NF32 y, NF32 z, NF32 w);
N_STDCALL(void, glend_187002)(void);
extern TFrame* frameptr_13038;

static N_INLINE(void, nimFrame)(TFrame* s) {
	(*s).prev = frameptr_13038;
	frameptr_13038 = s;
}

static N_INLINE(void, popFrame)(void) {
	frameptr_13038 = (*frameptr_13038).prev;
}

static N_INLINE(NF, HEX2F_79038)(NI x, NI y) {
	NF result;
	nimfr("/", "system.nim")
	result = 0;
	nimln(2567, "system.nim");
	nimln(2567, "system.nim");
	nimln(2567, "system.nim");
	nimln(2567, "system.nim");
	result = ((NF)(((double) (x))) / (NF)(((double) (y))));
	popFrame();
	return result;
}

static N_INLINE(NI, addInt)(NI a, NI b) {
	NI result;
	result = 0;
	result = (NI)((NU64)(a) + (NU64)(b));
	{
		NIM_BOOL LOC3;
		LOC3 = 0;
		LOC3 = (0 <= (NI)(result ^ a));
		if (LOC3) goto LA4;
		LOC3 = (0 <= (NI)(result ^ b));
		LA4: ;
		if (!LOC3) goto LA5;
		goto BeforeRet;
	}
	LA5: ;
	raiseOverflow();
	BeforeRet: ;
	return result;
}

static N_INLINE(NimStringDesc*, HEX5BHEX5D_79085)(NimStringDesc* s, tslice79092 x) {
	NimStringDesc* result;
	NI LOC1;
	NI LOC7;
	nimfr("[]", "system.nim")
	result = 0;
	nimln(2591, "system.nim");
	nimln(2591, "system.nim");
	LOC1 = 0;
	nimln(2570, "system.nim");
	{
		nimln(2570, "system.nim");
		if (!(0 <= x.A)) goto LA4;
		LOC1 = x.A;
	}
	goto LA2;
	LA4: ;
	{
		NI TMP685;
		nimln(2570, "system.nim");
		nimln(2570, "system.nim");
		TMP685 = addInt(s->Sup.len, x.A);
		LOC1 = (NI64)(TMP685);
	}
	LA2: ;
	LOC7 = 0;
	nimln(2570, "system.nim");
	{
		nimln(2570, "system.nim");
		if (!(0 <= x.B)) goto LA10;
		LOC7 = x.B;
	}
	goto LA8;
	LA10: ;
	{
		NI TMP686;
		nimln(2570, "system.nim");
		nimln(2570, "system.nim");
		TMP686 = addInt(s->Sup.len, x.B);
		LOC7 = (NI64)(TMP686);
	}
	LA8: ;
	result = copyStrLast(s, LOC1, LOC7);
	popFrame();
	return result;
}

static N_INLINE(tslice79092, HEX2EHEX2E_95022)(NI a_95026, NI b_95028) {
	tslice79092 result;
	nimfr("..", "system.nim")
	memset((void*)&result, 0, sizeof(result));
	nimln(179, "system.nim");
	result.A = a_95026;
	nimln(180, "system.nim");
	result.B = b_95028;
	popFrame();
	return result;
}

N_NIMCALL(void, glcolor_786005)(NimStringDesc* str) {
	tslice79092 LOC1;
	NimStringDesc* LOC2;
	NI LOC3;
	NF LOC4;
	tslice79092 LOC5;
	NimStringDesc* LOC6;
	NI LOC7;
	NF LOC8;
	tslice79092 LOC9;
	NimStringDesc* LOC10;
	NI LOC11;
	NF LOC12;
	tslice79092 LOC13;
	NimStringDesc* LOC14;
	NI LOC15;
	NF LOC16;
	nimfr("glColor", "graphics.nim")
	nimln(3, "graphics.nim");
	nimln(4, "graphics.nim");
	nimln(4, "graphics.nim");
	nimln(4, "graphics.nim");
	nimln(4, "graphics.nim");
	LOC1 = HEX2EHEX2E_95022(1, 2);
	LOC2 = 0;
	LOC2 = HEX5BHEX5D_79085(str, LOC1);
	LOC3 = 0;
	LOC3 = nsuParseHexInt(LOC2);
	LOC4 = 0;
	LOC4 = HEX2F_79038(LOC3, 255);
	nimln(5, "graphics.nim");
	nimln(5, "graphics.nim");
	nimln(5, "graphics.nim");
	nimln(5, "graphics.nim");
	LOC5 = HEX2EHEX2E_95022(3, 4);
	LOC6 = 0;
	LOC6 = HEX5BHEX5D_79085(str, LOC5);
	LOC7 = 0;
	LOC7 = nsuParseHexInt(LOC6);
	LOC8 = 0;
	LOC8 = HEX2F_79038(LOC7, 255);
	nimln(6, "graphics.nim");
	nimln(6, "graphics.nim");
	nimln(6, "graphics.nim");
	nimln(6, "graphics.nim");
	LOC9 = HEX2EHEX2E_95022(5, 6);
	LOC10 = 0;
	LOC10 = HEX5BHEX5D_79085(str, LOC9);
	LOC11 = 0;
	LOC11 = nsuParseHexInt(LOC10);
	LOC12 = 0;
	LOC12 = HEX2F_79038(LOC11, 255);
	nimln(7, "graphics.nim");
	nimln(7, "graphics.nim");
	nimln(7, "graphics.nim");
	nimln(7, "graphics.nim");
	LOC13 = HEX2EHEX2E_95022(7, 8);
	LOC14 = 0;
	LOC14 = HEX5BHEX5D_79085(str, LOC13);
	LOC15 = 0;
	LOC15 = nsuParseHexInt(LOC14);
	LOC16 = 0;
	LOC16 = HEX2F_79038(LOC15, 255);
	glcolor4f_307802(((NF32) (LOC4)), ((NF32) (LOC8)), ((NF32) (LOC12)), ((NF32) (LOC16)));
	popFrame();
}

N_NIMCALL(void, glvertex_792060)(NI x_792064, NI y_792066, NI z_792068, NI w_792070) {
	nimfr("glVertex", "graphics.nim")
	nimln(11, "graphics.nim");
	{
		if (!NIM_TRUE) goto LA3;
		nimln(12, "graphics.nim");
		glvertex4i_613802(((NI32) (x_792064)), ((NI32) (y_792066)), ((NI32) (z_792068)), ((NI32) (w_792070)));
	}
	goto LA1;
	LA3: ;
	{
		union { NI source; NF32 dest; } LOC6;
		union { NI source; NF32 dest; } LOC7;
		union { NI source; NF32 dest; } LOC8;
		union { NI source; NF32 dest; } LOC9;
		nimln(14, "graphics.nim");
		LOC6.source = x_792064;
		LOC7.source = y_792066;
		LOC8.source = z_792068;
		LOC9.source = w_792070;
		glvertex4f_168402(LOC6.dest, LOC7.dest, LOC8.dest, LOC9.dest);
	}
	LA1: ;
	popFrame();
}

N_NIMCALL(void, glrect_792048)(NI x1_792052, NI y1_792054, NI x2_792056, NI y2_792058) {
	nimfr("glRect", "graphics.nim")
	nimln(50, "graphics.nim");
	glbegin_494602(((NU32) 7));
	nimln(51, "graphics.nim");
	glvertex_792060(x1_792052, y1_792054, 0, 1.0000000000000000e+00);
	nimln(52, "graphics.nim");
	glvertex_792060(x2_792056, y1_792054, 0, 1.0000000000000000e+00);
	nimln(53, "graphics.nim");
	glvertex_792060(x2_792056, y2_792058, 0, 1.0000000000000000e+00);
	nimln(54, "graphics.nim");
	glvertex_792060(x1_792052, y2_792058, 0, 1.0000000000000000e+00);
	nimln(55, "graphics.nim");
	glend_187002();
	popFrame();
}

N_NIMCALL(void, glline_792132)(NI x1_792136, NI y1_792138, NI x2_792140, NI y2_792142) {
	nimfr("glLine", "graphics.nim")
	nimln(24, "graphics.nim");
	glbegin_494602(((NU32) 1));
	nimln(25, "graphics.nim");
	glvertex_792060(x1_792136, y1_792138, 0, 1.0000000000000000e+00);
	nimln(26, "graphics.nim");
	glvertex_792060(x2_792140, y2_792142, 0, 1.0000000000000000e+00);
	nimln(27, "graphics.nim");
	glend_187002();
	popFrame();
}
N_NOINLINE(void, graphicsInit)(void) {
	nimfr("graphics", "graphics.nim")
	popFrame();
}

N_NOINLINE(void, graphicsDatInit)(void) {
}

