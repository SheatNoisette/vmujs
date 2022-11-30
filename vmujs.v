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

// Values from a state
struct VMuJSValue {
	integer int
}

// Create a new state
// strict_mode: if true, the state will be in JS strict mode
fn new_state(strict_mode bool) &VMuJS {
	mut vm := &VMuJS{
		mujs_state: 0
	}

	// Strict mode flags
	mujs_flags := match strict_mode {
		true  { mujs_js_strict }
		false { 0 }
	}

	vm.mujs_state = C.js_newstate(voidptr(0), 0, mujs_flags)

	return vm
}

// Destroy a state
fn (vm &VMuJS) destroy() {
	C.js_freestate(vm.mujs_state)
}

// Push a line of code to the state
fn (vm &VMuJS) push_code(code string) {
	unsafe {
		C.js_dostring(vm.mujs_state, code.str)
	}
}

// Load a file into the state
fn (vm &VMuJS) load_file(file string) {
	unsafe {
		C.js_dofile(vm.mujs_state, file.str)
	}
}

// Get a int global variable from the state
fn (vm &VMuJS) get_global_int(name string) int {
	C.js_getglobal(vm.mujs_state, name.str)
	number := C.js_tointeger(vm.mujs_state, -1)
	C.js_pop(vm.mujs_state, 1)
	return number
}
