## Helm Charts by SoftwareAG Government Solutions

This is a Helm Charts repository for the container images provided and maintained by [Software AG Government Solutions](https://www.softwareaggov.com)

### For more info on Software AG Government Solutions container images:

The webMethods containers provided by Software AG Government Solutions are ***security-enhanced and continuously maintained*** containers with the following highlights:

- Hardened Container base images sourced from Iron Bank for extra security,
- Continuously updated with latest OS fix levels,
- Continuously updated with latest SoftwareAG product fix levels,
- Extra configuration capabilities for easier deployment into various container platforms,
- Availability of Sample blueprint deployments

Product images are currently hosted in ***Software AG Government Solutions protected registry*** at: [ghcr.io/softwareag-government-solutions/](https://github.com/orgs/softwareag-government-solutions/packages)

To request access, contact Software AG Government Solutions at ***info@softwareaggov.com***

### Install the Chart Repo

```bash
helm repo add saggov-helm-charts https://softwareag-government-solutions.github.io/saggov-helm-charts
```

### Charts for SoftwareAG API Management

- saggov-helm-charts/webmethods-apigateway
- saggov-helm-charts/webmethods-devportal
- saggov-helm-charts/webmethods-terracotta
- saggov-helm-charts/sample-java-apis

Helm Charts sample deployments can be specifically found at: [webmethods API Management in Kubernetes](https://github.com/softwareag-government-solutions/webmethods-container-deployments/tree/main/kubernetes/api_management/)


#### Verify availability in your cluster

```bash
helm search repo <chart_name>
```

ie.

```bash
helm search repo webmethods-apigateway
```

#### Deploy the charts

```bash
helm install <name> saggov-helm-charts/<chart_name>
```

ie.

```
helm install webmethods-apigateway saggov-helm-charts/webmethods-apigateway
```

## Support or Contact

Having trouble with these charts? Please submit an issue, right here, on GitHub!

Also, please refer to our blue-print sample deployments project at [webmethods-container-deployments](https://github.com/softwareag-government-solutions/webmethods-container-deployments)

For more information on the SoftwareAG products:
 - You can Ask a Question in the [TECHcommunity Forums](http://tech.forums.softwareag.com).
 - You can also find additional information in the [Software AG TECHcommunity](http://techcommunity.softwareag.com).

Finally, for access and other general question, contact Software AG Government Solutions at ***info@softwareaggov.com***
