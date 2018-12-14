# Hyper Ledger 따라잡기
## Hyper Ledger 개발환경 구성
### Virtual Box

https://www.virtualbox.org/wiki/Downloads
1. VirtualBox platform package
2. VirtualBox Oracle VM VirtualBox Extension Pack

### Ubuntu 18.04 LTS

#### Pre-install

https://www.ubuntu.com/download/desktop/thank-you?country=KR&version=18.04.1&architecture=amd64

1. VM 생성시 메모리 설정을 최소 2048M 이상 요구됨(HyperLedger Fabric 요구사항)
1. 디스크 40Gb 이상
2. VM 설정 > 네트워크 > 어댑터 2 > 호스트 전용 어댑터

#### Install

1. 우분투 설치 이미지를 사용하여 우분투 설치
2. 설치 후 리부트
3. Guest 확장 CD 필요도구 설치
```
$ sudo apt-get install virtualbox-guest-dkms
$ sudo apt-get install linux-headers-virtual
```
4. Guest 확장 CD 설치 (장치 -> 게스트 확장 CD 이미지 삽입)

### Go Lang 설치

1. Download 및 설치
```
$ sudo -i
# wget https://storage.googleapis.com/golang/go1.10.4.linux-amd64.tar.gz
# tar -xvf go1.10.4.linux-amd64.tar.gz
```
2. GOPATH/GOROOT 설정
```
# mkdir /root/gopath
# vi /etc/profile
```
3. /etc/profile 에 추가
```
export GOPATH=/root/gopath
export GOROOT=/root/go
export PATH=$PATH:$GOROOT/bin
```
4. 환경설정 적용
```
# source /etc/profile
```
5. 필요 소프트웨어 설치
```
apt-get install python-pip git curl libltdl-dev tree openssh-server net-tools 
```
6. docker, docker-compose 설치
```
# wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.06.2~ce-0~ubuntu_amd64.deb
# dpkg -i docker-ce_17.06.2~ce-0~ubuntu_amd64.deb
# docker run hello-world
# pip install docker-compose
# docker-compose --version
docker-compose version 1.23.2, build 1110ad0
```
> docker-compose 버전은 1.14.0 이상이면 OK

### Hyper Ledfer Fabric 설치

1. HyperLedger Fabric 1.3 downad
```
# mkdir -p $GOPATH/src/github.com/hyperledger
# cd $GOAPTH/src/github.com/hyperledger
# git clone -b release-1.3 https://github.com/hyperledger/fabric
```
2. Hyperledger source compile
```
# cd fabirc
# make
```

3. 환경변수 설정
```
# vi /etc/profile
export FABRIC_HOME=$GOPATH/src/github.com/hyperledger/fabric
export PATH=$PATH:$FABRIC_HOME/.build/bin
```
4. 환경변수 적용
```
# source /etc/profile
```
5. 작업 디렉토리 생성
```
# mkdir /root/worknet
# cd /root/worknet
```
6. 시스템 기본 설정
```
# cp $FABRIC_HOME/sampleconfig/core.yaml /root/worknet/core.yaml
# cp $FABRIC_HOME/sampleconfig/orderer.yaml /root/worknet/orderer.yaml
```
7. 환경설정
```
# vi /etc/profile
export FABRIC_CFG_PATH=/root/worknet
# source /etc/profile
```

### 네트워크 구성

1. /etc/hosts 구성
```
127.0.0.1       peer
127.0.0.1       orderer
127.0.0.1       client
127.0.0.1       kafka-zookeeper
```
1. MSP 생성
	1. vi worknet/crypto-config.yaml
```yaml
OrdererOrgs:
        - Name: Orderer
          Domain: orderer
          Specs:
                  - Hostname: orderer

PeerOrgs:
        - Name: Worknet
          Domain: worknet
          Template:
                  Count: 1
          Users:
                  Count: 1
```
	2. MSP 생성 명령
```
# cryptogen generate --config=./crypto-config.yaml
```

