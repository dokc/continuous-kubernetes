## Cassandra deployment using kudo operator

In this usecase below activity have been performed:

- Create a 3 node EKS cluster in ap-south-1 region
- Install OpenEBS latest version
- Create an Amazon csi volume and use the same as a block devices attached to each node
- Deploy cert-manager
- Install Kudo-operator
- Deploy Cassandra statefulset using kudo operator and openebs-device as storage class
- Check the status of cassandra sts pods.

### Cleanup phase:
- Uninstall Cassandra statefulset
- Uninstall Kudo operator
- Delete the disks
- Uninstall OpenEBS
- Delete the eks cluster



