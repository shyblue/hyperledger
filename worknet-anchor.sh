export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer channel create -o orderer:7050 -c ch1 -f WorknetMSPanchors.tx