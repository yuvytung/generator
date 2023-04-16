import log4js from "log4js";
import { dirname } from "path";
import yaml from "yaml";
import * as fs from "fs";
import { StringPool } from "../util/index.mjs";
import * as path from "path";
import { fileURLToPath } from "url";

global.env = process.env;

global.APP_ENV = {};
const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

global.app = {
  workDirFullPath: dirname(__dirname),
  rootDirPath: process.env.PWD,
  workDirPath: dirname(__dirname).replace(`${process.env.PWD}/`, StringPool.BLANK),
  template: "src/main/resources/template",
};

global.log = log4js.getLogger(" ");

global.YAML = yaml;
YAML.parseFile = (path, options = "utf8") => {
  const fullPath = path.startsWith("/") ? path : `${app.rootDirPath}/${path}`;
  return yaml.parse(fs.readFileSync(fullPath, options));
};
JSON.parseFile = (path, options = "utf8") => {
  const fullPath = path.startsWith("/") ? path : `${app.rootDirPath}/${path}`;
  return JSON.parse(fs.readFileSync(fullPath, options));
};
