module vmujstests

import vmujs

// Push generic
fn test_generic_push_int() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Table of values to push
	elements := [1, 5, 7, 9]

	// Push the elements
	for element in elements {
		state.push_int(element)
	}

	// Pop the elements in reverse order
	for i := elements.len - 1; i >= 0; i-- {
		value := state.pop_int() or {
			assert false
			return
		}
		assert value == elements[i]
	}

	// Destroy the state
	state.destroy()
}

// Push a string
fn test_string_push() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a string
	state.push_string('Hello, World!')

	// Pop the string
	value := state.pop_string() or {
		assert false
		return
	}
	assert value == 'Hello, World!'

	// Destroy the state
	state.destroy()
}

// Push a string, a number, and a boolean
// This checks that the stack is properly cleaned up
fn test_multiple_push() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a string
	state.push_string('Hello, World!')

	// Push a number
	state.push_int(42)

	// Push a boolean
	state.push_bool(true)

	// Pop the boolean
	value := state.pop_bool() or {
		assert false
		return
	}
	assert value

	// Pop the number
	valuetwo := state.pop_int() or {
		assert false
		return
	}
	assert valuetwo == 42

	// Pop the string
	valuethree := state.pop_string() or {
		assert false
		return
	}
	assert valuethree == 'Hello, World!'

	// Destroy the state
	state.destroy()
}

// Push a bool and try it as a number
fn test_push_bool_and_pop_as_int() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a bool
	state.push_bool(true)

	// Try to pop it as a number
	value := state.pop_int() or {
		// Destroy the state
		state.destroy()
		assert true
		return
	}

	// Destroy the state
	state.destroy()
	// It should not be possible to pop a bool as a number
	assert false
}

// Push a number and try it as a bool
fn test_push_int_and_pop_as_bool() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a number
	state.push_int(42)

	// Try to pop it as a bool
	value := state.pop_bool() or {
		// Destroy the state
		state.destroy()
		assert true
		return
	}

	// Destroy the state
	state.destroy()
	// It should not be possible to pop a number as a bool
	assert false
}

// Push a number and try it as a string
fn test_push_int_and_pop_as_string() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a number
	state.push_int(42)

	// Try to pop it as a string
	value := state.pop_string() or {
		// Destroy the state
		state.destroy()
		assert true
		return
	}
	assert value == '42'

	// Destroy the state
	state.destroy()
}

// Push a bool and try it as a float (it is valid to pop a int as a float)
fn test_push_int_and_pop_as_float() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a int
	state.push_bool(true)

	// Try to pop it as a float
	value := state.pop_float() or {
		// Destroy the state
		state.destroy()
		assert true
		return
	}

	// Destroy the state
	state.destroy()
	// It should not be possible to pop a int as a float
	assert false
}

// Push a float and get a int
fn test_push_float_and_pop_as_int() {
	// Make a new state
	mut state := vmujs.new_state(.strict)

	// Push a float
	state.push_float(42.0)

	// Try to pop it as a int
	value := state.pop_int() or {
		// Destroy the state
		state.destroy()
		panic('Could not pop float as int')
	}

	// Destroy the state
	state.destroy()
	// It should not be possible to pop a float as a int
	assert value == 42
}

fn test_get_types_stack() {
	mut state := vmujs.new_state(.non_strict)

	state.push_string('Hello, World!')
	state.push_bool(true)
	state.push_float(42.0)
	state.push_int(42)

	// A MuJS Value store int and float/double as the same type
	// There's no way to know if it's a int or a float
	assert state.stack_get_type() == .float
	state.pop(1)
	assert state.stack_get_type() == .float
	state.pop(1)
	assert state.stack_get_type() == .boolean
	state.pop(1)
	assert state.stack_get_type() == .str
	state.pop(1)
}

fn test_pop_array_floats() {
	mut state := vmujs.new_state(.non_strict)

	state.eval('var array = [1, 2, 3, 4, 5];') or { panic('Could not push code') }

	// Place the array on the stack
	state.push_global('array')

	// Pop the array
	array := state.pop_array() or { panic('Could not pop array') }

	// Note that MuJS stores all numbers as doubles
	assert array.len == 5
	assert array[0].float == 1.0
	assert array[1].float == 2.0
	assert array[2].float == 3.0
	assert array[3].float == 4.0
	assert array[4].float == 5.0

	state.destroy()
}

fn test_pop_array_multiple_types() {
	mut state := vmujs.new_state(.non_strict)

	state.eval('var array = [1, "Hello", true, 2.0, false];') or { panic('Could not push code') }

	// Place the array on the stack
	state.push_global('array')

	// Pop the array
	array := state.pop_array() or { panic('Could not pop array') }

	// Note that MuJS stores all numbers as doubles
	assert array.len == 5
	assert array[0].float == 1.0
	assert array[1].str == 'Hello'
	assert array[2].boolean == true
	assert array[3].float == 2.0
	assert array[4].boolean == false

	state.destroy()
}
