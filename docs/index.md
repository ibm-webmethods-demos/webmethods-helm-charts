## Helm Charts by Software AG Government Solutions

This is a Helm Charts repository for the Software AG Product Container Images provided and maintained by [Software AG Government Solutions](https://www.softwareaggov.com).

For more information on these containers, go to: [Product Containers by Software AG Government Solutions](https://softwareag-government-solutions.github.io/saggov-containers/)

### Install the Chart Repo

```bash
helm repo add saggov-helm-charts https://softwareag-government-solutions.github.io/saggov-helm-charts
```

### Charts for Software AG API Management

- saggov-helm-charts/webmethods-apigateway
- saggov-helm-charts/webmethods-microgateway
- saggov-helm-charts/webmethods-devportal
- saggov-helm-charts/webmethods-terracotta
- saggov-helm-charts/samplejavaapis-sidecar-microgateway

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

For more information on the Software AG products:
 - You can Ask a Question in the [TECHcommunity Forums](http://tech.forums.softwareag.com).
 - You can also find additional information in the [Software AG TECHcommunity](http://techcommunity.softwareag.com).

Finally, for access and other general question, contact Software AG Government Solutions at ***info@softwareaggov.com***

______________________
These Charts are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG Government Solutions welcomes contributions, we cannot guarantee to include every contribution in the master project.