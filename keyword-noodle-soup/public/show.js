var queryString = window.location.search
  .replace(/^\?/, '')
  .split('&')
  .reduce(function(ret, param) {
    var parts = param.replace(/\+/g, ' ').split('=');
    var obj = {};
    obj[parts[0]] = decodeURIComponent(parts[1] || '');
    return _.extend(obj, ret);
  }, {});

var url = queryString.server + '/api/v1/document-sets/' + queryString.documentSetId + '/documents?fields=id,keywords&stream=true';
d3.json(url)
  .header('Authorization', 'Basic ' + btoa(queryString.apiToken + ':x-auth-token'))
  .get(function(err, json) {
      if (err) throw err;

      var keywords = buildKeywords(json.items);
      var links = buildLinks(json.items, keywords);
      showKeywords(keywords, links);
  });

/**
 * Shows the given keywords as a visualization.
 *
 * Inserts into the "div#app" div.
 */
function showKeywords(keywords, links) {
  var app = d3.select('#app')[0][0];
  app.innerHTML = '';

  var width = app.clientWidth;
  var height = app.clientHeight;

  var svg = d3.select('#app').append('svg')
    .attr('viewbox', '0 0 ' + width + ' ' + height);

  var force = d3.layout.force()
    .size([ width, height ])
    .nodes(keywords)
    .links(links)
    .gravity(0.15)
    .distance(100)
    .charge(-200)
    .start();

  var link = svg.selectAll('.link')
    .data(links)
    .enter()
      .append('line')
      .attr('class', 'link')
      .attr('stroke-width', function(d) { return (d.strength * 3) + 'px'; });

  var node = svg.selectAll('.keyword')
    .data(keywords)
    .enter()
      .append('g')
      .attr('class', 'keyword')
      .call(force.drag);

  node.append('text')
    .text(function(d) { return d.name; })
    .attr('font-size', function(d) { return (Math.pow(d.magnitude, 0.2) * 20) + 'px'; });

  force.on('tick', function() {
    link
      .attr('x1', function(d) { return d.source.x; })
      .attr('x2', function(d) { return d.target.x; })
      .attr('y1', function(d) { return d.source.y; })
      .attr('y2', function(d) { return d.target.y; });

    node.attr('transform', function(d) { return "translate(" + d.x + "," + d.y + ")"; });
  });

  node.on('mousedown', function(d) {
    var keyword = d.name;
    var q = keyword.replace('_', ' AND ');

    window.parent.postMessage({
      call: 'setDocumentListParams',
      args: [ { q: q , name: 'with keyword ' + keyword } ]
    }, queryString.server);
  });
}

/**
 * Returns an Array of Keyword objects, sorted by descending magnitude.
 *
 * Each object has { name, nDocuments, magnitude ([0..1]) }
 */
function buildKeywords(documents) {
  var maxNDocuments = null;
  var MaxNKeywords = 80;

  return _.chain(documents)                             // array of documents
    .pluck('keywords')                                  // array of keywords per document
    .flatten(true)                                      // big array of keywords, with dups
    .countBy(_.identity)                                // { keyword => nDocuments }
    .tap(function(obj) { maxNDocuments = _.max(obj); }) // calculate maxNDocuments
    .pairs()                                            // Array of [ keyword, nDocuments ] pairs
    .sortBy(function(pair) { return -pair[1]; })        // ordered by descending nDocuments
    .first(MaxNKeywords)                                // cropped to top MaxNKeywords keywords
    .map(function(pair) {
      return {
        name: pair[0],
        nDocuments: pair[1],
        magnitude: pair[1] / maxNDocuments
      };
    })
    .value();
}

/**
 * Returns an Array of Link objects.
 *
 * Each object has { source (index), target (instance), nDocuments, strength ([0..1]) }
 *
 * @param documents Array document objects (each has `keywords`, an Array of Strings)
 * @param keywords Array keyword objects (each has `name`)
 */
function buildLinks(documents, keywords) {
  // keywordToIndex: String => Number (array index)
  var keywordToIndex = _.chain(keywords)
    .pluck('name')
    .invert()
    .value();

  var maxNDocuments = null;

  return _.chain(documents)                             // array of documents
    .pluck('keywords')                                  // array of keywords per document
    .map(function(keywords) {
      return keywords
        .map(function(k) { return parseInt(keywordToIndex[k]); })
        .filter(function(i) { return _.isFinite(i); })
        .sort(); // sort so index1 < index2 always
    })                                                  // array of indexes per document
    .map(function(indexes) {
      // return all [ index1, index2 ] combinations that are sorted
      return _.chain(indexes)
        .map(function(index1, i) {
          return indexes
            .splice(i + 1)
            .map(function(index2) { return [ index1, index2 ]; });
        })
        .flatten(true)
        .value();
    })                                                  // array of index-pairs per document
    .flatten(true)                                      // array of index-pairs
    .countBy(function(pair) { return pair.join('|'); }) // index1|index2 -> count
    .tap(function(obj) { maxNDocuments = _.max(obj); }) // side-effect: set maxNDocuments
    .map(function(nDocuments, pair) {
      var arr = pair.split('|');
      return {
        source: parseInt(arr[0]),
        target: parseInt(arr[1]),
        nDocuments: nDocuments,
        strength: nDocuments / maxNDocuments
      };
    })
    .value();
}
