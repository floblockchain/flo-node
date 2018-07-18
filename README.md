#### Unattended install script for creating a FLO full node that will run on a 1CPU/512MB/20GB $5/mo Ubuntu 16.04 VPS.

To use the “one click” script of your choice, simply copy+paste the below command into a new Ubuntu install, sit back, and relax. It takes about 30 minutes to complete, but is entirely unattended.

#### With Blockchain Snapshot:

```wget -O floNode.sh https://raw.githubusercontent.com/floblockchain/flo-node/master/flosetupscript-withchain-1.sh ; sudo bash floNode.sh```

#### Without Blockchain Snapshot:

```wget -O floNode.sh https://raw.githubusercontent.com/floblockchain/flo-node/master/flosetupscript.sh ; sudo bash floNode.sh```


Details: All dependencies are installed, FLO is compiled from source, the flo.conf file is configured with a randomly generated RPC user/password, IPTABLES are configured to accept incoming connections, and flod starts at boot. There are two versions of the script which are identical except that one will download and install a recent snapshot of the blockchain. It is entirely optional, and if you would prefer to download the blockchain from the network itself, choose the script that does not include it.
