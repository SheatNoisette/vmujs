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
pub fn (vm &VMuJS) push_generic[T](value T) {
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
