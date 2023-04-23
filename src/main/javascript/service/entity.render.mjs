import glob from "glob";
import * as fs from "fs";
import * as path from "path";
import * as ejs from "ejs";
import { StringPool } from "../util/index.mjs";

const environments = YAML.parseFile("environments.yml");

const modules = Object.keys(environments.modules);

const ejsEnv = environments.ejs.environment.original;
Object.assign(ejsEnv, StringPool.caseProcessing(environments.ejs.environment.original));

const fieldTypeProcessing = type => {
  switch (type) {
    case "UUID":
      return "string";
    case "String":
      return "string";
    case "Long":
      return "number";
    case "Integer":
      return "number";
    case "Float":
      return "number";
    case "Double":
      return "number";
    case "Boolean":
      return "boolean";
    case "Instant":
      return "Date";
    case "LocalDate":
      return "Date";
    case "ZonedDateTime":
      return "Date";
    case "Duration":
      return "Date";
    default:
      return "string";
  }
};

const fieldType = {
  string: "string",
  number: "number",
  boolean: "boolean",
  date: "Date",
};

const processTemplateEjs = moduleName => {
  const subModulesIncluded = [ejsEnv.entityType].join("|");
  const moduleTemplatePath = `src/main/resources/template/${moduleName}`;
  const moduleOutputPath = `build/output/${moduleName}`;

  const entityProperty = glob
    .sync("entity/*.json", {})
    .map(entityPathJson => JSON.parseFile(entityPathJson));

  glob
    .sync(`${moduleTemplatePath}/@(${subModulesIncluded})/**/{.??,}*.ejs`, {})
    //    .filter (pathInput) ->
    //      environments?.modules?["backend-nestjs"]?.elasticsearch and
    //      pathInput.match(/.*__entity\.search\.repository\.ts\.ejs/g)?.length
    .map(pathInput => {
      entityProperty.map(async ep => {
        const pathOutput = pathInput
          .replace(new RegExp(`${moduleTemplatePath}/\\w+`), moduleOutputPath)
          .replace(/\.ejs$/g, "")
          .replace(/__entity/g, `${ep.name.kebab()}`);
        fs.mkdirSync(path.dirname(pathOutput), { recursive: true });
        fs.writeFileSync(
          pathOutput,
          await ejs
            .renderFile(
              pathInput,
              {
                ...ejsEnv,
                _entity: ep,
                _entities: entityProperty,
                _: {
                  fieldType,
                  Case: StringPool.case,
                  typeDetect: fieldTypeProcessing,
                },
                modules: environments.modules[moduleName],
              },
              { charset: "utf8" }
            )
            .catch(err => log.error(err))
        );
      });
    });
};

export default () => {
  log.debug("render", environments.modules);
  modules.map(moduleName => processTemplateEjs(moduleName));
};
