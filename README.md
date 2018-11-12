# Deploy Packages to Lambda

## Installation

[Make](https://brewformulas.org/Make), [Yarn](https://yarnpkg.com/en/docs/install#mac-stable) and [Node](https://nodejs.org/en/) are required. 

- `git clone git@github.com:JonnyPickard/lambda-node-deploy-example.git`
- `cd lambda-node-deploy-example`
- `make [option]` - run your build option.

## About

Each package should have an `index.js` file and a lambda `handler.js` file than requires & uses it. All packages should be located under `/packages` and in their own named directory.

Make is used to handle all build and deploy steps:

1. The module tree is bundled with parcel starting at `./packages/(packageName)/index.js`. 
2. The resulting bundle.js and handler.js files are zipped into a `handler.zip` file.
3. They are then pushed up to lambda with the same name as their directory.
4. Finally the over .zip and bundle.js files are removed.

