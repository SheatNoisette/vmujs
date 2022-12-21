module main

import vmujs
import os

fn main() {
	content := os.get_line()
	context := vmujs.new_state(.strict)
	context.eval(content) or {
		exit(1)
		return
	}
	context.destroy()
}
