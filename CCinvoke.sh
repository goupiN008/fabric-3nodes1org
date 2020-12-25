read -p "enter peer name (ex. peer0) : " peer_name
read -p "enter chaincode name (name of chaincode directory) : " cc_name
read -p 'enter arguments (ex ["functionA","input1","input2","input3"] ) : '
docker exec cli peer chaincode invoke -o orderer0.fitcp.com:7050 --tls ture --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fitcp.com/orderers/orderer0.fitcp.com/msp/tlscacerts/tlsca.fitcp.com-cert.pem --channelID mychannel --name $cc_name --peerAddresses $peer_name".org1.fitcp.com:7051" --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.fitcp.com/peers/"${peer_name}".org1.fitcp.com/tls/server.crt -c '{"Args":${Args}}'
