<mounter>
    <!--    See: http://riotjs.com/guide/#expressions
            Section: Render unescaped HTML 
            It contains risks of XSS attacks        
    -->
    this.root.innerHTML = "<"+opts.htmltags+"></"+opts.htmltags+">";
    this.on('mount', function() {
        const fs = require('fs');

        fs.readFile(opts.tagpath, 'utf8', function (err, text) {
            let compiled = riot.compile(text);
            riot.mount(opts.htmltags, {
                param: opts.param
            });
        });
    });
</mounter>