CORE_PEER_LOCALMSPID="WorknetMSP" \
CORE_PEER_TLS_ROOTCERT_FILE=/root/worknet/crypto-config/peerOrganizations/worknet/peers/peer0.worknet/tls/ca.crt \
CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp \
CORE_PEER_ADDRESS=peer:7051 \
peer channel create -o orderer:7050 -c ch1 -f ch1.tx