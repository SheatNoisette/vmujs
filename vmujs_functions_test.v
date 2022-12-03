module vmujs

fn test_simple_function_call() {
	mut state := new_state(.strict)

	state.push_code('function test() { return 1; }') or {
		state.destroy()
		assert false
		return
	}

	state.call_function('test') or {
		state.destroy()
		assert false
		return
	}

	// Pop the return value
	value := state.pop_int() or {
		state.destroy()
		assert false
		return
	}

	// Check the return value
	assert value == 1
}

fn test_args_function_call() {
	mut state := new_state(.strict)

	state.push_code('function test(a, b) { return a + b; }') or {
		state.destroy()
		assert false
		return
	}

	state.call_function('test', VMuJSValueFn{
		value_type: .integer
		integer: 1
	}, VMuJSValueFn{
		value_type: .integer
		integer: 2
	}) or {
		state.destroy()
		assert false
		return
	}

	// Pop the return value
	value := state.pop_int() or {
		state.destroy()
		assert false
		return
	}

	// Check the return value
	assert value == 3
}
