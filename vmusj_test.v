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
