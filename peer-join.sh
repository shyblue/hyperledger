export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer channel join -b ch1.block
