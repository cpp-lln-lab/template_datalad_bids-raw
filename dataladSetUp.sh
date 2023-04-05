#!/usr/bin/env bash

# for instructions on how to name it according to the lab guide
# see https://github.com/cpp-lln-lab/dataset_maintenance 
# example: 3018_Shire_LOTR_FB_raw
GIN_BASENAME=''

root_dir=${PWD}
source_dir=${root_dir}/sourcedata
# optional
# derivatives_dir=${root_dir}/derivatives

# create the repo on gin for the root directory

datalad create-sibling-gin -d . -s origin --access-protocol ssh --private   cpp-lln-lab/"${GIN_BASENAME}"

# create the sourcedata for DICOMS as a separate subdataset 
datalad create -d . -c text2git "${source_dir}" 

# enter the sourcedata and from there create the repo (sourcedata's sibling) on gin server
cd "${source_dir}"

datalad create-sibling-gin -d . -s origin --access-protocol ssh --private   cpp-lln-lab/"${GIN_BASENAME}"-source
    
#re set the gin url on the root
cd "${root_dir}"

datalad subdatasets --set-property url https://gin.g-node.org/cpp-lln-lab/"${GIN_BASENAME}"-source "${sourcedata}"

# repeat the process for derivatives if necessary
if [ ! -z "${derivatives_dir}" ]; then

    datalad create -d . "${derivatives_dir}"

    cd "${derivatives_dir}"
    datalad create-sibling-gin -d . -s origin --access-protocol ssh --private  cpp-lln-lab/"${GIN_BASENAME}"-derivatives

    cd "${root_dir}"
    datalad subdatasets --set-property url https://gin.g-node.org/cpp-lln-lab/"${GIN_BASENAME}"-derivatives derivatives

fi

cd "${root_dir}"

datalad push --to origin -r

echo "############################"
echo "# DATALAD IS READY TO WORK #"
echo "############################"
