export default ->
  log.debug "before render"
  log.debug app

  global.APP_ENV =
    baseName: "catiny"
    serverPort: "8081"
    prefix: "nhi_"
    suffix: ""
    entitySuffix: ""
    dtoSuffix: "DTO"
    nativeLanguage: "en"
    packageFolder: "com/jhipster/node"
    serviceDiscoveryType: true
    websocket: true
    searchEngine: "elasticsearch"
    messageBroker: "kafka"
    clientPackageManager: "yarn"
    buildTool: "gradle"

  undefined
