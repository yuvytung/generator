import glob from "glob";
import * as fs from "fs";
import * as path from "path";
import * as ejs from "ejs";
import { StringPool } from "../util/index.mjs";

const environments = YAML.parseFile("environments.yml");

const modules = Object.keys(environments.modules);

const ejsEnv = environments.ejs.environment.original;
Object.assign(ejsEnv, StringPool.caseProcessing(environments.ejs.environment.original));

const fieldTypeProcessing = (type) => {
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
      return type;
  }
};

const fieldType = {
  string: "string",
  number: "number",
  boolean: "boolean",
  date: "Date",
};

const processTemplateEjs = (moduleName) => {
  const subModulesIncluded = [ejsEnv.entityType].join("|");
  const moduleTemplatePath = `src/main/resources/template/${moduleName}`;
  const moduleOutputPath = `build/output/${moduleName}`;

  const entityProperty = glob
    .sync("entity/*.json", {})
    .map((entityPathJson) => JSON.parseFile(entityPathJson));

  // enum processing
  const allEnum = {};
  entityProperty.map((ep) =>
    ep.fields
      .filter((f) => f.fieldValues?.match(/[\w,]+/g))
      .map((enumField) => {
        enumField.enumValues = enumField.fieldValues.split(",").map((v) => ({
          key: v.split(" ")[0],
          value: v.split(" ")[1]?.replace(/[()]/g, "") || v.split(" ")[0],
        }));
        allEnum[enumField.fieldType] = enumField;
      }),
  );

  glob
    .sync(`${moduleTemplatePath}/@(${subModulesIncluded})/**/__enum.{.??,}*.ejs`, {})
    .map((pathInput) => {
      Object.keys(allEnum)
        .map((v) => allEnum[v])
        .map(async (en) => {
          const pathOutput = pathInput
            .replace(new RegExp(`${moduleTemplatePath}/\\w+`), moduleOutputPath)
            .replace(/\.ejs$/g, "")
            .replace(/__enum/g, `${en.fieldType.kebab()}`);
          fs.mkdirSync(path.dirname(pathOutput), { recursive: true });
          fs.writeFileSync(
            pathOutput,
            await ejs
              .renderFile(
                pathInput,
                {
                  enumObject: en,
                },
                { charset: "utf8" },
              )
              .catch((err) => log.error(err)),
          );
        });
    });
  // entity processing
  glob
    .sync(`${moduleTemplatePath}/@(${subModulesIncluded})/**/{.??,}*.ejs`, {})
    .filter((pathInput) => !pathInput.includes("__enum."))
    .map((pathInput) => {
      entityProperty.map(async (ep) => {
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
                _allEnum: allEnum,
                _: {
                  fieldType,
                  Case: StringPool.case,
                  typeDetect: fieldTypeProcessing,
                },
                modules: environments.modules[moduleName],
              },
              { charset: "utf8" },
            )
            .catch((err) => log.error(err)),
        );
      });
    });
};

export default () => {
  log.debug("render", environments.modules);
  modules.map((moduleName) => processTemplateEjs(moduleName));
};
