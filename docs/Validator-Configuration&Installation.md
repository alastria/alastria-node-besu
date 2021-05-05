# Validator Node Installation (with Binaries)

If not created, createa a symbolic link to the binaries (_bin_) and the _lib_ directory of the Besu version you are interested in.

```sh
cd validator
ln -s /data/alastria-node-besu/versionesBesu/besu-20.10.2/bin bin
ln -s /data/alastria-node-besu/versionesBesu/besu-20.10.2/lib lib
```
## Prerequisites

Install [Java JDK](https://www.oracle.com/java/technologies/javase-downloads.html) 11+
```sh
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt-get install oracle-java15-installer
```
## Besu node configuration

In the directory **config** are the files _config.toml_ and _genesis.json_.

A new private key will be created and the public key and node address will be obtained. The following commands will be executed.

```sh
cd /data/alastria-node-besu/validator
bin/besu --data-path=. public-key export --to=key.pub
bin/besu --data-path=. public-key export-address --to=nodeAddress
```

Here the keys 'key', 'key.pub' and 'nodeAddress' will have been generated and there gonna be stored in the **keys/besu** directory.

```sh
mv key keys/besu
mv key.pub keys/besu
mv nodeAddress keys/besu
```

In order to control the Node logs, Besu allows you to [configure your logs](https://besu.hyperledger.org/en/1.3.0-rc1/HowTo/Troubleshoot/Logging/) thanks to [log4j2](https://logging.apache.org/log4j/2.x/manual/configuration.html), being able to change the format in which you take them out, if you make rotations, if you compress the new files, how many you save and where you save them, etc. To do this, a file called **log-config.xml** is stored in _config/besu_.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="INFO" monitorInterval="5">

  <Properties>
    <Property name="root.log.level">INFO</Property>
  </Properties>

  <Appenders>
    <Console name="Console" target="SYSTEM_OUT">
        <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSSZZZ} | %t | %-5level | %c{1} | %msg %throwable{short.message}%n" />
    </Console>
    <RollingFile name="RollingFile" fileName="/data/alastria-node-besu/validador/logs/besu.log" filePattern="/data/alastria-node-besu/validador/logs/besu-%d{yyyyMMdd}-%i.log.gz" >
        <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSSZZZ} | %t | %-5level | %c{1} | %msg %throwable{short.message}%n" />
        <!-- Logs in JSON format
        <PatternLayout alwaysWriteExceptions="false" pattern='{"timestamp":"%d{ISO8601}","container":"${hostName}","level":"%level","thread":"%t","class":"%c{1}","message":"%msg","throwable":"%enc{%throwable}{JSON}"}%n'/>
        -->
      <Policies>
        <OnStartupTriggeringPolicy minSize="10240" />
        <TimeBasedTriggeringPolicy />
        <SizeBasedTriggeringPolicy size="50 MB"/>
      </Policies>
      <DefaultRolloverStrategy max="365" />
    </RollingFile>
  </Appenders>

  <Loggers>
    <Root level="${sys:root.log.level}">
      <AppenderRef ref="Console" />
      <AppenderRef ref="RollingFile" />
    </Root>
  </Loggers>

</Configuration>
```

In this case, the configuration that has been decided on is as follows.

- Both for the logs displayed on the console and for those stored in the rotated files will be the standard (can be changed to _json_ format or other formats allowed by the tool).
- It will generate a rotated log file when
  - The Besu Service is restarted whenever the file size is greater than 10 KB (`OnStartupTriggeringPolicy minSize="10240"`).
  - Once a day (`TimeBasedTriggeringPolicy`).
  - When the log file, if not spent a day, occupies more than 50 MB (`SizeBasedTriggeringPolicy size="50 MB"`).
- You will save 365 log files in a compressed format. Once the 365 files have passed, you will start deleting the first ones you created (`DefaultRolloverStrategy max="365"`).

The folder structure will be as follows.

```sh
drwxrwxr-x 7 besu besu     4096 Oct 23 10:09 ./
drwxr-xr-x 9 besu besu     4096 Oct 21 14:01 ../
lrwxrwxrwx 1 besu besu       29 Oct 21 10:49 bin -> /data/alastria-node-besu/versionBesu/besu-20.10.2/besu/bin/
drwxrwxr-x 3 besu besu     4096 Oct 21 10:38 config/
drwxr-xr-x 3 besu besu     4096 Oct 21 10:38 keys/
lrwxrwxrwx 1 besu besu       29 Oct 21 11:00 lib -> /data/alastria-node-besu/versionBesu/besu-20.10.2/besu/lib/

