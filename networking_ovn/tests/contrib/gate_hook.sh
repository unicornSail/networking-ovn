#!/usr/bin/env bash

set -ex

VENV=${1:-"dsvm-functional"}

GATE_DEST=$BASE/new
NEUTRON_PATH=$GATE_DEST/neutron
DEVSTACK_PATH=$GATE_DEST/devstack
GATE_STACK_USER=stack

case $VENV in
"dsvm-functional"|"dsvm-functional-py35")
    source $DEVSTACK_PATH/functions
    source $NEUTRON_PATH/devstack/lib/ovs

    # NOTE(numans) Functional tests after upgrade to xenial in
    # the CI are breaking because of missing six package.
    # Installing the package for now as a workaround
    # https://bugs.launchpad.net/networking-ovn/+bug/1648670
    sudo pip install six
    # In order to run functional tests, we want to compile OVS
    # from sources and installed. We don't need to start ovs services.
    remove_ovs_packages
    # compile_ovs expects "DEST" to be defined
    DEST=$GATE_DEST
    compile_ovs True /usr/local /var

    # Make the workspace owned by GATE_STACK_USER
    sudo chown -R $GATE_STACK_USER:$GATE_STACK_USER $BASE
    ;;

*)
    echo "Unrecognized environment $VENV".
    exit 1
esac