2. 구성 설정. configtx.yaml

```yaml
Organizations:
    - &Orderer
        Name: Orderer
        ID: OrdererMSP
        MSPDir: crypto-config/ordererOrganizations/orderer/msp/
 
    - &Worknet
        Name: WorknetMSP
        ID: WorknetMSP
        MSPDir: crypto-config/peerOrganizations/worknet/msp/
        AnchorPeers:
            - Host: 127.0.0.1
              Port: 7051

Orderer: &OrdererDefaults
    OrdererType: kafka
    Addresses:
        - orderer:7050
    BatchTimeout: 1s
    BatchSize:
        MaxMessageCount: 30
        AbsoluteMaxBytes: 99 MB
        PreferredMaxBytes: 512 KB
    Kafka:
        Brokers:
            - kafka-zookeeper:9092
    Organizations:

Application: &ApplicationDefaults
    Organizations:

Profiles:

    WorknetOrdererGenesis:
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererWorknet
        Consortiums:
            WorknetConsortium:
                Organizations:
                    - *Worknet

    WorknetChannel:
        Consortium: WorknetConsortium
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *Worknet
```
3. 구성 명령
```
# configtxgen -profile WorknetOrdererGenesis -outputBlock genesis.block
# cp genesis.block crypto-config/ordererOrganizations/orderer/orderers/orderer.orderer/
# configtxgen -profile WorknetChannel -outputCreateChannelTx ch1.tx -channelID ch1
# configtxgen -profile WorknetChannel -outputAnchorPeersUpdate WorknetMSPanchors.tx -channelID ch1 -asOrg WorknetMSP
```

#### Peer 구동

1. runPeer.sh
```sh
CORE_PEER_ENDORSER_ENABLED=true \
CORE_PEER_PROFILE_ENABLED=true \
CORE_PEER_ADDRESS=127.0.0.1:7051 \
CORE_PEER_CHAINCODELISTENADDRESS=127.0.0.1:7052 \
CORE_PEER_ID=worknetPeer \
CORE_PEER_LOCALMSPID=WorknetMSP \
CORE_PEER_GOSSIP_EXTERNALENDPOINT=127.0.0.1:7051 \
CORE_PEER_GOSSIP_USELEADERELECTION=true \
CORE_PEER_GOSSIP_ORGLEADER=false \
CORE_PEER_TLS_ENABLED=false \
CORE_PEER_TLS_KEY_FILE=/root/worknet/crypto-config/peerOrganizations/worknet/peers/peer0.worknet/tls/server.key \
CORE_PEER_TLS_CERT_FILE=/root/worknet/crypto-config/peerOrganizations/worknet/peers/peer0.worknet/tls/server.crt \
CORE_PEER_TLS_ROOTCERT_FILE=/root/worknet/crypto-config/peerOrganizations/org0/peers/peer0.worknet/tls/ca.crt \
CORE_PEER_TLS_SERVERHOSTOVERRIDE=127.0.0.1 \
CORE_VM_DOCKER_ATTACHSTDOUT=true \
CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/peers/peer0.worknet/msp \
peer node start
```

```
# chmod +x runPeer.sh
# ./runPeer.sh
```

#### Kafka-Zookeeper 구동
1. docker-compose.yaml
```yaml
version: '2'
services:
    zookeeper:
        image: hyperledger/fabric-zookeeper
#        restart: always
        ports:
            - "2181:2181"
    kafka0:
        image: hyperledger/fabric-kafka
#        restart: always
        environment:
            - KAFKA_ADVERTISED_HOST_NAME=127.0.0.1
            - KAFKA_ADVERTISED_PORT=9092
            - KAFKA_BROKER_ID=0
            - KAFKA_MESSAGE_MAX_BYTES=103809024 # 99 * 1024 * 1024 B
            - KAFKA_REPLICA_FETCH_MAX_BYTES=103809024 # 99 * 1024 * 1024 B
            - KAFKA_UNCLEAN_LEADER_ELECTION_ENABLE=false
            - KAFKA_NUM_REPLICA_FETCHERS=1
            - KAFKA_DEFAULT_REPLICATION_FACTOR=1
            - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
        ports:
            - "9092:9092"
        depends_on:
            - zookeeper
```
```
# docker-compose up
```

