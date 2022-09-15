import glob from "glob"
import * as fs from "fs"
import * as path from "path"
import * as ejs from "ejs"

environments = YAML.parseFile "render-environments.yml"

processTemplateEjs = ->
  environments.modules.map (moduleName) ->
    moduleTemplatePath = "src/main/resources/template/#{moduleName}/main"
    moduleOutputPath = "build/output/#{moduleName}"
    glob
      .sync "#{moduleTemplatePath}/**/{.??,}*.ejs", {}
      .map (pathInput) ->
        pathOutput = pathInput
          .replace(moduleTemplatePath, moduleOutputPath)
          .replace /\.ejs$/g, ""
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.writeFileSync(
          pathOutput
          await ejs.renderFile pathInput, environments, charset: "utf8"
        )
    log.info "render module: #{moduleName} done!, output folder: #{moduleOutputPath}"
processTemplateBinary = ->
  environments.modules.map (moduleName) ->
    moduleTemplatePath = "src/main/resources/template/#{moduleName}/main"
    moduleOutputPath = "build/output/#{moduleName}"
    glob
      .sync "#{moduleTemplatePath}/**/{.??,}*.binary", {}
      .map (pathInput) ->
        pathOutput = pathInput
          .replace(moduleTemplatePath, moduleOutputPath)
          .replace /\.binary$/g, ""
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.copyFileSync pathInput, pathOutput
    log.info "render module: #{moduleName} done!, output folder: #{moduleOutputPath}"
export default ->
  log.debug "render", environments.modules
  processTemplateEjs()
  processTemplateBinary()