.
├── bin -> /data/alastria-node-besu/versionBesu/besu-20.10.2Fbesu/bin
├── config
│   └── besu
│       ├── config.toml
|       ├── genesis.json
│       └── log-config.xml
├── keys
│   └── besu
│       ├── key
│       ├── key.pub
│       └── nodeAddress
└── lib -> /data/alastria-node-besu/versionBesu/besu-20.10.2Fbesu/lib
```

## Execution of the Demon of Besu

**Note**: Due to a bug found, the network fails to synchronise all the blocks and stops at block 5484841. Therefore we recommend to follow the following steps (until the bug is solved):

- Comment in config.toml file the flag *compatibility-eth64-forkid-enabled=true*
- Modify the symbolic links and make them point to version 1.4.3.
- Synchronise the whole network.
- Stop the node (sudo systemctl stop besu.service), modify the symbolic link back to 20.10.2, uncomment the flag commented in the first step and start the node again (sudo systemctl start besu.service).

In this section, a daemon will be created to execute the Besu node in case of VM crashes, unexpected restarts, etc.

The first thing is to create the file for the besu service. To do this, the following steps will be followed.

```sh
cd /lib/systemd/system
sudo vim besu.service
```

The following variables will be put in this file: `StartLimitBurst` and `RestartSec` will cause it to make 5 restart attempts every 10s and if it fails at all it will stop trying. As an environment variable `LOG4J_CONFIGURATION_FILE` the path to the log configuration file seen in previous steps will be passed to you.

```service
[Unit]
Description=Service to init besu service on boot
After=network.target

[Service]
StartLimitBurst=5
StartLimitIntervalSec=200
WorkingDirectory=/data/alastria-node-besu/validator/
Environment=LOG4J_CONFIGURATION_FILE=/data/alastria-node-besu/validator/config/besu/log-config.xml
Type=simple
User=besu
ExecStart=/data/alastria-node-besu/validator/bin/besu --config-file=/data/alastria-node-besu/validator/config/besu/config.toml
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

Once the _besu.services_ file has been saved, this service is started. The following commands will be executed.

To let the system know that there is a new daemon that must be started at every boot, the following will be executed:

```sh
sudo systemctl daemon-reload
sudo systemctl enable besu.service
```

To start the Besu service the following command will be executed.

```sh
sudo systemctl start besu.service
```

Finally, to ensure that the service is correctly started it will run:

```sh
sudo systemctl status besu.service
```

Getting the following result.

```sh
● besu.service - Service to init besu service on boot
   Loaded: loaded (/lib/systemd/system/besu.service; disabled; vendor preset: enabled)
   Active: active (running) since Wed 2020-10-28 16:59:01 UTC; 37min ago
 Main PID: 19089 (java)
    Tasks: 73 (limit: 4680)
   CGroup: /system.slice/besu.service
           └─19089 java -Dvertx.disableFileCPResolving=true -Dbesu.home=/data/alastria-node-besu/validator -Dlog4j.shutdownHookEnabled=false --add-

Oct 28 17:36:35 besu1 besu[19089]: 2020-10-28 17:36:35.023+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:37 besu1 besu[19089]: 2020-10-28 17:36:37.022+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:39 besu1 besu[19089]: 2020-10-28 17:36:39.031+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:41 besu1 besu[19089]: 2020-10-28 17:36:41.023+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:43 besu1 besu[19089]: 2020-10-28 17:36:43.029+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:45 besu1 besu[19089]: 2020-10-28 17:36:45.022+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:47 besu1 besu[19089]: 2020-10-28 17:36:47.021+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:49 besu1 besu[19089]: 2020-10-28 17:36:49.029+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:51 besu1 besu[19089]: 2020-10-28 17:36:51.023+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
Oct 28 17:36:53 besu1 besu[19089]: 2020-10-28 17:36:53.026+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to
```

