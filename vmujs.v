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
pub struct VMuJS {
mut:
	mujs_state &C.js_State // MuJS state
	fn_map     map[string]VMuJSValueFnCallback // Map of functions for JS -> V
	fn_data    map[string]map[string]string    // Map of data for JS -> V
}

// Strict mode enum - New State
pub enum VMuJSStrictMode {
	strict
	non_strict
}

// Type of a JS Value
pub enum VMuJSType {
	integer
	float
	str
	boolean
	array
	null
	unknown
}

// Base struct for arguments for the callback
pub struct VMuJSValue {
pub:
	kind VMuJSType

	integer int
	float   f64
	str     string
	boolean bool
	array   []VMuJSValue
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

	// Set the self address
	// Yes, this is cursed
	vm.mujs_state.vmujs_state = voidptr(vm)

	return vm
}

// Get the VMuJS state from a MuJS state
pub fn get_vmujs(mujs_state &C.js_State) &VMuJS {
	return voidptr(mujs_state.vmujs_state)
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
