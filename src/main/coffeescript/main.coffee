import render from "./service/render"
import convert from "./service/convert"

argv = process.argv

export default ->
  log.debug "main"
  render() if argv.includes "render"
  convert() if argv.includes "convert"
