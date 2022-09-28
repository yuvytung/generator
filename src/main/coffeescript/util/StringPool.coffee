import Case from "case"
# eslint-disable-next-line import/prefer-default-export
export class StringPool
  @BLANK: ""

  @case: Case

  @caseProcessing: (resource) ->
    result = {}
    Object.keys(resource).forEach (key) ->
      # eslint-disable-next-line coffee/no-return-assign
      result["_#{key}"] =
        snake: Case.snake resource[key] # snake_case
        pascal: Case.pascal resource[key] # PascalCase
        camel: Case.camel resource[key] # camelCase
        kebab: Case.kebab resource[key] # kebab-case
        header: Case.header resource[key] # Header-Case
        constant: Case.constant resource[key] # CONSTANT_CASE
        upper: Case.upper resource[key] # UPPERCASE
        lower: Case.lower resource[key] # lowercase
        capital: Case.capital resource[key] # Capital Case
    result
