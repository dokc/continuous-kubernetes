all: | eks-install openebs-install openebs-uninstall eks-uninstall
.PHONY: all
eks-install: 
	@cd eks && ./eks_install.sh
openebs-install: 
	@cd openebs && ./openebs_install.sh
openebs-uninstall: 
	@cd openebs && ./openebs_uninstall.sh
eks-uninstall: 
	@cd eks && ./eks_uninstall.sh


