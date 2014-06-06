/**
 * @output false
 */
component {

  include './utils.cfc';

  public Mime function init() {
    // Map of extension -> mime type
    this.types = {};
    // Map of mime type -> extension
    this.extensions = {};

    // Create pattern for this.extension()
    variables.extensionPattern = createObject('java', 'java.util.regex.Pattern').compile('^\s*([^;\s]*)(?:;|\s|$)');

    return this;
  }

  /**
   * @hint Define mimetype -> extension mappings.  Each key is a mime-type that maps
   *       to an array of extensions associated with the type.  The first extension is
   *       used as the default extension for the type.
   *
   *       e.g. mime.define({'audio/ogg', ['oga', 'ogg', 'spx']});
   *
   * @map type definitions
   */
  public void function define(required struct map) {
    var type = '';
    for (type in map) {
      var exts = map[type];

      for (var i = 1; i <= arrayLen(exts); i++) {
        this.types[exts[i]] = type;
      }

      // Default extension is the first one we encounter
      if (!structKeyExists(this.extensions, type)) {
        this.extensions[type] = exts[1];
      }
    }
  }

  /**
   * @hint Load an Apache2-style ".types" file
   *       This may be called multiple times (it's expected).  Where files declare
   *       overlapping types/extensions, the last file wins.
   *
   * @file path of file to load.
   */
  public void function load(required string file) {
    // Read file and split into lines
    var map = {};
    var content = fileRead(file, 'utf-8');
    var lines = content.split('[\r\n]+');

    for (var i = 1; i <= arrayLen(lines); i++) {
      var line = lines[i];

      // Clean up whitespace/comments, and split into fields
      var fields = reReplaceNoCase(line, '\s*##.*', '', 'all').split('\s+');
      var extension = fields[1];

      if (!len(extension)) {
        continue;
      }

      var mime = fields[1];
      map[mime] = arraySlice(fields, 2);
    }

    this.define(map);
  }

  /**
   * @hint Return file extension associated with a mime type
   *
   * @path path of file
   * @fallback fallback mime-type if not match found
   */
  public string function lookup(required string path, string fallback = '') {
    var ext = lCase(reReplaceNoCase(path, '.*[\.\/\\]', '', 'all'));
    if (structKeyExists(this.types, ext)) {
      return this.types[ext];
    } else if (len(fallback)) {
      return fallback;
    } else if (structKeyExists(this, 'default_type')) {
      return this.default_type;
    }

    return '';
  }

  /**
   * @hint Return file extension associated with a mime type
   *
   * @mimeType mime-type to examine
   */
  public string function extension(required string mimeType) {
    var matcher = extensionPattern.matcher(mimeType);
    if (matcher.find()) {
      var type = matcher.group(1);
      if (structKeyExists(this.extensions, type)) {
        return this.extensions[type];
      }
    }
    return '';
  }

}