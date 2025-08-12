# kcl-compose-spec

- Docker Compose spec: https://github.com/compose-spec/compose-spec
- KCL: https://www.kcl-lang.io/

## kcl

### kcl mod init

```shell
kcl mod init kcl-compose-spec
```

### kcl mod pkg

```shell
cd kcl-compose-spec
kcl mod pkg --target ../.build
```

### kcl login

```shell
kcl registry login ghcr.io
```

### kcl mod push

```shell
kcl mod push --tar_path .build/kcl-compose-spec_0.1.0.tar oci://ghcr.io/qyvlik/kcl-compose-spec
```
