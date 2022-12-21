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
	state.set_function_data('simple', 'test', 'Hello')

	state.push_code('simple()') or { panic('failed to push code') }

	assert state.get_function_data('simple')['test'] == 'Hello World!'
}

// }

// test 2 {

fn simple_isqrt_callback(vm &C.js_State) {
	// Get VMuJS state - From which it was called
	mut state := vmujs.get_vmujs(vm)

	// Get the 1st argument
	arg := state.pop_int() or { panic('(callback) failed to pop int') }

	// Push the result
	state.push_int(int(math.sqrt(arg)))
}

fn test_simple_isqrt() {
	mut state := vmujs.new_state(.strict)

	state.register_function('isqrt', 1, simple_isqrt_callback)

	state.push_code('var out = isqrt(9);') or { panic('failed to push code') }

	number := state.get_global_int('out') or { panic('failed to get global') }

	assert number == 3
}

// }
// test 3 {

fn simple_add_array_together_callback(vm &C.js_State) {
	// Get VMuJS state - From which it was called
	mut state := vmujs.get_vmujs(vm)

	// Get the 1st argument
	arg := state.pop_array() or { panic('(callback) failed to pop array') }

	// Push the result
	mut sum := int(0)
	for i in 0 .. arg.len {
		sum += int(arg[i].float)
	}
	state.push_int(sum)
}

fn test_simple_add_array_together() {
	mut state := vmujs.new_state(.strict)

	state.register_function('add_array_together', 1, simple_add_array_together_callback)

	state.push_code('var out = add_array_together([1, 2, 3, 4, 5]);') or {
		panic('failed to push code')
	}

	number := state.get_global_int('out') or { panic('failed to get global') }

	assert number == 15
}

// }
// test 4 {

fn simple_add_two_arrays_together_callback(vm &C.js_State) {
	// Get VMuJS state - From which it was called
	mut state := vmujs.get_vmujs(vm)

	// Get the 1st argument
	arg1 := state.pop_array() or { panic('(callback) failed to pop array') }
	arg2 := state.pop_array() or { panic('(callback) failed to pop array') }

	// Push the result
	mut array := []vmujs.VMuJSValue{}

	for i in 0 .. arg1.len {
		array << vmujs.VMuJSValue{
			kind: .float
			float: arg1[i].float + arg2[i].float
		}
	}

	state.push_array(array)
}

fn test_simple_add_two_arrays_together() {
	mut state := vmujs.new_state(.strict)

	state.register_function('add_two_arrays_together', 2, simple_add_two_arrays_together_callback)

	state.push_code('var out = add_two_arrays_together([1, 2, 3, 4, 5], [1, 2, 3, 4, 5]);') or {
		panic('failed to push code')
	}

	array := state.get_global_array('out') or { panic('failed to get global') }

	assert array.len == 5
	assert array[0].float == 2
	assert array[1].float == 4
	assert array[2].float == 6
	assert array[3].float == 8
	assert array[4].float == 10
}

// }
