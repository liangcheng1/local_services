#!/bin/bash

# Author: Bin Wu <binwu@google.com>

pwd=`pwd`
ipaddr=$(hostname -I | cut -d ' ' -f 1)
cluster_name=elk
region=asia-east1
# zone=asia-east1-a
project_id=google.com:bin-wus-learning-center
default_pool=default-pool

kbn_name=kbn

__usage() {
    echo "Usage: ./bin/kbn.sh {deploy|status|clean}"
}

__deploy() {
    kubectl apply -f $pwd/deploy/kbn.yml
}

__clean() {
    kubectl delete -f $pwd/deploy/kbn.yml
}

__status() {
    lb_ip=`kubectl get services ${kbn_name}-kb-http -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`

    echo "http://${lb_ip}:5601"
}

__main() {
    if [ $# -eq 0 ]
    then
        __usage
    else
        case $1 in
            deploy|d)
                __deploy
                ;;
            status|s)
                __status
                ;;
            clean)
                __clean
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@
