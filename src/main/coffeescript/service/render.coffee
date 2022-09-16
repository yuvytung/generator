import glob from "glob"
import * as fs from "fs"
import * as path from "path"
import * as ejs from "ejs"
import Case from "case"

environments = YAML.parseFile "environments.yml"

caseProcessing = (resource = environments.ejs.environment.original) ->
  result = {}
  Object.keys(resource).forEach (key) ->
    # eslint-disable-next-line coffee/no-return-assign
    result["_#{key}"] =
      snake: Case.snake resource[key]
      pascal: Case.pascal resource[key]
      camel: Case.camel resource[key]
      kebab: Case.kebab resource[key]
      header: Case.header resource[key]
      constant: Case.constant resource[key]
      upper: Case.upper resource[key]
      lower: Case.lower resource[key]
      capital: Case.capital resource[key]
  result

ejsEnv = environments.ejs.environment.original
Object.assign ejsEnv, caseProcessing environments.ejs.environment.original

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
          await ejs.renderFile pathInput, ejsEnv, charset: "utf8"
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
  log.debug ejsEnv
  processTemplateEjs()
  processTemplateBinary()
