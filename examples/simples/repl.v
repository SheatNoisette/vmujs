module main

import vmujs
import os

fn exit_callback(state &vmujs.VMuJSCallback) {
	// Get the state from the State pointer
	mut vm := vmujs.get_vmujs(state)

	// Pop the exit code from the stack
	mut code := vm.pop_int() or { 0 }

	// Exit the program
	exit(code)
}

fn print_callback(state &vmujs.VMuJSCallback) {
	// Get the state from the State pointer
	mut vm := vmujs.get_vmujs(state)

	// Pop the string from the stack
	mut str := vm.pop_string() or { "" }

	// Print the string
	println(str)

	// Push undefined to the stack - No return value
	vm.push_undefined()
}

fn main() {
	// Make a new MuJS state in strict mode
	mut vm := vmujs.new_state(.strict)
	// Destroy the state when we're done
	defer { vm.destroy() }

	// Register a exit function
	vm.register_function("exit", 1, exit_callback)
	// Add a simple printing function
	vm.register_function("print", 1, print_callback)

	println("-- VMUJS Repl --")
	println("Type 'exit()' to exit the repl")
	println("Use 'print()' to print to stdout")

	for {
		// Fancy prompt
		print("> ")

		// Read a line from stdin
		mut line := os.get_line()

		// Evaluate the line - Don't crash on errors
		vm.eval(line) or {}
	}
}
