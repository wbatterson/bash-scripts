export SERVICE_ENDPOINT="http://<IP OF THE KEYSTONE SERVER>:35357/v2.0/"
export SERVICE_TOKEN=<match this up with the keystone config>

export NOVA_IP=<IP of the host running nova>
export GLANCE_IP=<IP of the host running glance>
export KEYSTONE_IP=<IP of the host running keystone>
export VOLUME_IP=<IP of the host running volume>

export NOVA_PUBLIC_URL="http://$NOVA_IP:8774/v1.1/%(tenant_id)s"
export NOVA_ADMIN_URL=$NOVA_PUBLIC_URL
export NOVA_INTERNAL_URL=$NOVA_PUBLIC_URL

export GLANCE_PUBLIC_URL="http://$GLANCE_IP:9292/v1"
export GLANCE_ADMIN_URL=$GLANCE_PUBLIC_URL
export GLANCE_INTERNAL_URL=$GLANCE_PUBLIC_URL

export KEYSTONE_PUBLIC_URL="http://$KEYSTONE_IP:5000/v2.0"
export KEYSTONE_ADMIN_URL="http://$KEYSTONE_IP:35357/v2.0"
export KEYSTONE_INTERNAL_URL=$KEYSTONE_PUBLIC_URL

export VOLUME_PUBLIC_URL="http://$VOLUME_IP:8776/v1/$(tenant_id)s"
export VOLUME_ADMIN_URL=$VOLUME_PUBLIC_URL
export VOLUME_INTERNAL_URL=$VOLUME_PUBLIC_URL

sleep 1

keystone service-create --name nova --type compute --description 'OpenStack Compute Service'
keystone service-create --name glance --type image --description 'OpenStack Imnage Service'
keystone service-create --name keystone --type identity --description 'OpenStack Identity Service'
keystone service-create --name volume --type volume --description 'OpenStack Volume Service'

export COMPUTE=`keystone service-list|grep -i compute|awk '{print $2}'`
export IMAGE=`keystone service-list|grep -i image|awk '{print $2}'`
export IDENTITY=`keystone service-list|grep -i identity|awk '{print $2}'`
export VOLUME=`keystone service-list|grep -i volume|awk '{print $2}'`

keystone endpoint-create --region Western --service_id $COMPUTE --publicurl $NOVA_PUBLIC_URL --adminurl $NOVA_ADMIN_URL --internalurl $NOVA_INTERNAL_URL
keystone endpoint-create --region Western --service_id $IMAGE --publicurl $GLANCE_PUBLIC_URL --adminurl $GLANCE_ADMIN_URL --internalurl $GLANCE_INTERNAL_URL
keystone endpoint-create --region Western --service_id $IDENTITY --publicurl $KEYSTONE_PUBLIC_URL --adminurl $KEYSTONE_ADMIN_URL --internalurl $KEYSTONE_INTERNAL_URL
keystone endpoint-create --region Western --service_id $VOLUME --publicurl $VOLUME_PUBLIC_URL --adminurl $VOLUME_ADMIN_URL --internalurl $VOLUME_INTERNAL_URL

export TENANT=`keystone tenant-create --name Brinkster|grep id|awk '{print $4}'`
export ADMIN_ROLE=`keystone role-create --name Admin|grep id|awk '{print $4}'`

keystone user-create --name admin --tenant_id $TENANT --pass $SERVICE_TOKEN --email root@localhost --enabled true

export ADMIN=`keystone user-list|grep admin|awk '{print $2}'`

keystone user-role-add --user $ADMIN --role $ADMIN_ROLE --tenant_id $TENANT

keystone service-list
keystone tenant-list
keystone role-list
keystone user-list
