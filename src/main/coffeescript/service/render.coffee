import glob from "glob"
import * as fs from "fs"
import * as path from "path"
import * as ejs from "ejs"
import Case from "case"

environments = YAML.parseFile "environments.yml"

modules = Object.keys environments.modules

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

processTemplateEjs = (moduleName) ->
  subModules = environments.modules[moduleName]
  subModulesIncluded = ["main"]
    .concat((subModules && Object.keys(subModules))?.filter (key) -> subModules[key])
    .join "|"
  moduleTemplatePath = "src/main/resources/template/#{moduleName}"
  moduleOutputPath = "build/output/#{moduleName}"
  glob
    .sync "#{moduleTemplatePath}/@(#{subModulesIncluded})/**/{.??,}*.ejs", {}
    .map (pathInput) ->
      pathOutput = pathInput
        .replace(new RegExp("#{moduleTemplatePath}/[\\w]+"), moduleOutputPath)
        .replace /\.ejs$/g, ""
      fs.mkdirSync path.dirname(pathOutput), recursive: true
      fs.writeFileSync(
        pathOutput
        await ejs.renderFile(
          pathInput
          { ejsEnv..., modules: environments.modules[moduleName] }
          charset: "utf8"
        )
      )
processTemplateBinary = (moduleName) ->
  subModules = environments.modules[moduleName]
  subModulesIncluded = ["main"]
    .concat((subModules && Object.keys(subModules))?.filter (key) -> subModules[key])
    .join "|"
  moduleTemplatePath = "src/main/resources/template/#{moduleName}"
  moduleOutputPath = "build/output/#{moduleName}"
  glob
    .sync "#{moduleTemplatePath}/@(#{subModulesIncluded})/**/{.??,}*.binary", {}
    .map (pathInput) ->
      pathOutput = pathInput
        .replace(new RegExp("#{moduleTemplatePath}/[\\w]+"), moduleOutputPath)
        .replace /\.binary$/g, ""
      fs.mkdirSync path.dirname(pathOutput), recursive: true
      fs.copyFileSync pathInput, pathOutput
export default ->
  log.debug "render", environments.modules
  modules.map (moduleName) ->
    processTemplateEjs moduleName
    processTemplateBinary moduleName
    log.info "render module: #{moduleName} done!, output folder: build/output/#{moduleName}"
