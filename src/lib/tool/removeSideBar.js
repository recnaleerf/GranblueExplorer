'use strict';

window.addEventListener('load', () => {
    console.log('Remove');
  let mobage_bar = document.querySelectorAll("body.jssdk > div > *");
	if (mobage_bar.length == 2) {
		mobage_bar[0].style.display = "none";
	}

	// not tested...
	setTimeout(() => {
		let gree_bar = document.querySelectorAll("#gree-ui-menu");
		if (gree_bar.length == 1) {
			gree_bar[0].style.display = "none";
		}
	}, 1000);
});