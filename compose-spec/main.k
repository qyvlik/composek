# https://github.com/compose-spec/compose-spec

import regex

# https://docs.docker.com/reference/compose-file/services/#blkio_config
schema DeviceBps:
    path: str
    rate: str

schema DeviceIops:
    path: str
    rate: int

schema WeightDevice:
    path: str
    weight: int

schema BlkioConfig:
    """
    Modify the proportion of bandwidth allocated to a service relative to other services. Takes an integer value between 10 and 1000, with 500 being the default.
    """
    weight?: int
    """
    Fine-tune bandwidth allocation by device. Each item in the list must have two keys:

    path: Defines the symbolic path to the affected device.
    weight: An integer value between 10 and 1000.
    """
    weight_device?: [WeightDevice]
    """
    Set a limit in bytes per second for read / write operations on a given device. Each item in the list must have two keys:

    path: Defines the symbolic path to the affected device.
    rate: Either as an integer value representing the number of bytes or as a string expressing a byte value.
    """
    device_read_bps?: DeviceBps
    device_wirte_bps?: DeviceBps
    """
    Set a limit in operations per second for read / write operations on a given device. Each item in the list must have two keys:

    path: Defines the symbolic path to the affected device.
    rate: As an integer value representing the permitted number of operations per second.
    """
    device_read_iops?: DeviceIops
    device_wirte_iops?: DeviceIops

schema Cgroup:
    host?: str
    private?: str

# https://docs.docker.com/reference/compose-file/services/#configs
schema ServiceConfig:
    source: str
    target: str
    uid: str
    gid: str
    mode: str

schema CredentialSpec:
    file?: str
    registry?: str

schema DependsOn:
    restart: bool
    condition: str
    required: bool = False

    check:
        condition in ["service_started", "service_healthy", "service_completed_successfully"]

schema DriverOpts:
    [str]: str

schema Extends:
    file: str
    service: str

schema Gpus:
    driver: str
    count: int

schema Healthcheck:
    test: str | [str]
    interval: str
    timeout: str
    retries: int
    start_period: str
    start_interval: str

schema Logging:
    driver: str
    options?: {str:str}

schema Port:
    target: int
    # 8080, 8080-8081
    published: str
    host_ip?: str
    $protocol = "tcp"
    app_protocol: str
    mode?: str
    name?: str

    check:
        $protocol in ["tcp", "udp"]

# https://docs.docker.com/compose/how-tos/lifecycle/
schema Lifecycle:
    command: str
    user?: str
    privileged?: bool
    environment?: {str:any} | [str]

schema ServiceSecret:
    # source: The name of the secret as it exists on the platform.
    source: str
    # target: The name of the file to be mounted in /run/secrets/ in the service's task container, or absolute path of the file if an alternate location is required. Defaults to source if not specified.
    target: str
    # uid and gid: The numeric uid or gid that owns the file within /run/secrets/ in the service's task containers. Default value is USER.
    uid: str
    gid: str
    # mode: The permissions for the file to be mounted in /run/secrets/ in the service's task containers, in octal notation. The default value is world-readable permissions (mode 0444). The writable bit must be ignored if set. The executable bit may be set.
    mode: str

schema StorageOpt:
    size: str

schema ServiceVolumeOptions:
    nocopy: bool
    subpath: str

schema ServiceVolumeTmpfs:
    size: int
    mode: str

schema ServiceVolume:
    $type: str
    source: str
    target: str
    read_only?: bool
    bind?: str
    volume?: ServiceVolumeOptions
    tmpfs?: ServiceVolumeTmpfs
    consistency?: str

    check:
        $type in ["volume", "bind", "tmpfs", "npipe", "cluster"]
        bind in ["propagation", "create_host_path", "selinux"]

schema UlimitsNofile:
    soft?: int
    hard?: int

schema Ulimits:
    nproc?: int
    nofile?: UlimitsNofile

