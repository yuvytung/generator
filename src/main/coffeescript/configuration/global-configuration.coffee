import log4js from "log4js"
import { dirname } from "path"
import yaml from "yaml"
import * as fs from "fs"
import { StringPool } from "../util"

global.env = process.env

global.APP_ENV = {}

global.app =
  workDirFullPath: dirname require.main.filename
  rootDirPath: process.env.PWD
  workDirPath: dirname(require.main.filename).replace(
    "#{process.env.PWD}/"
    StringPool.BLANK
  )
  template: "src/main/resources/template"

global.log = log4js.getLogger " "

global.YAML = yaml
YAML.parseFile = (path, options = "utf8") ->
  fullPath = if path.startsWith "/" then path else "#{app.rootDirPath}/#{path}"
  yaml.parse fs.readFileSync fullPath, options
JSON.parseFile = (path, options = "utf8") ->
  fullPath = if path.startsWith "/" then path else "#{app.rootDirPath}/#{path}"
  JSON.parse fs.readFileSync fullPath, options
