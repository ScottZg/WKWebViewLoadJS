var entries = [];
var  tocLinks = document.querySelectorAll('.ns-swipe-item');

for (var i=0;i<tocLinks.length;i++) {
	var topLink = tocLinks[i];
	var topLinkText = topLink.querySelectorAll('a');
	for (var j = 0; j<topLinkText.length;j++) {
		var aT = topLinkText[j];
		var entry = {'title':aT.textContent,'urlString':aT.href};
		entries.push(entry);

	}
}




webkit.messageHandlers.didFetchTableOfContents.postMessage(entries);
