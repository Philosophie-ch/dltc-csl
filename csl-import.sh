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

# Check if dialectica.csl exists
if [ ! -f "dialectica.csl" ]; then
    printf 'Error: dialectica.csl does not exist locally.\n' >&2
    exit 1
fi

# Check if source dialectica.csl exists in DLTC_CSL_DIRECTORY
if [ ! -f "${DLTC_CSL_DIRECTORY}/dialectica.csl" ]; then
    printf "Error: dialectica.csl does not exist in ${DLTC_CSL_DIRECTORY}.\n" >&2
    exit 1
fi


############
# MAIN
############

printf "\nRemoving local dialectica.csl from ${PWD}"
rm -rf "dialectica.csl" && \
cp "${DLTC_CSL_DIRECTORY}/dialectica.csl" "dialectica.csl"  && \
printf "\n\nSuccessfully imported dialectica.csl from\n\t${DLTC_CSL_DIRECTORY}/dialectica.csl\n"

