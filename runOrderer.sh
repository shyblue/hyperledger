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