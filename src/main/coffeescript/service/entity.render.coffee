import glob from "glob"
import * as fs from "fs"
import * as path from "path"
import * as ejs from "ejs"
import { StringPool } from "../util/StringPool"

environments = YAML.parseFile "environments.yml"

modules = Object.keys environments.modules

ejsEnv = environments.ejs.environment.original
Object.assign ejsEnv, StringPool.caseProcessing environments.ejs.environment.original

fieldTypeProcessing = (type) ->
  switch
    when type is "UUID" then "string"
    when type is "String" then "string"
    when type is "Long" then "number"
    when type is "Integer" then "number"
    when type is "Float" then "number"
    when type is "Double" then "number"
    when type is "Boolean" then "boolean"
    when type is "Instant" then "Date"
    when type is "LocalDate" then "Date"
    when type is "ZonedDateTime" then "Date"
    when type is "Duration" then "Date"
    else "string"

fieldType =
  string: "string"
  number: "number"
  boolean: "boolean"
  date: "Date"

processTemplateEjs = (moduleName) ->
  subModulesIncluded = ["entity"].join "|"
  moduleTemplatePath = "src/main/resources/template/#{moduleName}"
  moduleOutputPath = "build/output/#{moduleName}"

  entityProperty = glob
    .sync "entity/*.json", {}
    .map (entityPathJson) ->
      JSON.parseFile entityPathJson

  glob
    .sync "#{moduleTemplatePath}/@(#{subModulesIncluded})/**/{.??,}*.ejs", {}
    #    .filter (pathInput) ->
    #      environments?.modules?["backend-nestjs"]?.elasticsearch and
    #      pathInput.match(/.*__entity\.search\.repository\.ts\.ejs/g)?.length
    .map (pathInput) ->
      epsCP = entityProperty.map (ep) -> StringPool.caseProcessing ep
      entityProperty.map (ep) ->
        epCaseProcessed = StringPool.caseProcessing ep
        pathOutput = pathInput
          .replace new RegExp("#{moduleTemplatePath}/[\\w]+"), moduleOutputPath
          .replace /\.ejs$/g, ""
          # eslint-disable-next-line coffee/no-underscore-dangle
          .replace /__entity/g, "#{epCaseProcessed._name.kebab}"
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.writeFileSync(
          pathOutput
          await ejs
            .renderFile(
              pathInput
              {
                ejsEnv...
                _entity: {
                  epCaseProcessed...
                  ep...
                }
                _entities: epsCP
                _: {
                  fieldType
                  Case: StringPool.case
                  typeDetect: fieldTypeProcessing
                }
                modules: environments.modules[moduleName]
              }
              charset: "utf8"
            )
            .catch (err) -> log.error err
        )

export default ->
  log.debug "render", environments.modules
  modules.map (moduleName) ->
    processTemplateEjs moduleName
