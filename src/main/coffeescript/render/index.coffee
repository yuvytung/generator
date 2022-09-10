import beforeRender from "./before-render"
import render from "./render"
import afterRender from "./after-render"

export default ->
  beforeRender()
  render()
  afterRender()
