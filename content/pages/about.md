# About this Website

This website is made up by a set of static pages served by
[lighttpd](https://www.lighttpd.net/).

It used to have a backend written in [lisp](http://lispers.org/) using the
[hunchentoot](http://weitz.de/hunchentoot/) web server. The backend converted a
bunch of markdown files on the fly when requested by some javascript on the
page.

After a while I realized that the content was mostly static and I converted the
backend into a static website generator. So here it is: a fast static website
that works without javascript.

You may ask: "Why roll your own solution when there's plenty of blogging
platform and static site generators?". The answer is because I can.
<center>
	<img src="/res/img/made-with-lisp-logo.jpg" width="300" height="100"/>
</center>
