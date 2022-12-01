module vmujs

// Import the MuJS module for compiling
#include "@VROOT/mujs/mujs.h"
// Fix TCC compiler error for missing math functions
#include <math.h>
#flag -lm

#flag -I @VROOT/mujs/regexp.h
#flag -I @VROOT/mujs/mujs.h

#flag @VROOT/mujs/one.c

// @TODO: Wrap consts into proper enums
const (
	// State constructor flags
	mujs_js_strict      = 1

	// RegExp flags
	mujs_js_regexp_g    = 1
	mujs_js_regexp_i    = 2
	mujs_js_regexp_m    = 4

	// Property attribute flags
	mujs_js_readonly    = 1
	mujs_js_dontenum    = 2
	mujs_js_dontconf    = 4

	// enum for js_type()
	mujs_js_isundefined = 0
	mujs_js_isnull      = 1
	mujs_js_isboolean   = 2
	mujs_js_isnumber    = 3
	mujs_js_isstring    = 4
	mujs_js_isfunction  = 5
	mujs_js_isobject    = 6
)

// JS State
[typedef]
struct C.js_State {}

// MuJS version
fn C.JS_CHECKVERSION(int, int, int)

// Main MuJS API declarations
// Custom types
type Js_Alloc = fn (voidptr, voidptr, int) voidptr

type Js_Panic = fn (&C.js_State)

type Js_CFunction = fn (&C.js_State)

type Js_Finalize = fn (&C.js_State, voidptr)

type Js_HasProperty = fn (&C.js_State, voidptr, &i8) int

type Js_Put = fn (&C.js_State, voidptr, &i8) int

type Js_Delete = fn (&C.js_State, voidptr, &i8) int

type Js_Report = fn (&C.js_State, &i8)

// js_State *js_newstate(js_Alloc alloc, void *actx, int flags)
fn C.js_newstate(alloc C.js_Alloc, actx voidptr, flags int) &C.js_State

// void js_setcontext(js_State *J, void *uctx);
fn C.js_setcontext(J &C.js_State, uctx voidptr)

// void *js_getcontext(js_State *J);
fn C.js_getcontext(J &C.js_State) voidptr

// void js_setreport(js_State *J, js_Report report);
fn C.js_setreport(J &C.js_State, report C.js_Report)

// js_Panic js_atpanic(js_State *J, js_Panic panic);
fn C.js_atpanic(J &C.js_State, panic C.js_Panic) C.js_Panic

// void js_freestate(js_State *J);
fn C.js_freestate(J &C.js_State)

// void js_gc(js_State *J, int report);
fn C.js_gc(J &C.js_State, report int)

// int js_dostring(js_State *J, const char *source);
fn C.js_dostring(J &C.js_State, source &i8) int

// int js_dofile(js_State *J, const char *filename);
fn C.js_dofile(J &C.js_State, filename &i8) int

// int js_ploadstring(js_State *J, const char *filename, const char *source);
fn C.js_ploadstring(J &C.js_State, filename &i8, source &i8) int

// int js_ploadfile(js_State *J, const char *filename);
fn C.js_ploadfile(J &C.js_State, filename &i8) int

// int js_pcall(js_State *J, int n);
fn C.js_pcall(J &C.js_State, n int) int

// int js_pconstruct(js_State *J, int n);
fn C.js_pconstruct(J &C.js_State, n int) int

// void *js_savetry(js_State *J);
fn C.js_savetry(J &C.js_State) voidptr

// void js_report(js_State *J, const char *message);
fn C.js_report(J &C.js_State, message &i8)

// void js_newerror(js_State *J, const char *message);
fn C.js_newerror(J &C.js_State, message &i8)

// void js_newevalerror(js_State *J, const char *message);
fn C.js_newevalerror(J &C.js_State, message &i8)

// void js_newrangeerror(js_State *J, const char *message);
fn C.js_newrangeerror(J &C.js_State, message &i8)

// void js_newreferenceerror(js_State *J, const char *message);
fn C.js_newreferenceerror(J &C.js_State, message &i8)

// void js_newsyntaxerror(js_State *J, const char *message);
fn C.js_newsyntaxerror(J &C.js_State, message &i8)

// void js_newtypeerror(js_State *J, const char *message);
fn C.js_newtypeerror(J &C.js_State, message &i8)

