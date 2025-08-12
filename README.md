# kcl-compose-spec

- Docker Compose spec: https://github.com/compose-spec/compose-spec
- KCL: https://www.kcl-lang.io/

## kcl

### kcl mod init

```shell
kcl mod init composek
cd composek
```

### kcl mod pkg

```shell
kcl mod pkg --target .build
```

### kcl login

```shell
kcl registry login ghcr.io
```

### kcl mod push

```shell
kcl mod push --tar_path .build/composek_0.1.0.tar oci://ghcr.io/qyvlik/composek
```
