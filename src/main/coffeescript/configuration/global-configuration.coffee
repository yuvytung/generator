import log4js from "log4js"
import { dirname } from "path"

global.app = {}
global.env = process.env
global.APP_ENV = {}

app.workDirFullPath = dirname require.main.filename
app.rootDirPath = process.env.PWD
app.workDirPath = app.workDirFullPath.replace "#{process.env.PWD}/", ""
app.template = "src/main/resources/template"

global.log = log4js.getLogger " "
