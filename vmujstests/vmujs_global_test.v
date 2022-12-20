module vmujstests

import vmujs

fn test_get_int_global() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	func := 'var i = 42;'

	// Add to state
	state.push_code(func)!

	value := state.get_global_int('i') or { 0 }

	assert value == 42

	// Destroy the state
	state.destroy()
}

fn test_get_float_global() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	func := 'var f = 42.0;'

	// Add to state
	state.push_code(func)!

	value := state.get_global_float('f') or { 0.0 }

	assert value == 42.0

	// Destroy the state
	state.destroy()
}

fn test_get_string_global() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	func := "var s = 'hello';"

	// Add to state
	state.push_code(func)!

	value := state.get_global_string('s') or { '' }

	assert value == 'hello'

	// Destroy the state
	state.destroy()
}

fn test_get_bool_global() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	func := 'var b = true;'

	// Add to state
	state.push_code(func)!

	value := state.get_global_bool('b') or { false }

	assert value == true

	// Destroy the state
	state.destroy()
}

fn test_two_globals() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	glob1 := 'var i = 42;'
	glob2 := 'var j = 32;'

	// Add to state
	state.push_code(glob1)!
	state.push_code(glob2)!

	var_one := state.get_global_int('i') or { 0 }
	var_two := state.get_global_int('j') or { 0 }

	assert var_one == 42
	assert var_two == 32

	// Destroy the state
	state.destroy()
}

fn test_invalid_global_int() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Simple function
	content := 'var i = 42;'

	// Add to state
	state.push_code(content)!

	value := state.get_global_int('j') or {
		state.destroy()
		assert true
		return
	}

	value_string := state.get_global_string('j') or {
		state.destroy()
		assert true
		return
	}

	value_double := state.get_global_float('j') or {
		state.destroy()
		assert true
		return
	}

	// Destroy the state
	state.destroy()
	assert false
}
