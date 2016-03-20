// URL to call when making requestst to the api (no traling /)
const CONTENT_LOC = '/artsrv/';
// Parameter passed to the URL to request some content
const CONTENT_PAR = 'c=';
// ID of the div to be filled with content
const CONTENT_DIV = 'text';
// URL for the list of the most recent articles
const RECENT = 'recent';
// ID of the div with the most recent articles
const RECENT_DIV = 'recent';

/*
 * Helper function to load the requested article and put its content in a div
 * Parameters:
 *  id  -> id of the element to fill with data
 *  url -> URL from which the data is fetched
 */
function fillDiv(id, url) {
	var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onload = function (e) {
        if (xhr.readyState === 4) {
			document.getElementById(id).innerHTML = xhr.responseText;
        }
    };
    xhr.onerror = function (e) {console.error(xhr.statusText);};
    xhr.send(null);
}

/*
 * Fill the selected div with a list of the most recent articles
 */
function fillRecent(id, url) {
	var xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.onload = function (e) {
		if (xhr.readyState === 4) {
			var lines = xhr.responseText.split('\n');
			var html = "<h3>Recent Articles</h3><ul>";
			for (var i = 0; i < lines.length; i++) {
				var titleurl = lines[i].split('#');
				if (titleurl[0] && titleurl[1]) {
					html += '<li><a href="/?c=' + titleurl[1] + '">';
					html += titleurl[0] + '</a></li>';
				}
			}
			document.getElementById(id).innerHTML = html + '</ul>';
		}
	};
	xhr.onerror = function (e) {console.error(xhr.statusText);};
	xhr.send(null);
}

/*
 *
 */
function getParam(name) {
	return location.search.split(name)[1];
}

// Actuall filling of the DOM happens here
var contentPath = getParam(CONTENT_PAR);
if (contentPath) {
	fillDiv(CONTENT_DIV, CONTENT_LOC + contentPath);
} else {
	fillDiv(CONTENT_DIV, CONTENT_LOC + 'index');
}

fillRecent(RECENT_DIV, CONTENT_LOC + RECENT);
