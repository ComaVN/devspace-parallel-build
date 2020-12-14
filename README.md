# devspace-parallel-build

To reproduce:
* Change `dockerregistry.example.com` to whatever docker registry you have access to
* run `devspace dev --build-sequential`:
```
$ devspace dev --build-sequential
(...)
[info]   Building image 'dockerregistry.example.com/comavn-devspace-parallel-build-bar:dev-comavn-5uuNAY' with engine 'docker'
(...)
Step 1/5 : FROM alpine:3.12
 ---> d6e46aa2470d
Step 2/5 : ARG timestamp
 ---> Running in d64fbb9a0419
Removing intermediate container d64fbb9a0419
 ---> f534d493f7b4
Step 3/5 : RUN sleep 3
 ---> Running in b33a5ce08d4e
Removing intermediate container b33a5ce08d4e
 ---> f5f7c9ebef4f
Step 4/5 : RUN dd if=/dev/urandom of=/data.bin bs=16 count=1
 ---> Running in 0935d585a806
1+0 records in
1+0 records out
(...)
[info]   Building image 'dockerregistry.example.com/comavn-devspace-parallel-build-foo:dev-comavn-5uuNAY' with engine 'docker'
(...)
Step 1/5 : FROM alpine:3.12
 ---> d6e46aa2470d
Step 2/5 : ARG timestamp
 ---> Using cache
 ---> f534d493f7b4
Step 3/5 : RUN sleep 3
 ---> Using cache
 ---> f5f7c9ebef4f
Step 4/5 : RUN dd if=/dev/urandom of=/data.bin bs=16 count=1
 ---> Using cache
 ---> 7a1bbb0a6986
(...)
[done] √ Successfully deployed dev with kubectl
(...)
[info]   Starting log streaming for containers that use images defined in devspace.yaml
[comavn-devspace-parallel-build-796f4f78cb-2v647:comavn-devspace-parallel-build-foo] 42e934feae6495d1c7eb9f2e558d211c  /data.bin
[comavn-devspace-parallel-build-796f4f78cb-2v647:comavn-devspace-parallel-build-bar] 42e934feae6495d1c7eb9f2e558d211c  /data.bin
```
* Ctrl-C to stop `devspace dev`
* start `devspace dev`  without `--build-sequential`:
```
$ devspace dev
(...)
[done] √ Done building image dockerregistry.example.com/comavn-devspace-parallel-build-bar:dev-comavn-L5eJUh (bar)
[done] √ Done building image dockerregistry.example.com/comavn-devspace-parallel-build-foo:dev-comavn-L5eJUh (foo)
deployment.apps/comavn-devspace-parallel-build configured
[done] √ Successfully deployed dev with kubectl
(...)
[info]   Starting log streaming for containers that use images defined in devspace.yaml
[comavn-devspace-parallel-build-55846b8c88-9k6kd:comavn-devspace-parallel-build-foo] 4f2b868314f3c2ea982978607a77f7c7  /data.bin
[comavn-devspace-parallel-build-55846b8c88-9k6kd:comavn-devspace-parallel-build-bar] 0d5e5aa0c2ea6910ba74505c37fa5d65  /data.bin
```

So *with* `--build-sequential` the image layers are built only once and *without* it the image layers are built twice.
