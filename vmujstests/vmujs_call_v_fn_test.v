module vmujstests

import vmujs
import math

// test 1 {

fn simple_vfunction_call_callback(vm &C.js_State) {
	// Get VMuJS state - From which it was called
	mut state := vmujs.get_vmujs(vm)

	// Change the function data
	state.set_function_data('simple', 'test', 'Hello World!')

	// The function returns nothing
	state.push_undefined()
}

fn test_simple_vfunction_call() {
	mut state := vmujs.new_state(.strict)

	state.register_function('simple', 0, simple_vfunction_call_callback)
	state.set_function_data('simple', "test", "Hello")

	state.push_code("simple()") or {
		panic('failed to push code')
	}

	assert state.get_function_data('simple')['test'] == 'Hello World!'
}

// }

// test 2 {

fn simple_isqrt_callback(vm &C.js_State) {
	// Get VMuJS state - From which it was called
	mut state := vmujs.get_vmujs(vm)

	// Get the 1st argument
	arg := state.pop_int() or {
		panic('(callback) failed to pop int')
	}

	// Push the result
	state.push_int(int(math.sqrt(arg)))
}

fn test_simple_isqrt() {
	mut state := vmujs.new_state(.strict)

	state.register_function('isqrt', 1, simple_isqrt_callback)

	state.push_code("var out = isqrt(9);") or {
		panic('failed to push code')
	}

	number := state.get_global_int('out') or {
		panic('failed to get global')
	}

	assert number == 3
}

// }
