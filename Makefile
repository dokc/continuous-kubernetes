all: | eks-install openebs-install kudo-install cassandra-install cassandra-uninstall kudo-uninstall openebs-uninstall eks-uninstall
.PHONY: all
eks-install: 
	@cd eks && ./eks_install.sh
openebs-install: 
	@cd openebs && ./openebs_install.sh
kudo-install: 
	@cd kudo-operator && ./kudo_install.sh
cassandra-install: 
	@cd cassandra-scale && ./cassandra_install.sh
cassandra-uninstall: 
	@cd cassandra-scale && ./cassandra_uninstall.sh
kudo-uninstall: 
	@cd kudo-operator && ./kudo_uninstall.sh
openebs-uninstall: 
	@cd openebs && ./openebs_uninstall.sh
eks-uninstall: 
	@cd eks && ./eks_uninstall.sh


