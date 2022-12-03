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

// Type of a JS Value
pub enum VMuJSType {
	integer
	float
	str
	null
}

// Base struct for arguments for the callback
pub struct VMuJSValueFn {
	value_type VMuJSType

	integer int
	float   f64
	str     string
}

// Call a function from JS
pub fn (vm &VMuJS) call_function(name string, values ...VMuJSValueFn) ! {
	// Find the function
	C.js_getglobal(vm.mujs_state, name.str)

	// Push null as this
	vm.push_null()

	// Push the arguments
	for value in values {
		match value.value_type {
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
		}
	}

	// Call the function
	C.js_call(vm.mujs_state, values.len)
}
