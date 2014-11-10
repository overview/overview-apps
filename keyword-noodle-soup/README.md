Keyword stack
=============

Displays the most common keywords and how often they link together.

This is intended as a demo. We don't know if the view is useful. Keywords are
just the top five words per document, decided by TF/IDF vectors. The fact that
two words are "keywords" in 200 documents is interesting, but other important
words might not be "keywords" because they're the _sixth_ most important word in
documents.

Deployed at `https://overview-keyword-noodle-soup.s3.amazonaws.com`

Running
-------

See `./run.sh`

Deploying to S3
---------------

See `./deploy.sh`
