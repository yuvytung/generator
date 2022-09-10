import glob from "glob"
import * as fs from "fs"
import * as path from "path"
import * as ejs from "ejs"

modules = ["backend-nestjs", "frontend-reactjs"]

export default ->
  log.debug "render"
  modules.map (moduleName) ->
    moduleTemplatePath = "src/main/resources/template/#{moduleName}"
    moduleOutputPath = "build/out/#{moduleName}"
    glob
      .sync "#{moduleTemplatePath}/**/{.??*,*}.ejs", {}
      .map (pathInput) ->
        pathOutput = pathInput
          .replace(moduleTemplatePath, moduleOutputPath)
          .replace /.ejs$/g, ""
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.writeFileSync(
          pathOutput
          await ejs.renderFile pathInput, APP_ENV, charset: "utf8"
        )
    log.info "render module: #{moduleName} done!, output folder: #{moduleOutputPath}"
