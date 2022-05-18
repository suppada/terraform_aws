#!/usr/bin/env bash


TEMPLATE="file:///${WORKSPACE}/s3.yml"
# PARAMETERS=${DIR}/parameters.json
STACK_NAME=s3bucket

#read -p "stack:" INPUT
echo "User input: " ${INPUT}
echo "Template: " ${TEMPLATE}

if [ "${INPUT}" = create ] || [ "${INPUT}" = update ]
then
    echo "Creating/Updating stack..."
    STACK_ID=$( \
    aws cloudformation ${INPUT}-stack \
    --stack-name ${STACK_NAME} \
    --template-body ${TEMPLATE} \
    --parameters ${PARAMETERS} \
    --capabilities CAPABILITY_NAMED_IAM \
    | jq -r .StackId )
    echo "Waiting on ${STACK_ID} create/update completion..."
    aws cloudformation wait stack-${INPUT}-complete --stack-name ${STACK_ID}
    aws cloudformation describe-stacks --stack-name ${STACK_ID} | jq .Stacks[0].Outputs
elif [ "${INPUT}" = delete ]
then
    STACK_ID=$( \
    aws cloudformation ${INPUT}-stack \
    --stack-name ${STACK_NAME} \
    | jq -r .StackId \
    )
else
    echo ":${STACK_NAME}"
fi