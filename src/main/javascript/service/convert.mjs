import glob from "glob";
import * as fs from "fs";
import * as path from "path";

const modules = ["backend-nestjs", "frontend-reactjs"];

const environments = YAML.parseFile("environments.yml");
const binaryExtensions = environments.file.typeExtensions.binary;
const textExtensions = environments.file.typeExtensions.text;

const detectFile = (p, extensions) => p.match(new RegExp(`^.*.(${extensions.join("|")})$`, "g"));

export default () => {
  log.debug("convert");
  modules.map((moduleName) => {
    const moduleTemplatePath = `tmp/${moduleName}`;
    const moduleOutputPath = `src/main/resources/template/${moduleName}/main`;
    const allFile = glob.sync(`${moduleTemplatePath}/**/{.??,}*`, { nodir: true });
    const countProcessed = allFile
      .filter((pathInput) => detectFile(pathInput, binaryExtensions))
      .map((pathInput) => {
        const pathOutput = pathInput
          .replace(moduleTemplatePath, moduleOutputPath)
          .concat(".binary");
        return { pathOutput, pathInput };
      })
      .concat(
        allFile
          .filter((pathInput) => detectFile(pathInput, textExtensions))
          .map((pathInput) => {
            const pathOutput = pathInput
              .replace(moduleTemplatePath, moduleOutputPath)
              .concat(".ejs");
            return { pathOutput, pathInput };
          }),
      )
      .map(({ pathOutput, pathInput }) => {
        fs.mkdirSync(path.dirname(pathOutput), { recursive: true });
        return fs.copyFileSync(pathInput, pathOutput);
      }).length;
    log.info(`convert module: ${moduleName} done!
      ->
        processed: ${countProcessed}
        total: ${allFile.length}
        output folder: ${moduleOutputPath}
      `);
  });
};
