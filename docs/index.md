# Helm Charts for webMethods

This is a public Helm charts repo to have all the webMethods product deployments charts in 1 place...

## Install the Chart Repo

```bash
helm repo add webmethods-helm-charts https://ibm-webmethods-demos.github.io/webmethods-helm-charts
helm repo update
```

## Verify availability in your cluster

```bash
helm search repo <chart_name>
```

ie.

```bash
helm search repo webmethods-apigateway
```

## Deploy the charts

```bash
helm install <name> webmethods-helm-charts/<chart_name>
```

ie.

```
helm install webmethods-apigateway webmethods-helm-charts/webmethods-apigateway
```

## Support or Contact

Having trouble with these charts? Please submit an issue, right here, on GitHub!

Also, please refer to our blue-print sample deployments project at [webmethods-container-deployments](https://github.com/ibm-webmethods-demos/webmethods-container-deployments)

For more information on the Software AG products:
 - You can Ask a Question in the [TECHcommunity Forums](http://tech.forums.softwareag.com).
 - You can also find additional information in the [Software AG TECHcommunity](http://techcommunity.softwareag.com).

______________________
These Charts are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG Government Solutions welcomes contributions, we cannot guarantee to include every contribution in the master project.