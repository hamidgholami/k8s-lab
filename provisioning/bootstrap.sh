#!/bin/bash
# update and upgrade OS
export DEBIAN_FRONTEND=noninteractive && apt update 2>/dev/null
apt upgrade -y