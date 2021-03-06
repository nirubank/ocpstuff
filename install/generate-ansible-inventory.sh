﻿cat <<EOF > /etc/ansible/hosts
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes
new_nodes
#etcd
#lb
glusterfs

## Set variables common for all OSEv3 hosts
[OSEv3:vars]
openshift_deployment_type=openshift-enterprise
#openshift_deployment_type=origin
#containerized=true
#openshift_enable_unsupported_configurations=True

## sandbox
##openshift_enable_unsupported_configurations=True
##openshift_additional_ca=/etc/pki/ca-trust/source/anchors/repo.home.nicknach.net.crt
#openshift_use_crio_only=True
#openshift_crio_use_rpm=True
#openshift_use_crio=True
#openshift_crio_enable_docker_gc=True
#openshift_crio_docker_gc_node_selector={'runtime': 'cri-o'}

## internal image repos
##openshift_additional_repos=[{'id': 'ose-devel', 'name': 'rhaos-beta', 'baseurl': 'http://$SRC_REPO/repo/rhaos-beta', 'enabled': 1, 'gpgcheck': 0}]
##openshift_docker_insecure_registries=$SRC_REPO
##openshift_docker_blocked_registries=registry.access.redhat.com,docker.io
#openshift_docker_additional_registries=$SRC_REPO
#oreg_url=$SRC_REPO/openshift3/ose-\${component}:\${version}
#openshift_examples_modify_imagestreams=true

## specify storage images
openshift_storage_glusterfs_image=satellite.home.nicknach.net:8888/rhgs3/rhgs-server-rhel7:v3.11
openshift_storage_glusterfs_block_image=satellite.home.nicknach.net:8888/rhgs3/rhgs-gluster-block-prov-rhel7:v3.11
openshift_storage_glusterfs_s3_image=satellite.home.nicknach.net:8888/rhgs3/rhgs-s3-server-rhel7:v3.11
openshift_storage_glusterfs_heketi_image=satellite.home.nicknach.net:8888/rhgs3/rhgs-volmanager-rhel7:v3.11

## container runtime options
oreg_auth_user=$RHN_ID
oreg_auth_password="$RHN_PASSWD"
#container_runtime_docker_storage_setup_device=$DOCKER_DEV
#container_runtime_docker_storage_type=devicemapper
## If oreg_url points to a registry requiring authentication, provide the following:
## NOTE: oreg_url must be defined by the user for oreg_auth_* to have any affect.
## oreg_auth_pass should be generated from running docker login.
## To update registry auth credentials, uncomment the following:
#oreg_auth_credentials_replace: True

## disable checks
#openshift_disable_check=disk_availability,docker_storage,memory_availability,docker_image_availability,package_availability,package_version

## cluster stuff (uncomment for multi-master mode)
#openshift_master_cluster_hostname=api.$ROOT_DOMAIN
#openshift_master_cluster_public_hostname=console.$ROOT_DOMAIN

## release ver
openshift_release=$OCP_VER
openshift_image_tag=$OCP_VER
##openshift_pkg_version=-3.11.16

## enable ntp
#openshift_clock_enabled=false

## disable template imports
#openshift_install_examples=false

## If ansible_ssh_user is not root, ansible_sudo must be set to true
ansible_ssh_user=root
#ansible_ssh_user=cloud-user
#ansible_sudo=true
#ansible_become=yes

## authentication stuff
## htpasswd file auth
#openshift_master_identity_providers=[{"name": "htpasswd_auth", "login": "true", "challenge": "true", "kind": "HTPasswdPasswordIdentityProvider"}]
#openshift_master_htpasswd_users={'testuser':'\$apr1\$azF6n0fo\$khEfbcGI6TiDYtv3gaOLm0'}

## ldap auth (AD)
#openshift_master_identity_providers=[{"name":"NNWIN","challenge":"true","login":"true","kind":"LDAPPasswordIdentityProvider","attributes":{"id":["dn"],"email":["mail"],"name":["cn"],"preferredUsername":["sAMAccountName"]},"bindDN":"CN=SVC-nn-ose,OU=SVC,OU=FNA,DC=nnwin,DC=ad,DC=nncorp,DC=com","bindPassword":"<REDACTED>","insecure":true,"url":"ldap://uswin.nicknach.com:389/DC=uswin,DC=ad,DC=nncorp,DC=com?sAMAccountName?sub"}]
#openshift_master_ldap_ca_file=/etc/ssl/certs/NNWINDC_Cert_Chain.pem

