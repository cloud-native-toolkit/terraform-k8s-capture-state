#!/usr/bin/env bash

PLATFORM="$1"
NAMESPACE="$2"
OUTFILE="$3"
EXCLUSIONS="$4"

export PATH="${BIN_DIR}:${PATH}"

OUTFILE_DIR=$(dirname "${OUTFILE}")

clusterType="${PLATFORM}"

mkdir -p "${OUTFILE_DIR}"

resources="deployment,statefulset,service,ingress,configmap,secret,serviceaccount"
if [[ "$PLATFORM" == "openshift" ]] || [[ "$PLATFORM" == "ocp3" ]] || [[ "$PLATFORM" == "ocp4" ]]; then
  clusterType="openshift"

  resources="${resources},route"

  if [[ "$PLATFORM" == "ocp4" ]]; then
    resources="${resources},consolelink"
  fi
fi

echo "Checking on namespace - ${NAMESPACE}"

if kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null; then

  echo "deploy tool-test chart to namespace ${NAMESPACE}"
  helm template destroytest tool-test \
    --repo "https://charts.cloudnativetoolkit.dev" \
    --version 0.2.1  \
    --set global.clusterType=${clusterType} |  kubectl apply -n ${NAMESPACE} -f -
  
  kubectl rollout status deployment tool-test -n ${NAMESPACE}

  echo "Listing resources in namespace - ${resources}"
  RESOURCES=$(kubectl get -n "${NAMESPACE}" "${resources}" -o jsonpath='{range .items[*]}{.metadata.namespace}{"/"}{.kind}{"/"}{.metadata.name}{"\n"}{end}' | tr '[:upper:]' '[:lower:]')

  IFS=","
  for exclusion in ${EXCLUSIONS}; do
    RESOURCES=$(echo "${RESOURCES}" | grep -v "${exclusion}")
  done

  echo "${RESOURCES}" > "${OUTFILE}"
else
  echo "Namespace does not exist - ${NAMESPACE}"
  touch "${OUTFILE}"
fi

if kubectl get -n "${NAMESPACE}" subscription 1> /dev/null 2> /dev/null; then
  kubectl get -n "${NAMESPACE}" subscription -o jsonpath='{range .items[*]}{.metadata.namespace}{"/"}{.kind}{"/"}{.metadata.name}{"\n"}{end}' 2> /dev/null | \
    tr '[:upper:]' '[:lower:]' >> "${OUTFILE}"
fi

cat "${OUTFILE}"
