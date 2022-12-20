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

// Import and add objects into MuJS

// Create a new MuJS Object
pub fn (vm &VMuJS) new_object() {
	C.js_newobject(vm.mujs_state)
}

// Push Map to vm Stack as JS Object
pub fn (vm &VMuJS) object_push_map(input map[string]VMuJSValue) {
	// Create a new Object
	vm.new_object()

	// Loop through the map
	for key, value in input {
		// Push the key depending on the type
		match value.kind {
			.str {
				vm.push_string(value.str)
			}
			.integer {
				vm.push_int(value.integer)
			}
			.boolean {
				vm.push_bool(value.boolean)
			}
			.null {
				vm.push_null()
			}
			else {
				panic('Unsupported type')
			}
		}

		// Push the value
		C.js_setproperty(vm.mujs_state, -2, key.str)
	}
}
