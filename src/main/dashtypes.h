#ifndef DASHTYPES_H
#define DASHTYPES_H

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef unsigned long long uint64;
typedef signed char sint8;
typedef signed short sint16;
typedef signed int sint32;
typedef signed long long sint64;


typedef struct{
	sint16		id;
	sint16		flag;
	sint16		x,z;
	sint16		w,h;
	sint8		next[5];
	uint8		pad1;
	uint16		pad2;
} MOVE_TBL;


#endif