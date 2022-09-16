import render from "./service/render"
import convert from "./service/convert"

export default ->
  log.debug "main"
  render() if process.argv.includes "render"
  convert() if process.argv.includes "convert"
