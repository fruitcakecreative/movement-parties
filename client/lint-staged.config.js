module.exports = {
  "**/*.{js,jsx}": ["prettier --write", "eslint --fix", "yarn test --bail --findRelatedTests"],
  "**/*.{css,scss}": ["prettier --write"],
  "**/*.json": ["prettier --write"]
};
