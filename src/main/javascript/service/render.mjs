import glob from "glob";
import * as fs from "fs";
import * as path from "path";
import * as ejs from "ejs";
import { StringPool } from "../util/index.mjs";

const environments = YAML.parseFile("environments.yml");

const modules = Object.keys(environments.modules);

const ejsEnv = environments.ejs.environment.original;
Object.assign(ejsEnv, StringPool.caseProcessing(environments.ejs.environment.original));

const renderProcessing = (moduleName) => {
  const subModules = environments.modules[moduleName];
  const subModulesIncluded = []
    .concat((subModules && Object.keys(subModules)).filter((key) => subModules[key]))
    .map((key) => subModules[key])
    .join("|");
  const moduleTemplatePath = `src/main/resources/template/${moduleName}`;
  const moduleOutputPath = `build/output/${moduleName}`;
  glob
    .sync(`${moduleTemplatePath}/@(${subModulesIncluded})/{.??,}**/{.??,}*.ejs`, {})
    .filter((pathInput) => !pathInput.match(/^.*\/__.*.ts$/g))
    .map(async (pathInput) => {
      const pathOutput = pathInput
        .replace(new RegExp(`${moduleTemplatePath}/\\w+`), moduleOutputPath)
        .replace(/\.ejs$/g, "");
      fs.mkdirSync(path.dirname(pathOutput), { recursive: true });
      fs.writeFileSync(
        pathOutput,
        await ejs.renderFile(
          pathInput,
          { ...ejsEnv, modules: environments.modules[moduleName] },
          { charset: "utf8" },
        ),
      );
    });
  glob
    .sync(`${moduleTemplatePath}/@(${subModulesIncluded})/**/{.??,}*.binary`, {})
    .map((pathInput) => {
      const pathOutput = pathInput
        .replace(new RegExp(`${moduleTemplatePath}/\\w+`), moduleOutputPath)
        .replace(/\.binary$/g, "");
      fs.mkdirSync(path.dirname(pathOutput), { recursive: true });
      fs.copyFileSync(pathInput, pathOutput);
    });
};

export default () => {
  log.debug("render", environments.modules);
  modules.map((moduleName) => {
    renderProcessing(moduleName);
    log.info(`render module: ${moduleName} done!, output: build/output/${moduleName}`);
  });
};
