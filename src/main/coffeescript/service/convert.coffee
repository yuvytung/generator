import glob from "glob"
import * as fs from "fs"
import * as path from "path"

modules = [
  #  "backend-nestjs"
  "frontend-reactjs"
]

environments = YAML.parseFile "environments.yml"
binaryExtensions = environments.file.typeExtensions.binary
textExtensions = environments.file.typeExtensions.text

detectFile = (p, extensions) ->
  p.match new RegExp "^.*.(#{extensions.join "|"})$", "g"

export default ->
  log.debug "convert"
  modules.map (moduleName) ->
    moduleTemplatePath = "tmp/#{moduleName}"
    moduleOutputPath = "src/main/resources/template/#{moduleName}/main"
    allFile = glob.sync "#{moduleTemplatePath}/**/{.??,}*", nodir: true
    countProcessed = allFile
      .filter (pathInput) -> detectFile pathInput, binaryExtensions
      .map (pathInput) ->
        pathOutput = pathInput
          .replace(moduleTemplatePath, moduleOutputPath)
          .concat ".binary"
        return { pathOutput, pathInput }
      .concat(
        allFile
          .filter (pathInput) -> detectFile pathInput, textExtensions
          .map (pathInput) ->
            pathOutput = pathInput
              .replace(moduleTemplatePath, moduleOutputPath)
              .concat ".ejs"
            return { pathOutput, pathInput }
      )
      .map(({ pathOutput, pathInput }) ->
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.copyFileSync pathInput, pathOutput
      ).length
    log.info """convert module: #{moduleName} done!
      ->
        processed: #{countProcessed}
        total: #{allFile.length}
        output folder: #{moduleOutputPath}
      """
