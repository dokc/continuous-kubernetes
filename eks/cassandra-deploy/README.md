## Cassandra deployment using Kudo operator

In this use case, the following steps are performed:

- Create a 3 node EKS cluster in `ap-south-1` region
- Install OpenEBS latest version
- Create an Amazon EBS volume and attach it to each node.
- Deploy cert-manager
- Install Kudo-operator
- Deploy Cassandra statefulset using kudo operator and `openebs-device` as `Storage Class`
- Check the status of Cassandra pods.

### Cleanup phase:
- Uninstall Cassandra statefulset
- Uninstall Kudo operator
- Delete the disks
- Uninstall OpenEBS
- Delete the eks cluster

### Sequence of script called:

eks-install(Create a EKS cluster)
	cd eks/eks-setup && ./eks_install.sh
openebs-install(Install latest OpenEBS and attach disks)
	cd eks/openebs && ./openebs_install.sh
Kudo-install(Install Kudo operator)
	cd kudo-operator && ./kudo_install.sh
Cassandra-install(Deploy Cassandra)
	cd eks/cassandra-deploy && ./cassandra_install.sh
Cassandra-uninstall(Delete Cassandra) 
	cd eks/cassandra-deploy && ./cassandra_uninstall.sh
Kudo-uninstall(Delete Kudo operator)
	cd kudo-operator && ./kudo_uninstall.sh
openebs-uninstall(uninstall OpenEBS and delete disks)
	cd eks/openebs && ./openebs_uninstall.sh
eks-uninstall(Delete EKS cluster)
	cd eks/eks-setup && ./eks_uninstall.sh

Note: All the above scripts are called in a single command `make -k all`