// void js_newurierror(js_State *J, const char *message);
fn C.js_newurierror(J &C.js_State, message &i8)

/*
JS_NORETURN void js_error(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_evalerror(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_rangeerror(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_referenceerror(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_syntaxerror(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_typeerror(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_urierror(js_State *J, const char *fmt, ...) JS_PRINTFLIKE(2,3);
JS_NORETURN void js_throw(js_State *J);
*/

// void js_loadstring(js_State *J, const char *filename, const char *source);
fn C.js_loadstring(J &C.js_State, filename &i8, source &i8)

// void js_loadfile(js_State *J, const char *filename);
fn C.js_loadfile(J &C.js_State, filename &i8)

// void js_eval(js_State *J);
fn C.js_eval(J &C.js_State)

// void js_call(js_State *J, int n);
fn C.js_call(J &C.js_State, n int)

// void js_construct(js_State *J, int n);
fn C.js_construct(J &C.js_State, n int)

// const char *js_ref(js_State *J);
fn C.js_ref(J &C.js_State) &i8

// void js_unref(js_State *J, const char *ref);
fn C.js_unref(J &C.js_State, ref &i8)

// void js_getregistry(js_State *J, const char *name);
fn C.js_getregistry(J &C.js_State, name &i8)

// void js_setregistry(js_State *J, const char *name);
fn C.js_setregistry(J &C.js_State, name &i8)

// void js_delregistry(js_State *J, const char *name);
fn C.js_delregistry(J &C.js_State, name &i8)

// void js_getglobal(js_State *J, const char *name);
fn C.js_getglobal(J &C.js_State, name &i8)

// void js_setglobal(js_State *J, const char *name);
fn C.js_setglobal(J &C.js_State, name &i8)

// void js_defglobal(js_State *J, const char *name, int atts);
fn C.js_defglobal(J &C.js_State, name &i8, atts int)

// void js_delglobal(js_State *J, const char *name);
fn C.js_delglobal(J &C.js_State, name &i8)

// int js_hasproperty(js_State *J, int idx, const char *name);
fn C.js_hasproperty(J &C.js_State, idx int, name &i8) int

// void js_getproperty(js_State *J, int idx, const char *name);
fn C.js_getproperty(J &C.js_State, idx int, name &i8)

// void js_setproperty(js_State *J, int idx, const char *name);
fn C.js_setproperty(J &C.js_State, idx int, name &i8)

// void js_defproperty(js_State *J, int idx, const char *name, int atts);
fn C.js_defproperty(J &C.js_State, idx int, name &i8, atts int)

// void js_delproperty(js_State *J, int idx, const char *name);
fn C.js_delproperty(J &C.js_State, idx int, name &i8)

// void js_defaccessor(js_State *J, int idx, const char *name, int atts);
fn C.js_defaccessor(J &C.js_State, idx int, name &i8, atts int)

// int js_getlength(js_State *J, int idx);
fn C.js_getlength(J &C.js_State, idx int) int

// void js_setlength(js_State *J, int idx, int len);
fn C.js_setlength(J &C.js_State, idx int, len int)

// int js_hasindex(js_State *J, int idx, int i);
fn C.js_hasindex(J &C.js_State, idx int, i int) int

// void js_getindex(js_State *J, int idx, int i);
fn C.js_getindex(J &C.js_State, idx int, i int)

// void js_setindex(js_State *J, int idx, int i);
fn C.js_setindex(J &C.js_State, idx int, i int)

// void js_delindex(js_State *J, int idx, int i);
fn C.js_delindex(J &C.js_State, idx int, i int)

// void js_currentfunction(js_State *J);
fn C.js_currentfunction(J &C.js_State)

// void *js_currentfunctiondata(js_State *J);
fn C.js_currentfunctiondata(J &C.js_State) voidptr

// void js_pushglobal(js_State *J);
fn C.js_pushglobal(J &C.js_State)

// void js_pushundefined(js_State *J);
fn C.js_pushundefined(J &C.js_State)

// void js_pushnull(js_State *J);
fn C.js_pushnull(J &C.js_State)

// void js_pushboolean(js_State *J, int v);
fn C.js_pushboolean(J &C.js_State, v int)

