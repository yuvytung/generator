import glob from "glob"
import * as fs from "fs"
import * as path from "path"
import * as ejs from "ejs"

modules = [
  #  "backend-nestjs"
  "frontend-reactjs"
]
binaryExtensions = [
  # # Audio
  "kar"
  "m4a"
  "mid"
  "midi"
  "mp3"
  "ogg"
  "ra"
  # # VIDEO
  "3gpp"
  "3gp"
  "as"
  "asf"
  "asx"
  "fla"
  "flv"
  "m4v"
  "mng"
  "mov"
  "mp4"
  "mpeg"
  "mpg"
  "swc"
  "swf"
  "webm"
  # # ARCHIVES
  "7z"
  "gz"
  "rar"
  "tar"
  "zip"
  # # FONTS
  "ttf"
  "eot"
  "otf"
  "woff"
  "woff2"
  # # Graphics
  "png"
  "jpg"
  "jpeg"
  "gif"
  "tif"
  "tiff"
  # # SVG
  "ico"
  "svg"
  "eps"
  # # Java
  "class"
  "jar"
  "war"
  # # Doc
  "doc"
  "DOC"
  "docx"
  "DOCX"
  "dot"
  "DOT"
  "pdf"
  "PDF"
  "rtf"
  "RTF"
]

detectBinaryFile = (p) ->
  p.match new RegExp "^.*\.(#{binaryExtensions.join "|"})$", "g"

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
        fs.mkdirSync path.dirname(pathOutput), recursive: true
        fs.copyFileSync pathInput, pathOutput
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
