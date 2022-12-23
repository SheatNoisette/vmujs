module vmujstests

import vmujs

fn test_invalid_code_push() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	func := 'var b = '

	// Add to state
	state.eval(func) or {
		// The code isn't valid
		state.destroy()
		assert true
		return
	}

	// Destroy the state
	state.destroy()
	assert false
}

// Store User data - test {
struct Test_struct_userdata {
	a int
	b string
	d f64
}

fn test_store_data() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	data := &Test_struct_userdata{
		a: 10
		b: 'hello'
		d: 10.5
	}

	// Store the data
	state.set_user_data(data)

	// Get the data
	data_stored := &Test_struct_userdata(state.get_user_data())

	// Check the data
	assert data_stored.a == data.a
	assert data_stored.b == data.b
	assert data_stored.d == data.d

	// Register a function
	state.register_function('test', 0, fn (vm &vmujs.VMuJSCallback) {

		// Get the MuJS state
		mut callback_state := vmujs.get_vmujs(vm)

		// Get the data
		data_stored := &Test_struct_userdata(callback_state.get_user_data())

		// Store to callback data
		callback_state.set_function_data('test', 'data_a', data_stored.a.str())
		callback_state.set_function_data('test', 'data_b', data_stored.b)
		callback_state.set_function_data('test', 'data_d', data_stored.d.str())
	})

	// Call the function
	state.eval('test()') or {
		panic(err)
	}

	// Get the data
	data_callback := state.get_function_data('test')
	data_a := data_callback['data_a']
	data_b := data_callback['data_b']
	data_d := data_callback['data_d']

	// Check the data
	assert data_a == data.a.str()
	assert data_b == data.b
	assert data_d == data.d.str()
}

// }
