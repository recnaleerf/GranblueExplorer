<helpertools>
<!-- http://runstant.com/phi/projects/11887011 を参考に -->
    <div class='tabs'>
        <div each='${tabs}' class='${tab:true, active: parent.type === type} unselectable' onclick='${parent.changeTab}'>${label}</div>
    </div>
        
    <div each='${tab, i in tabs }' class='content' show=${type===tabs[i].type}>
        <mounter htmltags=${tabs[i].tagname} tagpath=${tabs[i].tagpath} param=${tabs[i].params}></raw>  
    </div>
        
    <style scoped>
    .tabs {
        display: flex;
        background-color: black;
    }
    .tabs .tab {
        flex: 1;
        text-align: center;
        height: 32px;
        line-height: 32px;
        border-bottom: 2px solid #aaa;
        cursor: pointer;
    }
    .tabs .tab.active {
        border-bottom: 2px solid blue;
    }
    .content {
        height: calc(100% - 32px - 2px);
    }
    </style>
    <style>
    .unselectable {
        user-select: none;
    }
    </style>

    <script>

    this.tabs = opts.tabs;
    this.tabs.forEach((_,i,original)=>{
      original[i].type= 'tab_' + i.toString();
    });
    this.type = this.tabs[0].type;
    
    this.changeTab = (e) => {
        this.type = e.item.type;
    };

    this.on('mount', () => {
        riot.mount('mounter');
    });
    
    </script>
</helpertools>