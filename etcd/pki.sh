cat >etcd-ca-config.json<<EOF
{
    "signing": {
        "default": {
            "expiry": "168h"
        },
        "profiles": {
            "etcd-ca": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            
            "etcd-ca-server": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            
            "etcd-ca-client": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            }
        }
    }
}
EOF

cat >etcd-ca-csr.json<<EOF
{
    "CN": "etcd-ca",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC"
        }
    ]
}
EOF

################################################ Cert ###############################################
# 需要与etcd通信有：
# 	apiserver
# 	flannel , 每个node节点都需要安装。

#  hosts : 为etcd服务端配置一个域名。客户端访问这个域名时需要做hosts 或者 DNS。
cat >etcd-client-csr.json<<EOF
{
    "CN": "kube-etcd",
    "hosts": [
    	"localhost",
    	"127.0.0.1",
		"etcd.svc.local" 
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC"
        }
    ]
}
EOF


cat >etcd-peer-csr.json<<EOF
{
    "CN": "kube-etcd-peer",
    "hosts": [
        "localhost",
        "127.0.0.1",
        "etcd-01",
        "etcd-02",
        "etcd-03"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC"
        }
    ]
}
EOF


cat >kube-apiserver-etcd-client-csr.json<<EOF
{
    "CN": "kube-apiserver-etcd-client",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "system:masters"
        }
    ]
}
EOF


cat >kube-etcd-healthcheck-client-csr.json<<EOF
{
    "CN": "kube-etcd-healthcheck-client",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC"
        }
    ]
}
EOF



cfssl gencert -initca etcd-ca-csr.json | cfssljson -bare etcd-ca -

cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem -config=etcd-ca-config.json -profile=etcd-ca etcd-client-csr.json | cfssljson -bare etcd-client -

cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem -config=etcd-ca-config.json -profile=etcd-ca etcd-peer-csr.json | cfssljson -bare etcd-peer -

cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem -config=etcd-ca-config.json -profile=etcd-ca-client kube-etcd-healthcheck-client-csr.json | cfssljson -bare kube-etcd-healthcheck-client -

cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem -config=etcd-ca-config.json -profile=etcd-ca-client kube-apiserver-etcd-client-csr.json | cfssljson -bare kube-apiserver-etcd-client -