## ldap auth (IPA)
openshift_master_identity_providers=[{"name":"myipa","challenge":"true","login":"true","kind":"LDAPPasswordIdentityProvider","attributes":{"id":["dn"],"email":["mail"],"name":["cn"],"preferredUsername":["uid"]},"bindDN":"","bindPassword":"","ca":"my-ldap-ca-bundle.crt","insecure":"false","url":"ldap://$LDAP_SERVER/cn=users,cn=accounts,dc=home,dc=nicknach,dc=net?uid"}]
openshift_master_ldap_ca_file=~/my-ldap-ca-bundle.crt

## web console cert
#openshift_master_named_certificates=[{"certfile": "/etc/origin/master/ocp.nicknach.net.crt", "keyfile": "/etc/origin/master/ocp.nicknach.net.key", "names": ["console.ocp.nicknach.net"]}]
#openshift_master_overwrite_named_certificates=true

## router cert
#openshift_router_hosted_certificate={"certfile": "/etc/origin/master/ocp.nicknach.net.crt", "keyfile": "/etc/origin/master/ocp.nicknach.net.key", "cafile": "/etc/origin/master/ca.pem"}

##  cloud provider configs
##  AWS
#openshift_clusterid=clusterid
#openshift_cloudprovider_kind=aws
#openshift_cloudprovider_aws_access_key=
#openshift_cloudprovider_aws_secret_key=
##  GCE
#openshift_cloudprovider_kind=gce
##  Openstack
#openshift_cloudprovider_kind=openstack
#openshift_cloudprovider_openstack_auth_url=https://controller.home.nicknach.com:35357/v2.0
#openshift_cloudprovider_openstack_username=svc-openshift-np
#openshift_cloudprovider_openstack_password=kX7mE10dkX7mE10d
#openshift_cloudprovider_openstack_tenant_id=f741ba7204ec47c9886c050891dd592e
#openshift_cloudprovider_openstack_tenant_name=nn-dev
#openshift_cloudprovider_openstack_domain_name=Default
##openshift_cloudprovider_openstack_region=RegionOne
##openshift_cloudprovider_openstack_lb_subnet_id=d7c61f2a-d591-461d-af28-308ade046c0d

# setup cns (alternatively, a cloud provider could be used instead)
openshift_storage_glusterfs_namespace=glusterfs
openshift_storage_glusterfs_name=storage
openshift_storage_glusterfs_heketi_wipe=true
openshift_storage_glusterfs_wipe=true
openshift_storage_glusterfs_storageclass_default=true
openshift_storage_glusterfs_block_storageclass=true
openshift_storage_glusterfs_block_host_vol_size=60
openshift_hosted_registry_storage_kind=glusterfs
openshift_logging_es_pvc_storage_class_name=glusterfs-storage-block
openshift_metrics_cassandra_pvc_storage_class_name=glusterfs-storage-block

## enable dynamic provisioning
openshift_master_dynamic_provisioning_enabled=true
openshift_hosted_etcd_storage_kind=dynamic
openshift_logging_es_pvc_dynamic=true
openshift_metrics_cassandra_storage_type=dynamic

## registry
openshift_hosted_manage_registry=true
openshift_hosted_registry_storage_volume_size=25Gi
## etcd
openshift_hosted_etcd_storage_volume_name=etcd-vol2
openshift_hosted_etcd_storage_volume_size=10Gi
## asb
ansible_service_broker_local_registry_whitelist=['.*-apb$']
#ansible_service_broker_install=false
#ansible_service_broker_remove=true
## logging
openshift_logging_install_logging=true
openshift_logging_es_pvc_size=10Gi
openshift_logging_es_memory_limit=4G
openshift_logging_es_nodeselector={'node-role.kubernetes.io/infra':'true'}
openshift_logging_curator_nodeselector={'node-role.kubernetes.io/infra':'true'}
openshift_logging_kibana_nodeselector={'node-role.kubernetes.io/infra':'true'}
## legacy metrics
openshift_metrics_install_metrics=true
openshift_metrics_cassandra_pvc_size=10Gi
openshift_metrics_cassandra_nodeselector={'node-role.kubernetes.io/infra':'true'}
openshift_metrics_hawkular_nodeselector={'node-role.kubernetes.io/infra':'true'}
openshift_metrics_heapster_nodeselector={'node-role.kubernetes.io/infra':'true'}
## prometheus
openshift_cluster_monitoring_operator_install=true
openshift_cluster_monitoring_operator_prometheus_storage_enabled=true
openshift_cluster_monitoring_operator_alertmanager_storage_enabled=true
openshift_cluster_monitoring_operator_prometheus_storage_capacity="10Gi"
openshift_cluster_monitoring_operator_alertmanager_storage_capacity="2Gi"

