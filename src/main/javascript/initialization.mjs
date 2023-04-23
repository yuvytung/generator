import "./configuration/index.mjs";
import Case from "case";

// eslint-disable-next-line no-extend-native
String.prototype.execute = callback => callback(this);
// eslint-disable-next-line no-extend-native
Object.assign(String.prototype, {
  /**
   * snake_case
   * @returns {string}
   */
  /**
   * snake_case
   * @returns {string}
   */
  snake: function () {
    return Case.snake(this);
  },
  /**
   * PascalCase
   * @returns {string}
   */
  pascal: function () {
    return Case.pascal(this);
  },
  /**
   * camelCase
   * @returns {string}
   */
  camel: function () {
    return Case.camel(this);
  },
  /**
   * kebab-case
   * @returns {string}
   */
  kebab: function () {
    return Case.kebab(this);
  },
  /**
   * Header-Case
   * @returns {string}
   */
  header: function () {
    return Case.header(this);
  },
  /**
   * CONSTANT_CASE
   * @returns {string}
   */
  constant: function () {
    return Case.constant(this);
  },
  /**
   * UPPERCASE
   * @returns {string}
   */
  upper: function () {
    return Case.upper(this);
  },
  /**
   * lowercase
   * @returns {string}
   */
  lower: function () {
    return Case.lower(this);
  },
  /**
   * Capital Case
   * @returns {string}
   */
  capital: function () {
    return Case.capital(this);
  },
  /**
   * Capital Title
   * @returns {string}
   */
  title: function () {
    return Case.title(this);
  },
});