schema Build:
    # https://docs.docker.com/reference/compose-file/build/#additional_contexts
    additional_contexts?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/build/#args
    args?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/build/#context
    context?: str
    # https://docs.docker.com/reference/compose-file/build/#cache_from
    cache_from?: [str]
    # https://docs.docker.com/reference/compose-file/build/#cache_to
    cache_to?: [str]
    # https://docs.docker.com/reference/compose-file/build/#dockerfile
    dockerfile?: str
    # https://docs.docker.com/reference/compose-file/build/#dockerfile_inline
    dockerfile_inline?: str
    # https://docs.docker.com/reference/compose-file/build/#entitlements
    entitlements?: [str]
    # https://docs.docker.com/reference/compose-file/build/#extra_hosts
    extra_hosts?: [str]
    # https://docs.docker.com/reference/compose-file/build/#isolation
    isolation?: str
    # https://docs.docker.com/reference/compose-file/build/#labels
    labels?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/build/#network
    network?: str
    # https://docs.docker.com/reference/compose-file/build/#no_cache
    no_cache?: bool
    # https://docs.docker.com/reference/compose-file/build/#platforms
    platforms?: [str]
    # https://docs.docker.com/reference/compose-file/build/#privileged
    privileged?: bool
    # https://docs.docker.com/reference/compose-file/build/#pull
    pull?: bool
    # https://docs.docker.com/reference/compose-file/build/#secrets
    secrets?: [str] | [ServiceSecret]
    # https://docs.docker.com/reference/compose-file/build/#ssh
    ssh?: [str]
    # https://docs.docker.com/reference/compose-file/build/#shm_size
    shm_size?: int
    # https://docs.docker.com/reference/compose-file/build/#tags
    tags?: [str]
    # https://docs.docker.com/reference/compose-file/build/#target
    target?: str
    # https://docs.docker.com/reference/compose-file/build/#ulimits
    ulimits?: Ulimits

# https://docs.docker.com/reference/compose-file/services/#env_file
schema ServiceEnvFile:
    path?: str
    required?: bool = True
    format?: str

    check:
        format in ["raw"]