## CNS for apps only (no infra)
#openshift_storage_glusterfs_namespace=app-storage	
#openshift_storage_glusterfs_storageclass=true

## domain stuff
openshift_master_default_subdomain=$APPS_DOMAIN

## network stuff
#os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
## set these if you are behind a proxy
#openshift_http_proxy=http://192.168.0.254:3128
#openshift_https_proxy=http://192.168.0.254:3128
#openshift_no_proxy=.$APPS_DOMAIN,$ROOT_DOMAIN

##openshift_hosted_infra_selector={"node-role.kubernetes.io/infra":"true"}

## use these if there is a conflict with the docker bridge and/or SDN networks
#osm_cluster_network_cidr=10.129.0.0/14
#openshift_portal_net=172.31.0.0/16

## use these to customize the redirect
##openshift_master_public_api_url=https://api.$ROOT_DOMAIN:443
##openshift_master_public_console_url=https://console.$ROOT_DOMAIN:443/console
## switch the main port from 8443 to 443
#openshift_master_api_port=443
#openshift_master_console_port=443

## adjust max pods for scale testing
#openshift_node_kubelet_args={'pods-per-core': ['15'], 'max-pods': ['500'], 'image-gc-high-threshold': ['85'], 'image-gc-low-threshold': ['80']}
## adjust scheduler and pod eviction timout for application HA 
#osm_controller_args={'node-monitor-period': ['2s'], 'node-monitor-grace-period': ['16s'], 'pod-eviction-timeout': ['30s']}
#osm_controller_args={'resource-quota-sync-period': ['10s']}

## load balancer
#[lb]
#lb.$ROOT_DOMAIN

## host group for etcd (uncomment for multi-master)
#[etcd]
#master01.$ROOT_DOMAIN
#master02.$ROOT_DOMAIN
#master03.$ROOT_DOMAIN

## host group for masters
[masters]
master01.$ROOT_DOMAIN
#master02.$ROOT_DOMAIN
#master03.$ROOT_DOMAIN
## if you want to change the console's hostname on a single master cluster
## openshift_public_hostname=console.openshiftdemo.com

[nodes]
master01.$ROOT_DOMAIN openshift_node_group_name="node-config-master" openshift_schedulable=true
#master02.$ROOT_DOMAIN openshift_node_group_name="node-config-master" openshift_schedulable=true
#master03.$ROOT_DOMAIN openshift_node_group_name="node-config-master" openshift_schedulable=true
#infra01.$ROOT_DOMAIN openshift_node_group_name="node-config-infra" openshift_schedulable=true
#infra02.$ROOT_DOMAIN openshift_node_group_name="node-config-infra" openshift_schedulable=true
#infra03.$ROOT_DOMAIN openshift_node_group_name="node-config-infra" openshift_schedulable=true
node01.$ROOT_DOMAIN openshift_node_group_name="node-config-compute" openshift_schedulable=true
node02.$ROOT_DOMAIN openshift_node_group_name="node-config-compute" openshift_schedulable=true
node03.$ROOT_DOMAIN openshift_node_group_name="node-config-compute" openshift_schedulable=true

## if using gluster (Container Native Storage)
[glusterfs]
infra01.$ROOT_DOMAIN glusterfs_devices='[ "/dev/vdb" ]'
infra02.$ROOT_DOMAIN glusterfs_devices='[ "/dev/vdb" ]'
infra03.$ROOT_DOMAIN glusterfs_devices='[ "/dev/vdb" ]'

[new_nodes]
## hold for use when adding new nodes

EOF
 
# Verify that your /etc/ansible/hosts file looks good

