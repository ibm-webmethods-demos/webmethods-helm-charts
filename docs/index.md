# Helm Charts for webMethods

This is a public Helm charts repo to have all the webMethods product deployments charts in 1 place...
Make sure you read the "IMPORTANT: Charts and App Version Compatibilities" section below...

## Install the Chart Repo

```bash
helm repo add webmethods-helm-charts https://ibm-webmethods-demos.github.io/webmethods-helm-charts
helm repo update
```

## Verify Chart availability

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

## IMPORTANT: Charts and App Version Compatibilities

These charts (like for the webMEthods API Gateway chart) are updated to supports multiple webMethods product versions.
Before you use a specific chart, make sure to ALWAYS identify what chart version correcponds to the version of the product your targetting.  

For Example, if you want ot deploy webMethods API Gateway 10.15 version, per the repo seartch below (and the "APP VERSION" column), the latest chart version compatible with webMethods API Gateway 10.15 would be "0.1.22"

```bash
helm search repo webmethods-helm-charts/webmethods-apigateway --versions

NAME                                              	CHART VERSION	APP VERSION	DESCRIPTION                                       
webmethods-helm-charts/webmethods-apigateway      	0.2.1        	11.1.x     	A Helm chart for SoftwareAG webMethods API Gate...
webmethods-helm-charts/webmethods-apigateway      	0.1.22       	10.15.x    	A Helm chart for SoftwareAG webMethods API Gate...
webmethods-helm-charts/webmethods-apigateway      	0.1.21       	10.15.x    	A Helm chart for SoftwareAG webMethods API Gate...
```

Once that is identified, use the helm chart's "--version" flag to make sure you use the right chart version when you uypgrade/install.

For example, for webMethods API Gateway 10.15, the helm install command would be: 

```bash
helm install --version 0.1.22 webmethods-apigateway webmethods-helm-charts/webmethods-apigateway
```

## Support or Contact

Having trouble with these charts? Please submit an issue, right here, on GitHub!

Also, please refer to our blue-print sample deployments project at [webmethods-container-deployments](https://github.com/ibm-webmethods-demos/webmethods-container-deployments)

For more information on the Software AG products:
 - You can Ask a Question in the [TECHcommunity Forums](http://tech.forums.softwareag.com).
 - You can also find additional information in the [Software AG TECHcommunity](http://techcommunity.softwareag.com).

______________________
These Charts are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG Government Solutions welcomes contributions, we cannot guarantee to include every contribution in the master project.