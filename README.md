The GovHack Dashboard
Check out http://shopify.github.com/dashing for more information.
dashing start -e production

uses countdown widget https://gist.github.com/ruleb/5353056

to redeploy 
curl -d '{ "auth_token": "YOUR_AUTH_TOKEN", "text": "<script>setTimeout(function () { location.reload(1); }, 500);</script>", "title": "test" }' http://direct.disclosurelo.gs:3030/widgets/welcome
