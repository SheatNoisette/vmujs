module vmujs

fn test_invalid_code_push() {
	// Make a new state
	mut state := new_state(.strict)

	// Simple function
	func := 'var b = '

	// Add to state
	state.push_code(func) or {
		// The code isn't valid
		state.destroy()
		assert true
		return
	}

	// Destroy the state
	state.destroy()
	assert false
}
