import glob from "glob"
import * as fs from "fs"
import * as path from "path"

modules = [
  #  "backend-nestjs"
  "frontend-reactjs"
]

environments = YAML.parseFile "environments.yml"
binaryExtensions = environments.file.typeExtensions.binary

detectBinaryFile = (p) ->
  p.match new RegExp "^.*.(#{binaryExtensions.join "|"})$", "g"

export default ->
  log.debug "convert"
  modules.map (moduleName) ->
    moduleTemplatePath = "tmp/#{moduleName}"
    moduleOutputPath = "src/main/resources/template/#{moduleName}/main"
    allFile = glob.sync "#{moduleTemplatePath}/**/{.??,}*", nodir: true
    allFile
      .filter detectBinaryFile
      .map (pathInput) ->
        pathOutput = pathInput
          .replace(moduleTemplatePath, moduleOutputPath)
          .concat ".binary"
        return { pathOutput, pathInput }
      .concat(
        allFile
          .filter (pathInput) -> !detectBinaryFile pathInput
          .map (pathInput) ->
            pathOutput = pathInput
              .replace(moduleTemplatePath, moduleOutputPath)
              .concat ".ejs"
            return { pathOutput, pathInput }
      )
      .map ({ pathOutput, pathInput }) ->
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.copyFileSync pathInput, pathOutput
    log.info "convert module: #{moduleName} done!, output folder: #{moduleOutputPath}"
