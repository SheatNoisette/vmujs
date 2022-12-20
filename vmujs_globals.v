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

// Get a int global variable from the state
pub fn (vm &VMuJS) get_global_int(name string) !int {
	C.js_getglobal(vm.mujs_state, name.str)
	number := vm.pop_int() or { return error('Error while getting global int') }
	return number
}

// Get a float global variable from the state
pub fn (vm &VMuJS) get_global_float(name string) !f64 {
	C.js_getglobal(vm.mujs_state, name.str)
	number := vm.pop_float() or { return error('Error while getting global float') }
	return number
}

// Get a string global variable from the state
pub fn (vm &VMuJS) get_global_string(name string) !string {
	C.js_getglobal(vm.mujs_state, name.str)
	str := vm.pop_string() or { return error('Error while getting global string') }
	return str
}

// Get a bool global variable from the state
pub fn (vm &VMuJS) get_global_bool(name string) !bool {
	C.js_getglobal(vm.mujs_state, name.str)
	// Pop from the stack
	value := vm.pop_bool() or { return error('Error while getting global bool') }
	return value
}
