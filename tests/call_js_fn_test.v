module vmujstests

import vmujs

fn test_simple_function_call() {
	mut state := vmujs.new_state(.strict)

	state.eval('function test() { return 1; }') or {
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
	mut state := vmujs.new_state(.strict)

	state.eval('function test(a, b) { return a + b; }') or {
		state.destroy()
		assert false
		return
	}

	state.call_function('test', vmujs.VMuJSValue{
		kind: .integer
		integer: 1
	}, vmujs.VMuJSValue{
		kind: .integer
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

fn test_function_call_isqrt() {
	mut state := vmujs.new_state(.strict)

	// Simple integer square root function
	// Floating point is arch and platform dependent
	state.eval('function isqrt(n) {
		var x = n;
		var y = 1;
		while (x > y) {
			x = (x + y) / 2;
			y = n / x;
		}
		return x;
	}') or {
		state.destroy()
		assert false
		return
	}

	state.call_function('isqrt', vmujs.VMuJSValue{
		kind: .integer
		integer: 9
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

	state.destroy()
}
