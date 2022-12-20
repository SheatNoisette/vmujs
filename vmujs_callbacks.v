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

// V and MuJS interop

// Function type for the callback
type VMuJSValueFnCallback = fn (&C.js_State)

// Call a function from JS
pub fn (vm &VMuJS) call_function(name string, values ...VMuJSValue) ! {
	// Find the function
	C.js_getglobal(vm.mujs_state, name.str)

	// Push null as this
	vm.push_null()

	// Push the arguments
	for value in values {
		match value.kind {
			.integer {
				vm.push_int(value.integer)
			}
			.float {
				vm.push_float(value.float)
			}
			.str {
				vm.push_string(value.str)
			}
			.null {
				vm.push_null()
			}
			.boolean {
				vm.push_bool(value.boolean)
			}
			else {}
		}
	}

	// Call the function
	C.js_call(vm.mujs_state, values.len)
}

// Get function data
[inline]
pub fn (vm &VMuJS) get_function_data(name string) map[string]string {
	return vm.fn_data[name]
}

// Set data for a function callback (for JS -> V)
[inline]
pub fn (mut vm VMuJS) set_function_data(fn_name string, key string, data string) {
	vm.fn_data[fn_name][key] = data
}

// Register a V function to be called from JS
pub fn (mut vm VMuJS) register_function(name string, number_of_args int, callback VMuJSValueFnCallback) {
	// Add function to the map
	vm.fn_map[name] = callback

	// Register the function
	unsafe {
		callback_ptr := voidptr(callback)
		C.js_newcfunction(vm.mujs_state, &C.js_CFunction(callback_ptr), name.str, number_of_args)
	}
	C.js_setglobal(vm.mujs_state, name.str)
}
