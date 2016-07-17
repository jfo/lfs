#!/bin/bash

cp ./bash_profile_root /root/.bash_profile
cp ./bash_profile_lfs /home/lfs/.bash_profile
cp ./bashrc_lfs /home/lfs/.bashrc

chown lfs /home/lfs/.bashrc /home/lfs/.bash_profile 
