function addLoadEvent(func)
{
	var oldonload = window.onload;
	if (typeof window.onload != 'function')
	{
		window.onload = func;
	}
	else
	{
		window.onload = function()
		{
			if (oldonload)
			{
				oldonload();
			}
			func();
		}
	}
}

function loadData(url, dataDivID, callback)
{
	var req;

	if (callback == null) callback = processReqChange;

	try
	{
		req = new XMLHttpRequest();
	}
	catch (e)
	{
		try
		{
			req = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch (e)
		{
			try
			{
				req = new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch (e)
			{
				callback(null, dataDiv);
				return;
			}
		}
	}

	req.onreadystatechange = function()
	{
		callback(req, dataDivID);
	};

	req.open("GET", url, true);
	req.send(null);
}

function processReqChange(req, dataDivID)
{
	var dataDiv = document.getElementById(dataDivID);

	if (req == null)
	{
		dataDiv.innerHTML = '<p>No AJAX support</p>';
		return;
	}

	if (req.readyState == 4)
	{
		if (req.status == 200) // If "OK"
		{
			dataDiv.innerHTML = req.responseText;	// Set current data text
		}
		else
		{
			dataDiv.innerHTML = '<p>There was a problem retrieving data:' + req.statusText + '</p>';
		}
	}
}

function setDynInfo(req, dataDivID)
{
	if (req == null) return;
	if (req.status != 200) return;

	var dataDiv = document.getElementById(dataDivID);
	dataDiv.innerHTML =	'<div class="content" style="padding:4px 6px 0px 6px; text-align:center">' +
								'<p style="margin:0px"><strong>Top 5 Pages this Month</strong></p>' +
								req.responseText +
								'<p style="margin:0px 0px 5px 0px">See <a href="/home/statistics.html">more site statistics</a>.</p></div>';
}

function loadStatsPage()
{
	var now = new Date();
	var stamp = '' + now.getFullYear() + now.getMonth() + now.getDay();

	var panel = document.getElementById('pageviews30');
	panel.innerHTML = '<img class="statsGraph" src="/live/analytics/pageviews30Days.png?' + stamp +'" alt="Page views for the past 30 days" />';

	var panel = document.getElementById('visits30');
	panel.innerHTML = '<img class="statsGraph" src="/live/analytics/visits30Days.png?' + stamp +'" alt="Visits for the past 30 days" />';

	var panel = document.getElementById('year');
	panel.innerHTML = '<img class="statsGraph" src="/live/analytics/year.png?' + stamp +'" alt="Page views and visits for the past year" />';

	var panel = document.getElementById('browsers');
	panel.innerHTML = '<img class="statsGraph" src="/live/analytics/browsers.png?' + stamp +'" alt="Browser usage for the past 30 days" />';

	loadData('/live/analytics/top25.dat?' + stamp, 'top25');
	loadData('/live/analytics/browserOS.dat?' + stamp, 'browserOS');
}

function loadStatsBox()
{
	var now = new Date();
	var stamp = '' + now.getFullYear() + now.getMonth() + now.getDay();
	
	loadData('/live/analytics/top5.dat?' + stamp, 'statsBox', setDynInfo);

//	var breadcrumbRight = document.getElementById('breadcrumbRight');
//	breadcrumbRight.innerHTML = '<p>Hello</p>';
}

addLoadEvent(loadStatsBox);