// void js_pushnumber(js_State *J, double v);
fn C.js_pushnumber(J &C.js_State, v f64)

// void js_pushstring(js_State *J, const char *v);
fn C.js_pushstring(J &C.js_State, v &i8)

// void js_pushlstring(js_State *J, const char *v, int n);
fn C.js_pushlstring(J &C.js_State, v &i8, n int)

// void js_pushliteral(js_State *J, const char *v);
fn C.js_pushliteral(J &C.js_State, v &i8)

// void js_newobjectx(js_State *J);
fn C.js_newobjectx(J &C.js_State)

// void js_newobject(js_State *J);
fn C.js_newobject(J &C.js_State)

// void js_newarray(js_State *J);
fn C.js_newarray(J &C.js_State)

// void js_newboolean(js_State *J, int v);
fn C.js_newboolean(J &C.js_State, v int)

// void js_newnumber(js_State *J, double v);
fn C.js_newnumber(J &C.js_State, v f64)

// void js_newstring(js_State *J, const char *v);
fn C.js_newstring(J &C.js_State, v &i8)

// void js_newcfunction(js_State *J, js_CFunction fun, const char *name, int length);
fn C.js_newcfunction(J &C.js_State, fun &C.js_CFunction, name &i8, length int)

// void js_newcfunctionx(js_State *J, js_CFunction fun, const char *name, int length, void *data, js_Finalize finalize);
fn C.js_newcfunctionx(J &C.js_State, fun &C.js_CFunction, name &i8, length int, data voidptr, finalize &C.js_Finalize)

// void js_newcconstructor(js_State *J, js_CFunction fun, js_CFunction con, const char *name, int length);
fn C.js_newcconstructor(J &C.js_State, fun &C.js_CFunction, con &C.js_CFunction, name &i8, length int)

// void js_newuserdata(js_State *J, const char *tag, void *data, js_Finalize finalize);
fn C.js_newuserdata(J &C.js_State, tag &i8, data voidptr, finalize &C.js_Finalize)

// void js_newuserdatax(js_State *J, const char *tag, void *data, js_HasProperty has, js_Put put, js_Delete del, js_Finalize finalize);
fn C.js_newuserdatax(J &C.js_State, tag &i8, data voidptr, has &C.js_HasProperty, put &C.js_Put, del &C.js_Delete, finalize &C.js_Finalize)

// void js_newregexp(js_State *J, const char *pattern, int flags);
fn C.js_newregexp(J &C.js_State, pattern &i8, flags int)

// int js_isdefined(js_State *J, int idx);
fn C.js_isdefined(J &C.js_State, idx int) int

// int js_isundefined(js_State *J, int idx);
fn C.js_isundefined(J &C.js_State, idx int) int

// int js_isnull(js_State *J, int idx);
fn C.js_isnull(J &C.js_State, idx int) int

// int js_isboolean(js_State *J, int idx);
fn C.js_isboolean(J &C.js_State, idx int) int

// int js_isnumber(js_State *J, int idx);
fn C.js_isnumber(J &C.js_State, idx int) int

// int js_isstring(js_State *J, int idx);
fn C.js_isstring(J &C.js_State, idx int) int

// int js_isprimitive(js_State *J, int idx);
fn C.js_isprimitive(J &C.js_State, idx int) int

// int js_isobject(js_State *J, int idx);
fn C.js_isobject(J &C.js_State, idx int) int

// int js_isarray(js_State *J, int idx);
fn C.js_isarray(J &C.js_State, idx int) int

// int js_isregexp(js_State *J, int idx);
fn C.js_isregexp(J &C.js_State, idx int) int

// int js_iscoercible(js_State *J, int idx);
fn C.js_iscoercible(J &C.js_State, idx int) int

// int js_iscallable(js_State *J, int idx);
fn C.js_iscallable(J &C.js_State, idx int) int

// int js_isuserdata(js_State *J, int idx, const char *tag);
fn C.js_isuserdata(J &C.js_State, idx int, tag &i8) int

// int js_iserror(js_State *J, int idx);
fn C.js_iserror(J &C.js_State, idx int) int

// int js_isnumberobject(js_State *J, int idx);
fn C.js_isnumberobject(J &C.js_State, idx int) int

// int js_isstringobject(js_State *J, int idx);
fn C.js_isstringobject(J &C.js_State, idx int) int