# https://docs.docker.com/reference/compose-file/services/
schema Service:
    """
    annotations defines annotations for the container. annotations can use either an array or a map.
    """
    # https://docs.docker.com/reference/compose-file/services/#annotations
    annotations?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/services/#attach
    """
    When attach is defined and set to false Compose does not collect service logs, until you explicitly request it to.

    The default service configuration is attach: true.
    """
    attach?: bool
    # https://docs.docker.com/reference/compose-file/build/
    build?: str | Build
    # https://docs.docker.com/reference/compose-file/services/#blkio_config
    blkio_config?: BlkioConfig
    # https://docs.docker.com/reference/compose-file/services/#cpu_count
    cpu_count?: float
    # https://docs.docker.com/reference/compose-file/services/#cpu_percent
    cpu_percent?: float
    # https://docs.docker.com/reference/compose-file/services/#cpu_shares
    cpu_shares?: float
    # https://docs.docker.com/reference/compose-file/services/#cpu_period
    cpu_period?: float
    # https://docs.docker.com/reference/compose-file/services/#cpu_quota
    cpu_quota?: float
    # https://docs.docker.com/reference/compose-file/services/#cpu_rt_runtime
    cpu_rt_runtime?: str
    # https://docs.docker.com/reference/compose-file/services/#cpu_rt_period
    cpu_rt_period?: str
    # https://docs.docker.com/reference/compose-file/services/#cpus
    cpus?: str
    # https://docs.docker.com/reference/compose-file/services/#cpuset
    cpuset?: str
    # https://docs.docker.com/reference/compose-file/services/#cap_add
    # https://man7.org/linux/man-pages/man7/capabilities.7.html
    cap_add?: [str]
    # https://docs.docker.com/reference/compose-file/services/#cap_drop
    cap_drop?: [str]
    # https://docs.docker.com/reference/compose-file/services/#cgroup
    cgroup?: Cgroup
    # https://docs.docker.com/reference/compose-file/services/#cgroup_parent
    cgroup_parent?: str
    # https://docs.docker.com/reference/compose-file/services/#command
    command?: str | [str]
    # https://docs.docker.com/reference/compose-file/services/#configs
    configs?: [str] | [ServiceConfig]
    # https://docs.docker.com/reference/compose-file/services/#container_name
    container_name?: str
    # https://docs.docker.com/reference/compose-file/services/#credential_spec
    credential_spec?: CredentialSpec
    # https://docs.docker.com/reference/compose-file/services/#depends_on
    depends_on?: [str] | [DependsOn]
    # https://docs.docker.com/reference/compose-file/services/#deploy
    # deploy?:
    # https://docs.docker.com/reference/compose-file/services/#develop
    # develop?:
    # https://docs.docker.com/reference/compose-file/services/#device_cgroup_rules
    device_cgroup_rules?: [str]
    # https://docs.docker.com/reference/compose-file/services/#devices
    devices?: [str]
    # https://docs.docker.com/reference/compose-file/services/#dns
    dns?: str | [str]
    # https://docs.docker.com/reference/compose-file/services/#dns_opt
    dns_opt?: [str]
    # https://docs.docker.com/reference/compose-file/services/#dns_search
    dns_search?: [str]
    # https://docs.docker.com/reference/compose-file/services/#domainname
    domainname?: str
    # https://docs.docker.com/reference/compose-file/services/#entrypoint
    entrypoint?: str | [str]
    # https://docs.docker.com/reference/compose-file/services/#env_file
    env_file?: str | [str] | [ServiceEnvFile]
    # https://docs.docker.com/reference/compose-file/services/#environment
    environment?: {str:any} | [str]
    # https://docs.docker.com/reference/compose-file/services/#expose
    expose?: [str]
    # https://docs.docker.com/reference/compose-file/services/#extends
    extends?: Extends
    # https://docs.docker.com/reference/compose-file/services/#external_links
    external_links?: [str]
    # https://docs.docker.com/reference/compose-file/services/#extra_hosts
    extra_hosts?: [str] | {str:str}
    # https://docs.docker.com/reference/compose-file/services/#gpus
    gpus?: "all" | Gpus
    # https://docs.docker.com/reference/compose-file/services/#group_add
    group_add?: [str]
    # https://docs.docker.com/reference/compose-file/services/#healthcheck
    healthcheck?: Healthcheck
    # https://docs.docker.com/reference/compose-file/services/#hostname
    hostname?: str
    # https://docs.docker.com/reference/compose-file/services/#image
    image?: str
    # https://docs.docker.com/reference/compose-file/services/#init
    init?: bool
    # https://docs.docker.com/reference/compose-file/services/#ipc
    ipc?: str
    # https://docs.docker.com/reference/compose-file/services/#isolation
    # isolation?:
    # https://docs.docker.com/reference/compose-file/services/#labels
    labels?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/services/#label_file
    label_file?: str | [str]
    # https://docs.docker.com/reference/compose-file/services/#links
    links?: [str]
    # https://docs.docker.com/reference/compose-file/services/#logging
    logging?: Logging
    # https://docs.docker.com/reference/compose-file/services/#mac_address
    mac_address?: str
    # https://docs.docker.com/reference/compose-file/services/#mem_limit
    mem_limit?: str
    # https://docs.docker.com/reference/compose-file/services/#mem_reservation
    mem_reservation?: str
    # https://docs.docker.com/reference/compose-file/services/#mem_swappiness
    mem_swappiness?: int
    # https://docs.docker.com/reference/compose-file/services/#memswap_limit
    memswap_limit?: int
    # https://docs.docker.com/reference/compose-file/services/#network_mode
    network_mode?: str
    # https://docs.docker.com/reference/compose-file/services/#networks
    networks?: [str]
    # https://docs.docker.com/reference/compose-file/services/#oom_kill_disable
    oom_kill_disable?: bool
    # https://docs.docker.com/reference/compose-file/services/#oom_score_adj
    oom_score_adj?: int
    # https://docs.docker.com/reference/compose-file/services/#pid
    pid?: int
    # https://docs.docker.com/reference/compose-file/services/#pids_limit
    pids_limit?: int
    # https://docs.docker.com/reference/compose-file/services/#platform
    platform?: str
    # https://docs.docker.com/reference/compose-file/services/#ports
    ports?: [str] | [Port]
    # https://docs.docker.com/reference/compose-file/services/#post_start
    post_start?: [Lifecycle]
    # https://docs.docker.com/reference/compose-file/services/#pre_stop
    pre_stop?: [Lifecycle]
    # https://docs.docker.com/reference/compose-file/services/#privileged
    privileged?: bool
    # https://docs.docker.com/reference/compose-file/services/#profiles
    profiles?: [str]
    # https://docs.docker.com/reference/compose-file/services/#pull_policy
    pull_policy?: str
    # https://docs.docker.com/reference/compose-file/services/#read_only
    read_only?: bool
    # https://docs.docker.com/reference/compose-file/services/#restart
    restart?: str
    # https://docs.docker.com/reference/compose-file/services/#runtime
    # https://docs.docker.com/engine/daemon/alternative-runtimes/
    runtime?: str
    # https://docs.docker.com/reference/compose-file/services/#scale
    # scale?:
    # https://docs.docker.com/reference/compose-file/services/#secrets
    secrets?: [str] | [ServiceSecret]
    # https://docs.docker.com/reference/compose-file/services/#security_opt
    # https://docs.docker.com/reference/cli/docker/container/run/#security-opt
    security_opt?: [str]
    # https://docs.docker.com/reference/compose-file/services/#shm_size
    shm_size?: int
    # https://docs.docker.com/reference/compose-file/services/#stdin_open
    stdin_open?: bool
    # https://docs.docker.com/reference/compose-file/services/#stop_grace_period
    stop_grace_period?: str
    # https://docs.docker.com/reference/compose-file/services/#stop_signal
    stop_signal?: str
    # https://docs.docker.com/reference/compose-file/services/#storage_opt
    storage_opt?: StorageOpt
    # https://docs.docker.com/reference/compose-file/services/#sysctls
    # https://docs.docker.com/reference/cli/docker/container/run/#sysctl
    sysctls?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/services/#tmpfs
    tmpfs?: [str]
    # https://docs.docker.com/reference/compose-file/services/#tty
    tty?: bool
    # https://docs.docker.com/reference/compose-file/services/#ulimits
    ulimits?: Ulimits
    # https://docs.docker.com/reference/compose-file/services/#user
    user?: str
    # https://docs.docker.com/reference/compose-file/services/#userns_mode
    userns_mode?: str
    # https://docs.docker.com/reference/compose-file/services/#uts
    uts?: str
    # https://docs.docker.com/reference/compose-file/services/#volumes
    volumes?: [str] | [ServiceVolume]
    # https://docs.docker.com/reference/compose-file/services/#volumes_from
    volumes_from?: [str]
    # https://docs.docker.com/reference/compose-file/services/#working_dir
    working_dir?: str

    check:
        # https://docs.docker.com/reference/compose-file/services/#post_start
        # https://docs.docker.com/reference/compose-file/services/#healthcheck
        # https://docs.docker.com/reference/compose-file/services/#healthcheck
        # https://docs.docker.com/reference/compose-file/services/#depends_on
        typeof(container_name) == 'UndefinedType' or regex.match(container_name, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$')
        typeof(mem_swappiness) == 'UndefinedType' or mem_swappiness >= 0 and mem_swappiness <= 100
        typeof(oom_score_adj) == 'UndefinedType' or oom_score_adj >= -1000 and oom_score_adj <= 1000
        typeof(profiles) == 'UndefinedType' or [regex.match(profile, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$') for profile in profiles]
        typeof(pull_policy) == 'UndefinedType' or pull_policy in ["always", "never", "missing", "build"]
        typeof(restart) == 'UndefinedType' or restart in ["no", "always", "on-failure", "unless-stopped"] or regex.match(restart, r'^on-failure[:d]$')

schema IpamConfig:
    # subnet: Subnet in CIDR format that represents a network segment
    subnet: str
    # ip_range: Range of IPs from which to allocate container IPs
    ip_range: str
    # gateway: IPv4 or IPv6 gateway for the master subnet
    gateway: str
    # aux_addresses: Auxiliary IPv4 or IPv6 addresses used by Network driver, as a mapping from hostname to IP
    aux_addresses: {str:str}

schema Ipam:
    driver?: str
    config?: IpamConfig
    options?: {str:str}

# https://docs.docker.com/reference/compose-file/networks/
schema Network:
    # https://docs.docker.com/reference/compose-file/networks/#driver
    driver?: str
    # https://docs.docker.com/reference/compose-file/networks/#driver_opts
    driver_opts?: {str:str}
    # https://docs.docker.com/reference/compose-file/networks/#attachable
    attachable?: bool
    # https://docs.docker.com/reference/compose-file/networks/#enable_ipv4
    enable_ipv4?: bool
    # https://docs.docker.com/reference/compose-file/networks/#enable_ipv6
    enable_ipv6?: bool
    # https://docs.docker.com/reference/compose-file/networks/#external
    external?: bool
    # https://docs.docker.com/reference/compose-file/networks/#ipam
    ipam?: Ipam
    # https://docs.docker.com/reference/compose-file/networks/#internal
    internal?: bool
    # https://docs.docker.com/reference/compose-file/networks/#labels
    labels?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/networks/#name
    name?: str

# https://docs.docker.com/reference/compose-file/volumes/
schema Volume:
    # https://docs.docker.com/reference/compose-file/volumes/#driver
    driver?: str
    # https://docs.docker.com/reference/compose-file/volumes/#driver_opts
    driver_opts?: {str:str}
    # https://docs.docker.com/reference/compose-file/volumes/#external
    external?: bool
    # https://docs.docker.com/reference/compose-file/volumes/#labels
    labels?: {str:str} | [str]
    # https://docs.docker.com/reference/compose-file/volumes/#name
    name?: str

# https://docs.docker.com/reference/compose-file/configs/
schema Config:
    # file: The config is created with the contents of the file at the specified path.
    file?: str
    # environment: The config content is created with the value of an environment variable. Introduced in Docker Compose version 2.23.1.
    environment?: {str:any} | [str]
    # content: The content is created with the inlined value. Introduced in Docker Compose version 2.23.1.
    content?: str
    # external: If set to true, external specifies that this config has already been created. Compose does not attempt to create it, and if it does not exist, an error occurs.
    external?: bool
    # name: The name of the config object in the container engine to look up. This field can be used to reference configs that contain special characters. The name is used as is and will not be scoped with the project name.
    name?: str

# https://docs.docker.com/reference/compose-file/secrets/
schema Secret:
    # file: The secret is created with the contents of the file at the specified path.
    file?: str
    # environment: The secret is created with the value of an environment variable on the host.
    environment?: {str:any} | [str]

# https://docs.docker.com/reference/compose-file/include/
schema Include:
    path: str | [str]
    project_directory?: str
    env_file?: str | [str]

schema Services:
    [service_name: str]: Service

    check:
        typeof(service_name) == 'UndefinedType' or regex.match(service_name, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$')

schema Configs:
    [config_name: str]: Config

    check:
        typeof(config_name) == 'UndefinedType' or regex.match(config_name, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$')

schema Volumes:
    [volume_name: str]: Volume

    check:
        typeof(volume_name) == 'UndefinedType' or regex.match(volume_name, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$')

schema Secrets:
    [secret_name: str]: Secret

    check:
        typeof(secret_name) == 'UndefinedType' or regex.match(secret_name, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$')

schema Networks:
    [network_name: str]: Network

    check:
        typeof(network_name) == 'UndefinedType' or regex.match(network_name, r'^[a-zA-Z0-9][a-zA-Z0-9_.-]+$')

schema Compose:
    @deprecated(version="1.1.0", reason="Compose doesn't use version to select an exact schema to validate the Compose file, but prefers the most recent schema when it's implemented.", strict=True)
    version?: str
    name?: str
    include?: [str] | [Include]
    services?: Services
    networks?: Networks
    volumes?: Volumes
    configs?: Configs
    secrets?: Secrets
