## Samples for the Application Programming Model for SAP Cloud Platform

The following samples give you more hands-on practice with the [application programming model for SAP Cloud Platform](https://help.sap.com/viewer//65de2977205c403bbc107264b8eccf4b/Cloud/en-US/00823f91779d4d42aa29a498e0535cdf.html):

* Part 1 - [Foundation](https://github.com/SAP/cloud-samples-foundation/tree/rel-1.0)
* Part 2 - [Product Catalog](https://github.com/SAP/cloud-samples-catalog/tree/rel-1.0)
* Part 3 - ITelO Catalog (current repository)

### Part 3: ITelO Catalog (Extension Scenario)

The ITelO Catalog shows a sample business application implemented by a team of the fictitious company ITelO. This team needed to implement a product catalog. Looking through available CDS reuse models, they found the [Product Catalog](https://github.com/SAP/cloud-samples-catalog/tree/rel-1.0). As an extra requirement, the team needed to include product reviews as an additional source of information for the editor of the product catalog. Unfortunately, reviews are not modeled in the [Product Catalog](https://github.com/SAP/cloud-samples-catalog/tree/rel-1.0). Thanks to the application programming model for SAP Cloud Platform they could solve this issue by simply extending the service with additional review entities.

Technically the sample consists of:

* a CDS model (find more information [here](https://help.sap.com/viewer//65de2977205c403bbc107264b8eccf4b/Cloud/en-US/855e00bd559742a3b8276fbed4af1008.html))
* an automatic Java OData V2 exposure extended by individual business logic (find more information [here](https://help.sap.com/viewer//65de2977205c403bbc107264b8eccf4b/Cloud/en-US/68af515a26d944c38d81fd92ad33681e.html))
* a UI based on SAP Fiori elements (find more information [here](https://help.sap.com//SAPUI5_PDF/SAPUI5.pdf)).

This application is only an example and not intended for productive use.

### Component Overview

![Component overview](.docs/itelo.png "Component overview")

## Requirements

SAP Web IDE Full-Stack access is needed. For more information, see [Open SAP Web IDE](https://help.sap.com/viewer/825270ffffe74d9f988a0f0066ad59f0/CF/en-US/51321a804b1a4935b0ab7255447f5f84.html).

## Development in SAP Cloud Platform Web IDE

Read the [getting started tutorial](https://help.sap.com/viewer//65de2977205c403bbc107264b8eccf4b/Cloud/en-US/5ec8c983a0bf43b4a13186fcf59015fc.html) to learn more about working with SAP Cloud Platform Web IDE.

Now clone your fork of this repository (*File -> Git -> Clone Repository*).

### Develop, Build, Deploy

To build and deploy your application or modify it and redeploy, use any of the following options:

* Build and deploy the DB module by choosing *Build* from the context menu of the db folder.

* Build and deploy the Java service by choosing *Run -> Run as -> Java application* from the context menu of the srv folder. To test the service, click the URL displayed in the Run Console. Use the endpoint of the service *clouds.products.CatalogService* to call $metadata or CRUD requests.

* Test the UI by choosing *Run -> Run as -> SAP Fiori Launchpad Sandbox* from the context menu of the app folder. Click on the app tile to launch the application.

## Known Issues

* The read only field _Availability_ is enabled occasionally when creating a new Product.

* Requesting reviews on the product object page causes a CDSRuntimeException.INTERNAL_ERROR when using SAP HANA 2.0 SPS 0.

## Support

This project is provided "as-is": there is no guarantee that raised issues will be answered or addressed in future releases.

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This project is licensed under the Apache Software License, Version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
