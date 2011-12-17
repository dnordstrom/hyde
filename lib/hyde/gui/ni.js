/**
 * NI.JS minimalist library
 * Best practices and prototypal JavaScript conventions.
 * Version 0.1
 */

var NI,
  document;

(function () {
  "use strict";
  if (typeof NI === "undefined") {
    NI = function () { };
  }
}());

/**
 * @public
 * Core helper methods.
 */
NI.prototype.JS = (function () {
  /* Using ECMAScript 5 strict mode. */
  "use strict";

  /** 
   * @private
   * Object to define, return and assign.
   */
  var self = { };

  /**
   * @privileged
   * Capability detection helper.
   */
  NI.prototype.Detects = (function () {
    /**
     * @private
     * Object to define, return and assign
     */
    var self = { };

    self.getElementById = self.byId =
      (typeof document.getElementById !== "undefined");

    self.getElementsByTagName = self.byTagName =
      (typeof document.getElementsByTagName !== "undefined");

    return self; /* Return object instance */
  }());

  /**
   * @privileged
   * Calls W3C DOM getElementById if available.
   * @param {element} String ID of element to return.
   */
  self.find = function (element) {
    if (!self.Detects.byId) { return false; }
    return document.getElementById(element);
  };

  return self; /* Return object instance. */
}());

/**
 * @public
 * Asynchronous request helper methods.
 */
NI.prototype.HTTP = (function () {
  /* Using ECMAScript 5 strict mode */
  "use strict";

  /* Declaring private variables */
  var self,
    getXHR,
    XMLHttpRequest;

  /**
   * @private
   * Object to define, return and assign.
   */
  self = { };

  /**
   * @private
   * Retrieve the browser-specific XMLHttpRequest object.
   */
  getXHR = function () {
    if (typeof XMLHttpRequest !== "undefined") {
      return XMLHttpRequest;
    } else {
      XMLHttpRequest = function () {
        var ActiveXObject;

        try {
          return new ActiveXObject("Msxml2.XMLHTTP.6.0");
        } catch (e1) { }
        try {
          return new ActiveXObject("Msxml2.XMLHTTP.3.0");
        } catch (e2) { }
        try {
          return new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e3) { }

        return false;
      };
    }

    return XMLHttpRequest;
  };

  /**
   * @privileged
   * Load JSON-P data from URL via AJAX.
   *
   * @param {path} String URL to access.
   * @param {callback} Function Callback function to run after loading data.
   */
  self.getJSON = function (url, callback) {
    var script = document.createElement("script");

    script.src = url;
    script.type = "text/javascript";

    if (typeof callback !== "undefined") {
      script.src += "?callback=NI.HTTP.callback";

      self.callback = function (data) {
        callback(data);
        delete NI.JS.callback;
      };
    }

    if (document.getElementsByTagName("head").length > 0) {
      document.getElementsByTagName("head")[0].appendChild(script);
    }
  };

  return self; /* Return object instance. */
}());
