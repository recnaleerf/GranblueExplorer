<mvplist>
    <table>
        <thead>
            <tr>
                <td>順位</td>
                <th>ユーザー名</th>
                <th>属性</th>
                <th>ランク</th>
                <th>ID</th>
                <!-- <th>ジョブ</th> -->
                <th>貢献度</th>
            </tr>
        </thead>
        <tbody>
            <tr each=${mvps}>
                <td aria-label="rank" class=${ isHost: is_host}>${rank == 9999 ? '' : rank}</td>
                <th aria-label="UserName">${nickname}</th>
                <th aria-label="ElementType">${parent.ElementType[pc_attribute]}</th>
                <th aria-label="Level">${level}</th>
                <th aria-label="UserID">${user_id}</th>
                <!-- 130301 とかの数字なのでいい感じにバインディング -->
                <!-- <th aria-label="Job">{job_id}</th> -->
                <th aria-label="Point">${point}</th>
            </tr>
        </tbody>
    </table>


    <script>
        let self = this;
        this.ElementType = {
            '1': '火', '2': '水', '3': '土', '4': '風', '5': '光', '6': '闇'
        };
        this.mvps = [];
        console.log('initialize');
        console.dir(this.mvps);

        window.game.jsonResponse.filter(e => /\/rest\/multiraid/.test(e.URL)).subscribe(e => {
            if (/\/rest\/multiraid\/start/.test(e.URL)) {
                this.mvps = [];
                this.update();
                return;
            }

            if (!/\/rest\/multiraid\/multi_member_info/.test(e.URL)) {
                return;
            }

            let body = JSON.parse(e.Body);
            body.multi_raid_member_info.forEach((value) => {
                let idx = -1;
                this.mvps.filter((item, index) => {
                    if (item.viewer_id === value.viewer_id) {
                        idx = index;
                        return true;
                    }
                    return false;
                });

                if (idx == -1) {
                    this.mvps.push({});
                    idx = this.mvps.length - 1;
                    this.mvps[idx].viewer_id = value.viewer_id;
                    this.mvps[idx].rank = 9999;
                }

                this.mvps[idx].is_host = value.is_host;
                this.mvps[idx].job_id = value.job_id;
                this.mvps[idx].level = value.level;
                this.mvps[idx].nickname = value.nickname;
                this.mvps[idx].pc_attribute = value.pc_attribute;
                this.mvps[idx].user_id = value.user_id;
            });

            body.mvp_info.forEach((value) => {
                let idx = -1;
                this.mvps.filter((item, index) => {
                    if (item.viewer_id === value.viewer_id) {
                        idx = index;
                        return true;
                    }
                    return false;
                });

                this.mvps[idx].point = parseFloat(value.point);
                this.mvps[idx].rank = parseInt(value.rank);
            });
 
            if (this.mvps.length > 0) {
                this.mvps.sort((a, b) => {
                    if (a.rank > b.rank) return 1;
                    if (a.rank < b.rank) return -1;
                });
            }

            this.update();
        });

        window.game.websocketResponse.subscribe(e => {
            try
            {
                let body = JSON.parse(e.Body)[1];
                let mvp_list = body.mvpReset || body.mvpUpdate || body.memberJoin;
                if (mvp_list !== undefined) 
                {
                    //  mvpList
                    mvp_list.mvpList.forEach((value) => {
                        let idx = -1;
                        this.mvps.filter((item, index) => {
                            if (item.viewer_id === value.viewer_id) {
                                idx = index;
                                return true;
                            }
                            return false;
                        });

                        if (idx == -1)
                        {
                            this.mvps.push({});
                            idx = this.mvps.length - 1;
                            this.mvps[idx].viewer_id = value.viewer_id;
                            this.mvps[idx].rank = 9999;
                        }

                        this.mvps[idx].point = parseFloat(value.point);
                        this.mvps[idx].rank = parseInt(value.rank);
                        this.mvps[idx].user_id = value.user_id;
                    });

                }

                let new_member = body.memberJoin;
                if (new_member !== undefined)
                {
                    let idx = -1;
                    this.mvps.filter((item, index) => {
                        if (item.viewer_id === new_member.member.viewer_id) {
                            idx = index;
                            return true;
                        }
                        return false;
                    });

                    if (idx == -1)
                    {
                        this.mvps.push({});
                        idx = this.mvps.length - 1;
                        this.mvps[idx].viewer_id = new_member.member.viewer_id;
                        this.mvps[idx].rank = 9999;
                    }

                    // member
                    this.mvps[idx].level = new_member.member.level;
                    this.mvps[idx].nickname = new_member.member.nickname;
                    this.mvps[idx].pc_attribute = new_member.member.pc_attribute;
                    this.mvps[idx].user_id = new_member.member.user_id;
                }

                if (this.mvps.length > 0) {
                    this.mvps.sort((a, b) => {
                        if (a.rank > b.rank) return 1;
                        if (a.rank < b.rank) return -1;
                    });
                }

                this.update();
            }
            catch(e)
            {
                console.error(e);
                // it's ping?
            }
        });

    </script>

</mvplist>