read -p "enter peer name (ex. peer0) : " peer_name
read -p "enter chaincode name (name of chaincode directory) : " cc_name
read -p "enter chaincode version : " cc_version
read -p "enter sequence : " cc_sequence
cc_package=$cc_name".tar.gz"
cc_label=$cc_name"_"$cc_version
echo $cc_package
echo $cc_label
docker exec cli peer lifecycle chaincode package $cc_package --path /opt/gopath/src/github.com/chaincode/$cc_name --lang golang --label $cc_label
docker exec cli peer lifecycle chaincode install $cc_package
docker exec cli peer lifecycle chaincode queryinstalled >&log.txt
PACKAGE_ID=$(sed -n "/${cc_name}_${cc_version}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
cc_package_id="${cc_label}:${PACKAGE_ID}"
docker exec cli peer lifecycle chaincode approveformyorg -o orderer0.fitcp.com:7050 --ordererTLSHostnameOverride orderer0.fitcp.com --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fitcp.com/orderers/orderer0.fitcp.com/msp/tlscacerts/tlsca.fitcp.com-cert.pem --channelID mychannel --name $cc_name --version $cc_version --package-id $cc_package_id --sequence $cc_sequence
#docker exec cli peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name $cc_name --version $cc_version --sequence $sequence --output json
docker exec cli peer lifecycle chaincode commit -o orderer0.fitcp.com:7050 --ordererTLSHostnameOverride orderer0.fitcp.com --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fitcp.com/orderers/orderer0.fitcp.com/msp/tlscacerts/tlsca.fitcp.com-cert.pem --channelID mychannel --name $cc_name --peerAddresses $peer_name".org1.fitcp.com:7051" --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fitcp.com/peers/"${peer_name}".org1.fitcp.com/tls/server.crt --version $cc_version --sequence $cc_sequence
docker exec cli peer lifecycle chaincode querycommitted --channelID mychannel --name $cc_name
