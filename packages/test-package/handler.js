const { main } = require('./bundle.js');

const handler = function(event, context, callback) {
  main();
}

exports.handler = handler;