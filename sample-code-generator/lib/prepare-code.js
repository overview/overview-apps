module.exports = function prepareCode(code, vars) {
  // Code always looks like "...<vars>...</vars>...."
  // The part in the middle needs to be processed; the rest doesn't
  // We process variables by replacing variables and lining up comments
  var parts = code.split(/<\/?vars>/g);
  var varParts = parts[1]                         // full text
    .split(/\n/g)                                 // Array of lines
    .filter(function(x) { return x.trim().length > 0 }) // remove empty lines
    .map(function(s) { return s.split(/ *\|/); }) // each item is an Array of beforeWhitespace, afterWhitespace
    .map(function(a) { a[0] = a[0].replace(/##(\w+)/, function(__, v) { return vars[v]; }); return a; }); // replace vars
  var maxLength = varParts                        // maximum length of beforeWhitespace
    .reduce(function(s, a) { return Math.max(s, a[0].length) }, 0);
  var space = ' ';
  for (var i = 0; i < maxLength; i++) { space += ' '; }
  var vars = varParts
    .map(function(a) { return a[0] + space.substr(a[0].length) + a[1]; })
    .join("\n");
  return parts[0] + vars + parts[2];
};