#### Orderer 구동

1. runOrder.sh
```sh
ORDERER_GENERAL_LOGLEVEL=info \
ORDERER_GENERAL_LISTENADDRESS=orderer \
ORDERER_GENERAL_GENESISMETHOD=file \
ORDERER_GENERAL_GENESISFILE=/root/worknet/crypto-config/ordererOrganizations/orderer/orderers/orderer.orderer/genesis.block \
ORDERER_GENERAL_LOCALMSPID=OrdererMSP \
ORDERER_GENERAL_LOCALMSPDIR=/root/worknet/crypto-config/ordererOrganizations/orderer/orderers/orderer.orderer/msp \
ORDERER_GENERAL_TLS_ENABLED=false \
ORDERER_GENERAL_TLS_PRIVATEKEY=/root/worknet/crypto-config/ordererOrganizations/orderer/orderers/orderer.orderer/tls/server.key \
ORDERER_GENERAL_TLS_CERTIFICATE=/root/worknet/crypto-config/ordererOrganizations/orderer/orderers/orderer.orderer/tls/server.crt \
ORDERER_GENERAL_TLS_ROOTCAS=[/root/worknet/crypto-config/ordererOrganizations/orderer/orderers/orderer.orderer/tls/ca.crt,/root/worknet/crypto-config/peerOrganizations/worknet/peers/peer0.worknet/tls/ca.crt] \
CONFIGTX_ORDERER_BATCHTIMEOUT=1s \
CONFIGTX_ORDERER_ORDERERTYPE=kafka \
CONFIGTX_ORDERER_KAFKA_BROKERS=[127.0.0.1:9092] \
orderer
```
```
# chmod +x runOrderer.sh
# ./runOrderer.sh
```

#### 채널 생성
1. createChannel.sh
```sh
CORE_PEER_LOCALMSPID="WorknetMSP" \
CORE_PEER_TLS_ROOTCERT_FILE=/root/worknet/crypto-config/peerOrganizations/worknet/peers/peer0.worknet/tls/ca.crt \
CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp \
CORE_PEER_ADDRESS=peer:7051 \
peer channel create -o orderer:7050 -c ch1 -f ch1.tx
```
```
# chmod +x createChannel.sh
# ./createChannel.sh
```

#### 채널 참여
1. peer-join.sh
```sh
export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer channel join -b ch1.block
```
```
# chmod +x peer-join.sh
# ./peer-join.sh
```

#### Anchor Peer 업데이트
1. worknetr-anchor.sh
```sh
export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer channel create -o orderer:7050 -c ch1 -f WorknetMSPanchors.tx
```
```
# chmod +x worknet-anchor.sh
# ./worknet-anchor.sh
```

#### 체인코드 설치
1. installCCPeer.sh
```sh
export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknetnet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode install -n worknetCC -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/example02/cmd
```
```
# chmod +x installCCPeer.sh
# ./installCCPeer.sh
```

#### 체인코드 인스턴스 생성
1. instantiateCC.sh
```sh
export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknetnet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode instantiate -o orderer:7050 -C ch1 -n worknetCC -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('WorknetMSP.member')"
```
```
# chmod +x instantiateCC.sh
# ./instantiateCC.sh
```

#### 원장 데이터 읽기
1. query.sh
```sh
export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode query -C ch1 -n worknetCC -c '{"Args":["query","b"]}'
```
```
# chmod +x query.sh
# ./query.sh
```

#### 원장에 데이터 쓰기
1. invoke.sh
```sh
export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode invoke -o orderer:7050 -C ch1 -n worknetCC -c '{"Args":["invoke","a","b","20"]}'
```
```
# chmod +x invoke.sh
# ./invoke.sh
```