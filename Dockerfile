from ubuntu:20.04

run apt-get update
run apt-get install -y gcc git libgc-dev bash make
run git clone --depth 1 https://github.com/vlang/v.git /v
run cd /v && make -j && ./v symlink

entrypoint ["/bin/bash"]
