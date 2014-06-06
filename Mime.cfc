/**
 * @output false
 * @extends lib.Mime
 */
component {

  public Mime function init() {
    super.init();

    var dirname = getDirectoryFromPath(getCurrentTemplatePath());

    // Load local copy of
    // http://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types
    this.load(dirname & '/types/mime.types');

    // Load additional types from node.js community
    this.load(dirname & '/types/node.types');

    // Default type
    this.default_type = this.lookup('bin');

    return this;
  }

}