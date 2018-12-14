CORE_PEER_ENDORSER_ENABLED=true \
CORE_PEER_PROFILE_ENABLED=true \
CORE_PEER_ADDRESS=127.0.0.1:7051 \
CORE_PEER_CHAINCODELISTENADDRESS=127.0.0.1:7052 \
CORE_PEER_ID=org0-peer0 \
CORE_PEER_LOCALMSPID=Org0MSP \
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