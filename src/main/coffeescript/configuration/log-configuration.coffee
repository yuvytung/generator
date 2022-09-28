import log4js from "log4js"

log4js.configure
  appenders:
    console:
      type: "console"
      layout:
        type: "pattern"
        pattern: "%d{hh:mm:ss.SSS} %[%5.-5p%]|%-0.-20c|%-40.-50x{fileName} --> %m"
        tokens:
          fileName: (logEvent) ->
            logEvent.fileName
              .replace "#{app.rootDirPath}/src/main/coffeescript/", ""
              .replace /.js$/g, ""
              .concat ":#{logEvent.lineNumber}"
  categories:
    default:
      appenders: ["console"]
      level: if process.argv.includes "debug" then "debug" else "info"
      enableCallStack: true
