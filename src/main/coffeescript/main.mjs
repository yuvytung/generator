import entityRender from "./service/entity.render.mjs";
import render from "./service/render.mjs";
import convert from "./service/convert.mjs";

export default () => {
  log.debug("main");
  if (process.argv.includes("render")) render();
  if (process.argv.includes("entity_render")) entityRender();
  if (process.argv.includes("convert")) convert();
};
