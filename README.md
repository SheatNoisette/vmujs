# V MuJS

A hand written V bindings for [MuJS](https://mujs.com/).

MuJS is a small, embeddable Javascript interpreter written in ANSI C. It is
designed to be small and simple, and to be easily embedded in other applications.
It is not a full-featured Javascript implementation, but it is a complete
ECMAScript 5.1 implementation.

Is is recommended to use GCC or Clang to compile VMuJS.

**THIS IS A WORK IN PROGRESS! IF YOU HAVE TIME TO SPARE, PLEASE CONTRIBUTE!**

## Status

Not the whole API is implemented yet, but the most important parts are.

Here is a list of what is currently done:
- [x] Raw .c.v bindings
- [ ] Clean up
- [ ] V friendly API
- [ ] General documentation
- [ ] Examples
- [ ] Tests

## Using Docker

You can use the provided Dockerfile to build VMuJS.

```bash
$ docker build -t vmujs .
$ docker run -it --volume="$(pwd)":/work/ --workdir=/work/ --rm vmujs
```

## License
This binding is licensed under the MIT license. See the LICENSE file for
more details.

MuJS is licensed under the ISC license. So, the folder `mujs` is licensed under
the ISC license. Please, see the `mujs/COPYING` file for more details.
