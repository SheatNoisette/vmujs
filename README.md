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
- [ ] Examples
- [ ] General documentation
- [ ] Clean up

V friendly API feature support:
- [x] Basic types
- [X] Global variables (int, float, string, bool)
- [X] Call JS functions from V
- [X] Call V functions from JS
- [ ] Custom error handlers
- [ ] JS Objects

If you need a feature that is not listed, you can call the raw MuJS API from V using `C` types.

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
