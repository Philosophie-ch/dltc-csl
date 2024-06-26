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

bak_dir="${DLTC_CSL_DIRECTORY}/csl-bak"
hash=$(date +"%Y-%m-%d_%H-%M-%S")
hash+="_${USER}"


############
# MAIN
############

# Prompt user to confirm deployment
read -p "Are you sure you want to deploy the dialectica.csl to ${DLTC_CSL_DIRECTORY}? (y/n) " -n 1 -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    printf "\nDeployment aborted.\n"
    exit 1
fi

# Deploy safely
printf "\n\nWill create a back-up from\n\t${DLTC_CSL_DIRECTORY}/dialectica.csl\n to\n\t${bak_dir}/dialectica.csl.bak.${hash}"
mkdir -p "${bak_dir}" && \
mv "${DLTC_CSL_DIRECTORY}/dialectica.csl" "${bak_dir}/dialectica.csl_${hash}" && \
cp "dialectica.csl" "${DLTC_CSL_DIRECTORY}/dialectica.csl" && \
printf "\n\nSuccessfully deployed local dialectica.csl to\n\t${DLTC_CSL_DIRECTORY}/dialectica.csl\n"


