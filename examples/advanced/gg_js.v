module main

import gg
import gx
import vmujs

const (
	window_width  = 800
	window_height = 600
)

struct AppContext {
mut:
	vmujs_state &vmujs.VMuJS
	ggcontext   &gg.Context
}

// Draw a Rectangle - draw_rectangle(x, y, w, h, color)
fn draw_rectangle_callback(vm &vmujs.VMuJSCallback) {
	// Get the state
	mut state := vmujs.get_vmujs(vm)
	// Get the app context
	mut app := &AppContext(state.get_user_data())

	// This is a stack, the last value pushed is the first to be popped
	color := state.pop_int() or { return }
	h := state.pop_float() or { return }
	w := state.pop_float() or { return }
	y := state.pop_float() or { return }
	x := state.pop_float() or { return }

	r := u8((color >> 16) & 0xFF)
	g := u8((color >> 8) & 0xFF)
	b := u8(color & 0xFF)

	app.ggcontext.draw_rect_filled(f32(x), f32(y), f32(w), f32(h), gx.rgb(r, g, b))

	state.push_undefined()
}

// Print to stdout - println(str)
fn println_callback(vm &vmujs.VMuJSCallback) {
	// Get the state
	mut state := vmujs.get_vmujs(vm)

	str := state.pop_string() or { return }

	println(str)

	state.push_undefined()
}

// Render a pixel
fn frame(mut app AppContext) {
	app.ggcontext.begin()
	// Call the loop function
	app.vmujs_state.call_function('loop') or { println('Error calling loop function') }
	app.ggcontext.end()
}

fn main() {
	mut app := AppContext{
		vmujs_state: vmujs.new_state(.strict)
		ggcontext: 0
	}

	app.ggcontext = gg.new_context(
		bg_color: gx.rgb(255, 255, 255)
		width: window_width
		height: window_height
		window_title: 'GG VMuJS Example'
		frame_fn: frame
		user_data: &app
	)

	// Set the user data for callbacks
	app.vmujs_state.set_user_data(&app)

	// Add the draw_square function
	app.vmujs_state.register_function('draw_rectangle', 5, draw_rectangle_callback)
	// Add the println function
	app.vmujs_state.register_function('println', 1, println_callback)

	// Eval the script
	app.vmujs_state.eval($embed_file('gg_js_demo.js').to_string()) or {
		println('Error evaluating script')
		return
	}

	// Call the init function
	app.vmujs_state.call_function('init') or {
		println('Error calling init function')
		return
	}

	// Start GG context
	app.ggcontext.run()
}
