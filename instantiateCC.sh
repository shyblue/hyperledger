export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknetnet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode instantiate -o orderer:7050 -C ch1 -n worknetCC -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('WorknetMSP.member')"

