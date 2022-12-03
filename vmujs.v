module vmujs

/*
MIT License

Copyright (c) 2022 SheatNoisette

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// V Friendly Wrapper for MuJS

// MuJS state container
struct VMuJS {
mut:
	mujs_state &C.js_State
}

// Strict mode enum - New State
enum VMuJSStrictMode {
	strict
	non_strict
}

// Create a new state
// strict_mode: if true, the state will be in JS strict mode
pub fn new_state(strict_mode VMuJSStrictMode) &VMuJS {
	mut vm := &VMuJS{
		mujs_state: 0
	}

	// Strict mode flags
	mujs_flags := match strict_mode {
		.strict { mujs_js_strict }
		.non_strict { 0 }
	}

	// Create the state
	vm.mujs_state = C.js_newstate(unsafe { nil }, 0, mujs_flags)

	return vm
}

// Destroy a state
pub fn (vm &VMuJS) destroy() {
	C.js_freestate(vm.mujs_state)
}

// Push a line of code to the state
pub fn (vm &VMuJS) push_code(code string) ! {
	if C.js_dostring(vm.mujs_state, code.str) == 1 {
		return error('Error while pushing code to the state')
	}
}

// Load a file into the state
pub fn (vm &VMuJS) load_file(file string) {
	unsafe {
		C.js_dofile(vm.mujs_state, file.str)
	}
}

// Garbage collect the state
pub fn (vm &VMuJS) gc() {
	unsafe {
		C.js_gc(vm.mujs_state, 0)
	}
}

// Get a int global variable from the state
pub fn (vm &VMuJS) get_global_int(name string) !int {
	C.js_getglobal(vm.mujs_state, name.str)
	number := C.js_tointeger(vm.mujs_state, -1)

	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while getting global int')
	}

	C.js_pop(vm.mujs_state, 1)
	return number
}

// Get a float global variable from the state
pub fn (vm &VMuJS) get_global_float(name string) !f64 {
	C.js_getglobal(vm.mujs_state, name.str)
	number := C.js_tonumber(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while getting global float')
	}
	C.js_pop(vm.mujs_state, 1)
	return number
}

// Get a string global variable from the state
pub fn (vm &VMuJS) get_global_string(name string) !string {
	mut str := ''
	C.js_getglobal(vm.mujs_state, name.str)
	raw_value := C.js_tostring(vm.mujs_state, -1)

	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while getting global string')
	}

	unsafe {
		str = cstring_to_vstring(raw_value)
	}
	C.js_pop(vm.mujs_state, 1)
	return str
}

// Get a bool global variable from the state
pub fn (vm &VMuJS) get_global_bool(name string) !bool {
	C.js_getglobal(vm.mujs_state, name.str)
	number := C.js_toboolean(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while getting global bool')
	}
	C.js_pop(vm.mujs_state, 1)
	return match number {
		0 { false }
		else { true }
	}
}

// Push elements to VMuJS stack

// Push a int to the VM stack
pub fn (vm &VMuJS) push_int(number int) {
	C.js_pushnumber(vm.mujs_state, number)
}

// Push a float to the VM stack
pub fn (vm &VMuJS) push_float(number f64) {
	C.js_pushnumber(vm.mujs_state, number)
}

// Push a string to the VM stack
pub fn (vm &VMuJS) push_string(str string) {
	C.js_pushstring(vm.mujs_state, str.str)
}

// Push a bool to the VM stack
pub fn (vm &VMuJS) push_bool(b bool) {
	C.js_pushboolean(vm.mujs_state, match b {
		true { 1 }
		false { 0 }
	})
}

// Push a null to the VM stack
pub fn (vm &VMuJS) push_null() {
	C.js_pushnull(vm.mujs_state)
}

// Push a undefined to the VM stack
pub fn (vm &VMuJS) push_undefined() {
	C.js_pushundefined(vm.mujs_state)
}

// Push element from VMuJS stack using generic type
pub fn (vm &VMuJS) push_generic<T>(value T) {
	// Sadly there's a bug in V that doesn't allow to use generics in match
	// This is a workaround
	match typeof(value).name {
		'int' { vm.push_int(value) }
		'f64' { vm.push_float(value) }
		'f32' { vm.push_float(value) }
		'string' { vm.push_string(value.str()) }
		'bool' { vm.push_bool(value) }
		else { vm.push_undefined() }
	}
}

// Request to pop a element from the VM stack
pub fn (vm &VMuJS) pop(times int) {
	C.js_pop(vm.mujs_state, times)
}

// Pop a int from the VM stack
pub fn (vm &VMuJS) pop_int() !int {
	number := C.js_tointeger(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping int')
	}
	C.js_pop(vm.mujs_state, 1)
	return number
}

// Pop a float from the VM stack
pub fn (vm &VMuJS) pop_float() !f64 {
	number := C.js_tonumber(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping float')
	}
	C.js_pop(vm.mujs_state, 1)
	return number
}

// Pop a string from the VM stack
pub fn (vm &VMuJS) pop_string() !string {
	mut str := ''
	raw_value := C.js_tostring(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping string')
	}
	unsafe {
		str = cstring_to_vstring(raw_value)
	}
	C.js_pop(vm.mujs_state, 1)
	return str
}

// Pop a bool from the VM stack
pub fn (vm &VMuJS) pop_bool() !bool {
	number := C.js_toboolean(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping bool')
	}
	C.js_pop(vm.mujs_state, 1)
	return match number {
		0 { false }
		else { true }
	}
}
