(function () {
    const RxOb = require('rxjs/Rx').Observable;
    let container = document.getElementById("right-menu");
    let resizeBar = document.querySelector('.draggable');

    RxOb.fromEvent(resizeBar, 'mousedown')
        .flatMap(_ => {
            return RxOb.fromEvent(document.body, 'mousemove')
                .takeUntil(
                RxOb.merge(
                    RxOb.fromEvent(document.body, 'mouseup'),
                    RxOb.fromEvent(document.body, 'mouseleave'))
                )
                .throttleTime(100)
                .map(x => { return { X: x.x, Y: x.y } });
        })
        .subscribe(e => {
            let wd = document.body.clientWidth - e.X;
            if (wd > 10) {
                container.style.width = wd + "px";
            }
        });
})();