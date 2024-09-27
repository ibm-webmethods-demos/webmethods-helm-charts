# API Control Plane deployment with helm

This is a customization from the product helm chart at https://github.com/SoftwareAG/webmethods-api-control-plane/tree/main/deployment/helm

## Releases

This is to track the chart releases (based on improvements etc...)

### Release 0.0.3

Chart Feature added:

 - Ability to leverage an external Elastic Search cluster
 - Ability to set license file as a secret
 - Ability to add annotations on all the services
 - Ability to add custom security context on the PODs and Containers
 - Ability to add a custom service account (or auto-create one)
 - add common labels and selectors
 - helm chart consolidation with a common functions file
 - external ingress enable / disable