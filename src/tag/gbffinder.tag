<gbf-finder>
    <webview id="raidfinder"
    src='${JSON.parse(opts.param).raidurl}'
    disablewebsecurity
    partition="persist:finder"
    autosize="on"
    preload="./js/handleRaidFinder.js" />
</gbf-finder>