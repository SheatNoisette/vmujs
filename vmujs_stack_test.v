module vmujs

// Push generic
fn test_generic_push_int() {
	// Make a new state
	mut state := new_state(.strict)

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
	mut state := new_state(.strict)

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
fn test_push() {
	// Make a new state
	mut state := new_state(.strict)

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
