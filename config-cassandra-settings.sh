PUBLICIPADDR=$1

echo "Using public ip address $PUBLICIPADDR"

echo "stopping cassandra "
sudo service cassandra stop

echo "Changing Hints directory"
sudo mkdir /mnt/disks/ssd/hints/
sudo chown -R cassandra:cassandra /mnt/disks/ssd/hints/

sudo sed -i -e "s+# hints_directory: /var/lib/cassandra/hints+hints_directory: /mnt/disks/ssd/hints+" /etc/cassandra/cassandra.yaml

echo "Changing Data directory"
sudo mkdir /mnt/disks/ssd/data/
sudo chown -R cassandra:cassandra /mnt/disks/ssd/data/

sudo sed -i -e "s+- /var/lib/cassandra/data+-  /mnt/disks/ssd/data+" /etc/cassandra/cassandra.yaml

echo "Changing Commitlog directory"
sudo mkdir /mnt/disks/ssd/commitlog/
sudo chown -R cassandra:cassandra /mnt/disks/ssd/commitlog/

sudo sed -i -e "s+/var/lib/cassandra/commitlog+/mnt/disks/ssd/commitlog+" /etc/cassandra/cassandra.yaml

echo "Changing saved_caches directory"
sudo mkdir /mnt/disks/ssd/saved_caches/
sudo chown -R cassandra:cassandra /mnt/disks/ssd/saved_caches/

sudo sed -i -e "s+/var/lib/cassandra/saved_caches+/mnt/disks/ssd/saved_caches+" /etc/cassandra/cassandra.yaml

echo "Enabeling JMX"
sudo sed -i -e "s+    LOCAL_JMX=yes+    LOCAL_JMX=no+" /etc/cassandra/cassandra-env.sh

echo "Changing public JMX ip add to $PUBLICIPADDR"
sudo sed -i -e 's+# JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname=<public name>"+JVM_OPTS="$JVM_OPTS -Djava.rmi.server.hostname= $PUBLICIPADDR"+' /etc/cassandra/cassandra-env.sh


echo "Changing need for jmx authentication to false"
sudo sed -i -e 's+-Dcom.sun.management.jmxremote.authenticate=true"+-Dcom.sun.management.jmxremote.authenticate=false"+' /etc/cassandra/cassandra-env.sh


echo "Changing read_request_timeout_in_ms from 5000ms to 20000ms"
sudo sed -i -e "s+read_request_timeout_in_ms: 5000+read_request_timeout_in_ms: 20000+" /etc/cassandra/cassandra.yaml

echo "Changing write_request_timeout_in_ms from 2000 to 20000ms"
sudo sed -i -e "s+write_request_timeout_in_ms: 2000+write_request_timeout_in_ms: 20000+" /etc/cassandra/cassandra.yaml

echo "Changing request_timeout_in_ms from 10000 to 20000ms"
sudo sed -i -e "s+request_timeout_in_ms: 10000+request_timeout_in_ms: 20000+" /etc/cassandra/cassandra.yaml


echo "starting cassandra"
sudo service cassandra start