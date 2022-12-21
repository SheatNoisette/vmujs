module vmujstests

import vmujs

fn test_string_map_to_object() {
	mut state := vmujs.new_state(.non_strict)

	map_js := {
		'mystr':  vmujs.VMuJSValue{
			kind: .str
			str: 'test'
		}
		'myint':  vmujs.VMuJSValue{
			kind: .integer
			integer: 123
		}
		'mybool': vmujs.VMuJSValue{
			kind: .boolean
			boolean: true
		}
	}

	state.object_push_map(map_js)

	// Register the object as global
	state.set_global_stack('myobj')

	// Use a variables to destructure the object
	state.eval('
		var mystr = myobj.mystr;
		var myint = myobj.myint;
		var mybool = myobj.mybool;
	') or {
		panic('Could not push code')
	}

	// Check values
	assert state.get_global('mystr').str() == 'test'
	assert state.get_global('myint').int() == 123

	bool_value := state.get_global_bool('mybool') or { panic('mybool is not a boolean') }
	assert bool_value == true

	state.destroy()
}
