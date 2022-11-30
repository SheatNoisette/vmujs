module vmujs

fn test_get_int_global() {

	// Make a new state
    mut state := new_state(false)

	// Simple function
	func := "var i = 42;"

	// Add to state
	state.push_code(func)

	assert state.get_global_int("i") == 42

	// Destroy the state
	state.destroy()
}

fn test_get_float_global() {

	// Make a new state
	mut state := new_state(false)

	// Simple function
	func := "var f = 42.0;"

	// Add to state
	state.push_code(func)

	assert state.get_global_float("f") == 42.0

	// Destroy the state
	state.destroy()
}

fn test_get_string_global() {

	// Make a new state
	mut state := new_state(false)

	// Simple function
	func := "var s = 'hello';"

	// Add to state
	state.push_code(func)

	assert state.get_global_string("s") == 'hello'

	// Destroy the state
	state.destroy()
}

fn test_get_bool_global() {

	// Make a new state
	mut state := new_state(false)

	// Simple function
	func := "var b = true;"

	// Add to state
	state.push_code(func)

	assert state.get_global_bool("b") == true

	// Destroy the state
	state.destroy()
}
