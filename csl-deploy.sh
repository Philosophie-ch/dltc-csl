#!/usr/bin/env bash


# This script is used to deploy the csl project to our templates folder

############
# SETUP
############

# Read from .env file if it exists, else exit with error
set -a
if [ -f ".env" ]; then
    . .env
else
    printf "No .env file found.\nPlease copy the .env.template file with the name ".env" and fill in the required variables.\n"
    exit 1
fi
set +a

required_env_vars=( "DLTC_CSL_DIRECTORY" )

# Check if required environment variables are set
for var_name in "${required_env_vars[@]}"; do
    if [ -z "${!var_name}" ]; then
        no_env_var_msg "${var_name}"
        exit 1
    fi
done

# Check if DLTC_WORKHOUSE_DIRECTORY exists
if [ ! -d "${DLTC_CSL_DIRECTORY}" ]; then
    printf 'Error: DLTC_CSL_DIRECTORY does not exist.\nPlease put the path to the shared dltc-workhouse folder in Dropbox.\n' >&2
    exit 1
fi



############
# MAIN
############

echo "Removing old dialectica.csl from ${DLTC_CSL_DIRECTORY}/dialectica.csl ..."
rm -rf "${DLTC_CSL_DIRECTORY}/dialectica.csl" && \
cp "dialectica.csl" "${DLTC_CSL_DIRECTORY}/dialectica.csl" && \
echo "Successfully deployed dialectica.csl to ${DLTC_CSL_DIRECTORY}/dialectica.csl"

