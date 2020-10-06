all: | eks-install openebs-install kudo-install cassandra-install cassandra-uninstall kudo-uninstall openebs-uninstall eks-uninstall
.PHONY: all
eks-install: 
	@cd eks/eks-setup && ./eks_install.sh
openebs-install: 
	@cd eks/openebs && ./openebs_install.sh
kudo-install: 
	@cd kudo-operator && ./kudo_install.sh
cassandra-install: 
	@cd eks/cassandra-deploy && ./cassandra_install.sh
cassandra-uninstall: 
	@cd eks/cassandra-deploy && ./cassandra_uninstall.sh
kudo-uninstall: 
	@cd kudo-operator && ./kudo_uninstall.sh
openebs-uninstall: 
	@cd eks/openebs && ./openebs_uninstall.sh
eks-uninstall: 
	@cd eks/eks-setup && ./eks_uninstall.sh


