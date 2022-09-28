import entityRender from "./service/entity.render"
import render from "./service/render"
import convert from "./service/convert"

export default ->
  log.debug "main"
  render() if process.argv.includes "render"
  entityRender() if process.argv.includes "entity_render"
  convert() if process.argv.includes "convert"
