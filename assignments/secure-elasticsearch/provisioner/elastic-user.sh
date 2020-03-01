/usr/share/elasticsearch/bin/elasticsearch-users useradd test -p test123 -r superuser
sleep 5
curl --cacert /usr/share/elasticsearch/config/certs/ca/ca.crt -XPUT -H "Content-Type: application/json" -u test:test123 'https://{{ hostvars[groups['elastic'][0]].ansible_host }}:9200/_xpack/security/user/kibana/_password' -d '{ "password" : "kibana123" }'