// int js_isbooleanobject(js_State *J, int idx);
fn C.js_isbooleanobject(J &C.js_State, idx int) int

// int js_isdateobject(js_State *J, int idx);
fn C.js_isdateobject(J &C.js_State, idx int) int

// int js_toboolean(js_State *J, int idx);
fn C.js_toboolean(J &C.js_State, idx int) int

// double js_tonumber(js_State *J, int idx);
fn C.js_tonumber(J &C.js_State, idx int) f64

// const char *js_tostring(js_State *J, int idx);
fn C.js_tostring(J &C.js_State, idx int) &char

// void *js_touserdata(js_State *J, int idx, const char *tag);
fn C.js_touserdata(J &C.js_State, idx int, tag &i8) voidptr

// const char *js_trystring(js_State *J, int idx, const char *error);
fn C.js_trystring(J &C.js_State, idx int, error &i8) &i8

// double js_trynumber(js_State *J, int idx, double error);
fn C.js_trynumber(J &C.js_State, idx int, error f64) f64

// int js_tryinteger(js_State *J, int idx, int error);
fn C.js_tryinteger(J &C.js_State, idx int, error int) int

// int js_tryboolean(js_State *J, int idx, int error);
fn C.js_tryboolean(J &C.js_State, idx int, error int) int

// int js_tointeger(js_State *J, int idx);
fn C.js_tointeger(J &C.js_State, idx int) int

// int js_toint32(js_State *J, int idx);
fn C.js_toint32(J &C.js_State, idx int) int

// unsigned int js_touint32(js_State *J, int idx);
fn C.js_touint32(J &C.js_State, idx int) u32

// short js_toint16(js_State *J, int idx);
fn C.js_toint16(J &C.js_State, idx int) i16

// unsigned short js_touint16(js_State *J, int idx);
fn C.js_touint16(J &C.js_State, idx int) u16

// int js_gettop(js_State *J);
fn C.js_gettop(J &C.js_State) int

// void js_pop(js_State *J, int n);
fn C.js_pop(J &C.js_State, n int)

// void js_rot(js_State *J, int n);
fn C.js_rot(J &C.js_State, n int)

// void js_copy(js_State *J, int idx);
fn C.js_copy(J &C.js_State, idx int)

// void js_remove(js_State *J, int idx);
fn C.js_remove(J &C.js_State, idx int)

// void js_insert(js_State *J, int idx);
fn C.js_insert(J &C.js_State, idx int)

// void js_replace(js_State* J, int idx);
fn C.js_replace(J &C.js_State, idx int)

// void js_dup(js_State *J);
fn C.js_dup(J &C.js_State)

// void js_dup2(js_State *J);
fn C.js_dup2(J &C.js_State)

// void js_rot2(js_State *J);
fn C.js_rot2(J &C.js_State)

// void js_rot3(js_State *J);
fn C.js_rot3(J &C.js_State)

// void js_rot4(js_State *J);
fn C.js_rot4(J &C.js_State)

// void js_rot2pop1(js_State *J);
fn C.js_rot2pop1(J &C.js_State)

// void js_rot3pop2(js_State *J);
fn C.js_rot3pop2(J &C.js_State)

// void js_concat(js_State *J);
fn C.js_concat(J &C.js_State)

// int js_compare(js_State *J, int *okay);
fn C.js_compare(J &C.js_State, okay &int) int

// int js_equal(js_State *J);
fn C.js_equal(J &C.js_State) int

// int js_strictequal(js_State *J);
fn C.js_strictequal(J &C.js_State) int

// int js_instanceof(js_State *J);
fn C.js_instanceof(J &C.js_State) int

// const char *js_typeof(js_State *J, int idx);
fn C.js_typeof(J &C.js_State, idx int) &i8

// int js_type(js_State *J, int idx);
fn C.js_type(J &C.js_State, idx int) int

// void js_repr(js_State *J, int idx);
fn C.js_repr(J &C.js_State, idx int)

// const char *js_torepr(js_State *J, int idx);
fn C.js_torepr(J &C.js_State, idx int) &i8

// const char *js_tryrepr(js_State *J, int idx, const char *error);
fn C.js_tryrepr(J &C.js_State, idx int, error &i8) &i8
