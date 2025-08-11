# kcl-compose-spec

- Docker Compose spec: https://github.com/compose-spec/compose-spec
- KCL: https://www.kcl-lang.io/

## kcl

### kcl mod init

```shell
kcl mod init compose-spec
```

### kcl mod pkg

```shell
cd compose-spec
kcl mod pkg --target ../.build
```

~~### kcl login~~

```shell
kcl registry login artifacthub.io
```

~~### kcl mod push~~

```shell
kcl mod push --tar_path .build/compose-spec_0.1.0.tar artifacthub.io
```

or

```shell
cd compose-spec
kcl mod push artifacthub.io
```
