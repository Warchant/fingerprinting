function switchMenu()
{
	var leftColumn = document.getElementById('leftColumn');
	var mainColumn = document.getElementById('mainColumn');
	var controlSpan = document.getElementById('menuSwitch');

	var leftDisplay = leftColumn.style.display;

	if (leftDisplay == 'block' || leftDisplay == '') {
		leftColumn.style.display = 'none';
		mainColumn.style.marginLeft = '0px';
		controlSpan.innerHTML = 'Display Menu';
	}
	else {
		leftColumn.style.display = 'block';
		mainColumn.style.marginLeft = '191px';
		controlSpan.innerHTML = 'Hide Menu';
	}
}
