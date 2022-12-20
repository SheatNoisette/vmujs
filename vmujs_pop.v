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

// Request to pop a element from the VM stack
[inline]
pub fn (vm &VMuJS) pop(times int) {
	C.js_pop(vm.mujs_state, times)
}

// Pop a int from the VM stack
pub fn (vm &VMuJS) pop_int() !int {
	number := C.js_tointeger(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping int (Is not a int)')
	} else if C.js_isnumber(vm.mujs_state, -1) == 0 {
		return error('Error while popping int (Not a number)')
	}
	vm.pop(1)
	return number
}

// Pop a float from the VM stack
pub fn (vm &VMuJS) pop_float() !f64 {
	number := C.js_tonumber(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping float (Is not a float)')
	} else if C.js_isnumber(vm.mujs_state, -1) == 0 {
		return error('Error while popping float (Not a number)')
	}
	vm.pop(1)
	return number
}

// Pop a string from the VM stack
pub fn (vm &VMuJS) pop_string() !string {
	mut str := ''
	raw_value := C.js_tostring(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping string (Does not exists)')
	} else if C.js_isstring(vm.mujs_state, -1) == 0 {
		return error('Error while popping string (Not a string)')
	}
	unsafe {
		str = cstring_to_vstring(raw_value)
	}
	vm.pop(1)
	return str
}

// Pop a bool from the VM stack
pub fn (vm &VMuJS) pop_bool() !bool {
	number := C.js_toboolean(vm.mujs_state, -1)
	if C.js_isundefined(vm.mujs_state, -1) == 1 {
		return error('Error while popping bool')
	} else if C.js_isboolean(vm.mujs_state, -1) == 0 {
		return error('Error while popping bool (Not a bool)')
	}
	vm.pop(1)
	return match number {
		0 { false }
		else { true }
	}
}
