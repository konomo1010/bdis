filesSave=../files

if [ ! -d ${filesSave} ];then
    mkdir -p ../files
fi

#############################################  CA  ##################################################
cat > ${filesSave}/k8s-ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "876000h"
        },
        "profiles": {
            "kubernetes-ca": {
                "expiry": "876000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            
            "kubernetes-ca-server": {
                "expiry": "876000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            
            "kubernetes-ca-client": {
                "expiry": "876000h",
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
            "expiry": "876000h"
        },
        "profiles": {
            "kubernetes-front-proxy-ca": {
                "expiry": "876000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            "kubernetes-front-proxy-ca-server": {
                "expiry": "876000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "kubernetes-front-proxy-ca-client": {
                "expiry": "876000h",
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
echo "====> k8s-ca"
cfssl gencert -initca ${filesSave}/k8s-ca-csr.json | cfssljson -bare ${filesSave}/k8s-ca -
echo ""

echo "====> k8s-front-proxy-ca"
cfssl gencert -initca ${filesSave}/k8s-front-proxy-ca-csr.json | cfssljson -bare ${filesSave}/k8s-front-proxy-ca -
echo ""


################################### 

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

echo "====> front-proxy-client"
cfssl gencert \
-ca=${filesSave}/k8s-front-proxy-ca.pem \
-ca-key=${filesSave}/k8s-front-proxy-ca-key.pem \
-config=${filesSave}/k8s-front-proxy-ca-config.json \
-profile=kubernetes-front-proxy-ca-client \
${filesSave}/front-proxy-client-csr.json | cfssljson -bare ${filesSave}/front-proxy-client -
echo ""