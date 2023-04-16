import "./configuration/index.mjs";
import Case from "case";

// eslint-disable-next-line no-extend-native
String.prototype.execute = callback => callback(this);
// eslint-disable-next-line no-extend-native
Object.assign(String.prototype, {
  snake: () => Case.snake(this), // snake_case
  pascal: () => Case.pascal(this), // PascalCase
  camel: () => Case.camel(this), // camelCase
  kebab: () => Case.kebab(this), // kebab-case
  header: () => Case.header(this), // Header-Case
  constant: () => Case.constant(this), // CONSTANT_CASE
  upper: () => Case.upper(this), // UPPERCASE
  lower: () => Case.lower(this), // lowercase
  capital: () => Case.capital(this), // Capital Case
  title: () => Case.title(this), // Capital Title
});
