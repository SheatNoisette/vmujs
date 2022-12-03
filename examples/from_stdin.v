module main

import vmujs
import os

fn main() {
	content := os.get_line()
	context := vmujs.new_state(.strict)
	context.push_code(content) or {
		exit(1)
		return
	}
	context.destroy()
}
