import vmujs

fn main() {
    // Create a new VM with strict mode
    mut vm := vmujs.new_state(.strict)

	// Register a function - print, with 1 argument
	vm.register_function('print', 1, fn (vm &vmujs.VMuJSCallback) {

		// Get the MuJS state
		mut callback_state := vmujs.get_vmujs(vm)

        // Pop the argument from the stack
        argument := callback_state.pop_string() or { panic("Can't pop !") }

        // Print the argument
        println(argument)

        // Return nothing - undefined
        callback_state.push_undefined()
	})

    // Eval a line of JS
    vm.eval('print("Hello World!")') or { panic("Can't eval !") }

    // Destroy the VM
    vm.destroy()
}
