export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode invoke -o orderer:7050 -C ch1 -n worknetCC -c '{"Args":["invoke","a","b","20"]}'
