# V MuJS

![tests](https://github.com/SheatNoisette/vmujs/actions/workflows/tests.yml/badge.svg)

A hand written V bindings for [MuJS](https://mujs.com/).

MuJS is a small, embeddable Javascript interpreter written in ANSI C. It is
designed to be small and simple, and to be easily embedded in other applications.
It is not a full-featured Javascript implementation, but it is a complete
ECMAScript 5.1 implementation.

Is is recommended to use GCC or Clang to compile VMuJS.

**THIS IS A WORK IN PROGRESS! IF YOU HAVE TIME TO SPARE, PLEASE CONTRIBUTE!**

Important note:
---

**This module will remain in 0.0.0 unless VMuJS API's is finalized**

## Status

Please, note that this is a work in progress. The API is not stable and may change at any time.

Here is a list of what is currently done:
- [x] Raw .c.v bindings
- [ ] V friendly API
- [X] Examples
- [X] Basic general documentation
- [ ] General documentation (Markdown)
- [ ] Clean up

V friendly API feature support:
- [X] Eval JS code
- [x] Basic types
- [X] Global variables (int, float, string, bool)
- [X] Call JS functions from V
- [X] Call V functions from JS
- [ ] Arrays
  - [X] Basic arrays (int, float, string, bool)
  - [ ] Recursive arrays
- [ ] Custom error handlers
- [ ] JS Objects

If you need a feature that is not listed, you can call the raw MuJS API from V using `C` types.

## Quick start

First, install VMuJS using VPM:
```bash
$ v install --git https://github.com/SheatNoisette/vmujs
```
As the module is not yet in VPM, you need to use the `--git` flag.

Then, you can use VMuJS in your V projects:
```v
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
```

## Examples

You can find some examples in the `examples` folder. These examples goes a bit
further than the quick start example.

## Using Docker

You can use the provided Dockerfile to build VMuJS.

```bash
$ docker build -t vmujs .
$ docker run -it --volume="$(pwd)":/work/ --workdir=/work/ --rm vmujs
```

## Running tests

As there's many tests, they have been moved into a separate directory with their
own module. This enables a proper API testing.

```bash
# You may need to do a symlink to the mujs folder
# macOS
# ln -s $(PWD) /Users/$(whoami)/.vmodules/vmujs
# Linux
# ln -s $(PWD) /home/$(whoami)/.vmodules/vmujs
$ v test .
```

## Documentation

VMuJS is based on MuJS. You can find the documentation
[here](https://mujs.com/docs.html).

The VMuJS documentation can be generated using `vdoc`:
```bash
$ v doc -o doc/vmujs.md .
```

## License
This binding is licensed under the MIT license. See the LICENSE file for
more details.

MuJS is licensed under the ISC license. So, the folder `mujs` is licensed under
the ISC license. See the `mujs/COPYING` file for more details.
