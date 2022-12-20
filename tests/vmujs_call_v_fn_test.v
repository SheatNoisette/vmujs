module vmujstests

import vmujs

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