If you look at the log file you have generated you will see the following result.

```sh
tail -f besu.log

Oct 23 11:40:10 besu1 Besu[1101]: 2020-10-23 11:40:10.024+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44673, Round=0}, hash=0x429fd859a821b5ade91fdf18060c54cc07225f13ee22fca1c90cab5a96b8a6d5
Oct 23 11:40:12 besu1 Besu[1101]: 2020-10-23 11:40:12.026+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44674, Round=0}, hash=0x927481f3e7414c145adc42a81b627da338d433e4a38e9d0bdca0d7e2a4b11232
Oct 23 11:40:14 besu1 Besu[1101]: 2020-10-23 11:40:14.022+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44675, Round=0}, hash=0xc81d0cd503c28c9e25daac600cb4fb83690a2944c9e34bf6fc1948f6e7a5ddd5
Oct 23 11:40:16 besu1 Besu[1101]: 2020-10-23 11:40:16.024+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44676, Round=0}, hash=0x8a29de2b8d924b1579fc6135ca3f91e5a1cf22f06074e5707521e3c93e7f9356
Oct 23 11:40:18 besu1 Besu[1101]: 2020-10-23 11:40:18.023+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44677, Round=0}, hash=0x6c343d7c7a0fe40ac4c210f0e579b6fae5c97df31cb02f2dab2560eac329c3a3
Oct 23 11:40:20 besu1 Besu[1101]: 2020-10-23 11:40:20.027+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44678, Round=0}, hash=0x90b40aea12ec2c6fc27f794ebe35d088f4bc07b266d3f6cc2461df62ce7aff5b
Oct 23 11:40:20 besu1 Besu[1101]: 2020-10-23 11:40:20.038+00:00 | EthScheduler-Workers-1 | INFO  | PersistBlockTask | Imported #44,678 / 0 tx / 0 om / 0 (0.0%) gas / (0x90b40aea12ec2c6fc27f794ebe35d088f4bc07b266d3f6cc2461df62ce7aff5b) in 0.009s. Peers: 6
Oct 23 11:40:22 besu1 Besu[1101]: 2020-10-23 11:40:22.022+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44679, Round=0}, hash=0xc23185731078d16705b36bd1e72ccba09c45210aea26117869cb23fce4830ea4
Oct 23 11:40:24 besu1 Besu[1101]: 2020-10-23 11:40:24.023+00:00 | pool-8-thread-1 | INFO  | IbftRound | Importing block to chain. round=ConsensusRoundIdentifier{Sequence=44680, Round=0}, hash=0xec246c575fadcfa275f804be1a39dba6f335bdd53f795a1a23342c7d84fbb6d1
```

The folder structure that would remain once the node is started would be as follows.

```sh
drwxrwxr-x 7 besu besu     4096 Oct 23 10:09 ./
drwxr-xr-x 9 besu besu     4096 Oct 21 14:01 ../
-rw-r--r-- 1 besu besu       13 Oct 22 13:45 DATABASE_METADATA.json
-rw-r--r-- 1 besu besu      219 Oct 23 10:09 besu.networks
-rw-r--r-- 1 besu besu      205 Oct 23 10:09 besu.ports
lrwxrwxrwx 1 besu besu       29 Oct 21 10:49 bin -> /data/alastria-node-besu/versionBesu/besu-20.10.2/besu/bin/
drwxr-xr-x 2 besu besu     4096 Oct 22 13:45 caches/
drwxrwxr-x 3 besu besu     4096 Oct 21 10:38 config/
drwxr-xr-x 2 besu besu     4096 Oct 23 10:09 database/
drwxr-xr-x 3 besu besu     4096 Oct 21 10:38 keys/
lrwxrwxrwx 1 besu besu       29 Oct 21 11:00 lib -> /data/alastria-node-besu/versionBesu/besu-20.10.2/besu/lib/
drwxrwxr-x 2 besu besu     4096 Oct 28 16:59 logs/
drwxrwxr-x 2 besu besu     4096 Oct 21 14:54 uploads/
```
