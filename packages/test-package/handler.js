const { main } = require('./bundle.js');

exports.handler = (event, context, callback) => {
  main();
}