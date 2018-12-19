# it creates a storageClass for gluster-block
# eg. sh block-storageClass.sh


name=block-sc
secretname=heketi-secret-block
secretnamespace=glusterfs
resturl=`oc get service heketi-storage -n $secretnamespace --no-headers\
    -o=custom-columns=:.spec.clusterIP`

echo "apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: $name
reclaimPolicy: Delete
provisioner: gluster.org/glusterblock
parameters:
  resturl: http://$resturl:8080
  restuser: admin
  restsecretName: $secretname
  restsecretNamespace: $secretnamespace
  hacount: '3'
  chapauthenabled: 'true'
  volumenameprefix: blk" | oc create -f -
