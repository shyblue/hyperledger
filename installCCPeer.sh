export CORE_PEER_LOCALMSPID="WorknetMSP"
export CORE_PEER_MSPCONFIGPATH=/root/worknetnet/crypto-config/peerOrganizations/worknet/users/Admin@worknet/msp
export CORE_PEER_ADDRESS=peer:7051
peer chaincode install -n worknetCC -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/example02/cmd
