<cffunction name="printResults">
  <cfoutput>
  <table>
    <cfloop array="#results#" index="result">
      <tr>
        <td style="<cfif not result.success> background: red;</cfif>">"#result.data.a#" is equal<cfif not result.success> not</cfif> to "#result.data.b#"</td>
      </tr>
    </cfloop>
  </table>
  </cfoutput>
</cffunction>
<cfscript>

  results = [];

  function isEqual(required string a, required string b) {
    var res = {
      data = arguments,
      success = compare(a, b) == 0
    };
    arrayAppend(results, res);
  }

  mime = new Mime();

  // Test mime lookups
  isEqual('text/plain', mime.lookup('text.txt'));     // normal file
  isEqual('text/plain', mime.lookup('TEXT.TXT'));     // uppercase
  isEqual('text/plain', mime.lookup('dir/text.txt')); // dir + file
  isEqual('text/plain', mime.lookup('.text.txt'));    // hidden file
  isEqual('text/plain', mime.lookup('.txt'));         // nameless
  isEqual('text/plain', mime.lookup('txt'));          // extension-only
  isEqual('text/plain', mime.lookup('/txt'));         // extension-less ()
  isEqual('text/plain', mime.lookup('\\txt'));        // Windows, extension-less
  isEqual('application/octet-stream', mime.lookup('text.nope')); // unrecognized
  isEqual('fallback', mime.lookup('text.fallback', 'fallback')); // alternate default

  // Test extensions
  isEqual('txt', mime.extension(mime.types.text));
  isEqual('html', mime.extension(mime.types.htm));
  isEqual('bin', mime.extension('application/octet-stream'));
  isEqual('bin', mime.extension('application/octet-stream '));
  isEqual('html', mime.extension(' text/html; charset=UTF-8'));
  isEqual('html', mime.extension('text/html; charset=UTF-8 '));
  isEqual('html', mime.extension('text/html; charset=UTF-8'));
  isEqual('html', mime.extension('text/html ; charset=UTF-8'));
  isEqual('html', mime.extension('text/html;charset=UTF-8'));
  isEqual('html', mime.extension('text/Html;charset=UTF-8'));
  isEqual('', mime.extension('unrecognized'));

  // Test node.types lookups
  isEqual('application/font-woff', mime.lookup('file.woff'));
  isEqual('application/octet-stream', mime.lookup('file.buffer'));
  isEqual('audio/mp4', mime.lookup('file.m4a'));
  isEqual('font/opentype', mime.lookup('file.otf'));

  printResults();

  writeDump(mime); abort;

</cfscript>