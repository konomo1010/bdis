filesSave=../files

if [ ! -d ${filesSave} ];then
    mkdir -p ../files
fi




##################### CA

#############################################  CA  ##################################################
cat > ${filesSave}/k8s-ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "8760h"
        },
        "profiles": {
            "kubernetes-ca": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            
            "kubernetes-ca-server": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            
            "kubernetes-ca-client": {
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
cat > ${filesSave}/k8s-ca-csr.json <<EOF
{
    "CN": "kubernetes-ca",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF
cat > ${filesSave}/k8s-front-proxy-ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "8760h"
        },
        "profiles": {
            "kubernetes-front-proxy-ca": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            "kubernetes-front-proxy-ca-server": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "kubernetes-front-proxy-ca-client": {
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
cat > ${filesSave}/k8s-front-proxy-ca-csr.json <<EOF
{
    "CN": "kubernetes-front-proxy-ca",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

################################################ Cert ###############################################

cat > ${filesSave}/kube-apiserver-csr.json <<EOF
{
    "CN": "kube-apiserver",
    "hosts": [
      "10.1.0.1",
      "127.0.0.1",
      "192.168.1.101",
      "192.168.2.11",
      "kube-apiserver",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF
cat > ${filesSave}/kube-apiserver-client-csr.json <<EOF
{
    "CN": "kube-apiserver-client",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "system:masters",
            "OU": "System"
        }
    ]
}
EOF

cat > ${filesSave}/front-proxy-client-csr.json <<EOF
{
    "CN": "front-proxy-client",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF


echo "====> k8s-ca"
cfssl gencert -initca ${filesSave}/k8s-ca-csr.json | cfssljson -bare ${filesSave}/k8s-ca -
echo ""

echo "====> kube-apiserver"
cfssl gencert \
-ca=${filesSave}/k8s-ca.pem \
-ca-key=${filesSave}/k8s-ca-key.pem \
-config=${filesSave}/k8s-ca-config.json \
-profile=kubernetes-ca-server \
${filesSave}/kube-apiserver-csr.json | cfssljson -bare ${filesSave}/kube-apiserver - 
echo ""

echo "====> kube-apiserver-client"
cfssl gencert \
-ca=${filesSave}/k8s-ca.pem \
-ca-key=${filesSave}/k8s-ca-key.pem \
-config=${filesSave}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${filesSave}/kube-apiserver-client-csr.json | cfssljson -bare ${filesSave}/kube-apiserver-client -
echo ""

echo "====> k8s-front-proxy-ca"
cfssl gencert -initca ${filesSave}/k8s-front-proxy-ca-csr.json | cfssljson -bare ${filesSave}/k8s-front-proxy-ca -
echo ""

echo "====> front-proxy-client"
cfssl gencert \
-ca=${filesSave}/k8s-front-proxy-ca.pem \
-ca-key=${filesSave}/k8s-front-proxy-ca-key.pem \
-config=${filesSave}/k8s-front-proxy-ca-config.json \
-profile=kubernetes-front-proxy-ca-client \
${filesSave}/front-proxy-client-csr.json | cfssljson -bare ${filesSave}/front-proxy-client -
echo ""

echo "====> bootstrap-token.csv"
echo "`openssl rand -hex 16`,kubelet-bootstrap,10001,"system:kubelet-bootstrap"" > ${filesSave}/bootstrap-token.csv
echo ""