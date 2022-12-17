targetScope = 'resourceGroup'

param envName string

// https://learn.microsoft.com/en-us/azure/api-management/quickstart-bicep?tabs=CLI

@description('The name of the API Management service instance')
param apiManagementServiceName string = '${uniqueString(resourceGroup().id)}-apim'

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string

@description('The name of the owner of the service')
@minLength(1)
param publisherName string

@description('Location for all resources.')
param location string = resourceGroup().location

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

resource topLevelPolicy 'Microsoft.ApiManagement/service/policies@2021-12-01-preview' = {
  name: 'policy'
  parent: apiManagementService
  properties: {
    format: 'rawxml'
    value: loadTextContent('topLevelPolicy.xml')
  }
}

resource api 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = {
  name: 'myAPI'
  parent: apiManagementService
  properties: {
    description: ''
    displayName: 'My API'
    path: 'my'
    apiRevision: '1'
    serviceUrl: 'https://foo.bar'
    protocols: [ 'https' ]
    subscriptionRequired: false
    type: 'http'
  }

  resource policy 'policies@2021-01-01-preview' = {
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: loadTextContent('apiPolicy.xml')
    }
  }
}

resource operation 'Microsoft.ApiManagement/service/apis/operations@2022-04-01-preview' = {
  name: 'ping'
  parent: api
  properties: {
    displayName: 'Ping'
    method: 'GET'
    urlTemplate: '/ping'
    templateParameters: []
    request: {
      queryParameters: []
      headers: []
      representations: []
    }
    responses: []
  }
}
