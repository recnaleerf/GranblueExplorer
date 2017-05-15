<mvplist>
    <table>
        <thead>
            <tr>
                <td>順位</td>
                <th show=${showColumn['UserNameLabel']}>ユーザー名</th>
                <th show=${showColumn['ElementTypeLabel']}>属性</th>
                <th show=${showColumn['LevelLabel']}>ランク</th>
                <th show=${showColumn['UserIDLabel']}>ID</th>
                <th show=${showColumn['JobLabel']}>ジョブ</th>
                <th show=${showColumn['PointLabel']}>貢献度</th>
            </tr>
        </thead>
        <tbody>
            <tr each=${mvps} class=${ isMe: myid == user_id, isHost: is_host }>
                <td aria-label="rank">${rank == 9999 ? '' : rank}</td>
                <th aria-label="UserName" show=${showColumn['UserNameLabel']}>${nickname}</th>
                <th aria-label="ElementType" show=${showColumn['ElementTypeLabel']}>${parent.ElementType[pc_attribute]}</th>
                <th aria-label="Level" show=${showColumn['LevelLabel']}>${level}</th>
                <th aria-label="UserID" show=${showColumn['UserIDLabel']}>${user_id}</th>
                <th aria-label="Job" show=${showColumn['JobLabel']}>${parent.JobName[job_id]}</th>
                <th aria-label="Point" show=${showColumn['PointLabel']}>${point}</th>
            </tr>
        </tbody>
    </table>

    <ul style='list-style-type: none'>
        <li>
            <input id="UserNameLabel" name="UserNameLabel" type="checkbox" checked=${showColumn['UserNameLabel']} onclick=${toggleColumn}/>
            <label for="UserNameLabel">ユーザー名の表示／非表示</label>
        </li>
        <li>
            <input id="ElementTypeLabel" name="ElementTypeLabel" type="checkbox" checked=${showColumn['ElementTypeLabel']} onclick=${toggleColumn}/>
            <label for="ElementTypeLabel">属性の表示／非表示</label>
        </li>
        <li>
            <input id="LevelLabel" name="LevelLabel" type="checkbox" checked=${showColumn['LevelLabel']} onclick=${toggleColumn}/>
            <label for="LevelLabel">レベルの表示／非表示</label>
        </li>
        <li>
            <input id="UserIDLabel" name="UserIDLabel" type="checkbox" checked=${showColumn['UserIDLabel']} onclick=${toggleColumn}/>
            <label for="UserIDLabel">ユーザーIDの表示／非表示</label>
        </li>
        <li>
            <input id="JobLabel" name="JobLabel" type="checkbox" checked=${showColumn['JobLabel']} onclick=${toggleColumn}/>
            <label for="JobLabel">ジョブ名の表示／非表示</label>
        </li>
        <li>
            <input id="PointLabel" name="PointLabel" type="checkbox" checked=${showColumn['PointLabel']} onclick=${toggleColumn}/>
            <label for="PointLabel">貢献度の表示／非表示</label>
        </li>
    </ul>

    <script>
        this.showColumn = {
            UserNameLabel: true,
            ElementTypeLabel: true,
            LevelLabel: true,
            UserIDLabel: true,
            JobLabel: true,
            PointLabel: true
        };

        toggleColumn(e) {
            this.showColumn[e.toElement.name] = !this.showColumn[e.toElement.name];
            return true;
        }

        this.ElementType = {
            '1': '火', '2': '水', '3': '土', '4': '風', '5': '光', '6': '闇'
        };
        this.JobName = {
            '110001': "ナイト",
            '120001': "プリースト",
            '130001': "ウィザード",
            '140001': "シーフ",
            '150001': "エンハンサー",
            '160001': "グラップラー",
            '170001': "レンジャー",
            '180001': "ハーピスト",
            '190001': "ランサー",
            '100101': "ウォーリア",
            '110101': "フォートレス",
            '120101': "クレリック",
            '130101': "ソーサラー",
            '140101': "レイダー",
            '150101': "アルカナソード",
            '160101': "クンフー",
            '170101': "マークスマン",
            '180101': "ミンストレル",
            '190101': "ドラグーン",
            '100201': "ウェポンマスター",
            '110201': "ホーリーセイバー",
            '120201': "ビショップ",
            '130201': "ハーミット",
            '140201': "ホークアイ",
            '150201': "ダークフェンサー",
            '160201': "オーガ",
            '170201': "サイドワインダー",
            '180201': "スーパースター",
            '190201': "ヴァルキュリア",
            '100301': "ベルセルク",
            '110301': "スパルタ",
            '120301': "セージ",
            '130301': "ウォーロック",
            '140301': "義賊",
            '150301': "カオスルーダー",
            '160301': "レスラー",
            '170301': "ハウンドドッグ",
            '190301': "アプサラス",
            '180301': "エリュシオン",
            '200201': "アルケミスト",
            '210201': "忍者",
            '220201': "侍",
            '230201': "剣聖",
            '240201': "ガンスリンガー",
            '250201': "賢者",
            '260201': "アサシン",
        };
        this.mvps = [];
        this.myid = -1;

        window.game.jsonResponse.filter(e => /\/rest\/multiraid/.test(e.URL)).subscribe(e => {
            this.initMyId(e.URL);

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
                let idx = this.getViewerIndex(value.viewer_id);

                if (idx == -1) {
                    this.mvps.push({});
                    idx = this.mvps.length - 1;
                    this.mvps[idx].viewer_id = value.viewer_id;
                    this.mvps[idx].rank = 9999;
                }

                this.mvps[idx].is_host = value.is_host;
                this.mvps[idx].is_dead = value.is_dead;
                this.mvps[idx].retired_flag = value.retired_flag;
                this.mvps[idx].job_id = value.job_id;
                this.mvps[idx].max_hp = value.max_hp || [];
                this.mvps[idx].level = value.level;
                this.mvps[idx].nickname = value.nickname;
                this.mvps[idx].pc_attribute = value.pc_attribute;
                this.mvps[idx].user_id = value.user_id;
            });

            body.mvp_info.forEach((value) => {
                let idx = this.getViewerIndex(value.viewer_id);

                this.mvps[idx].point = parseFloat(value.point);
                this.mvps[idx].rank = parseInt(value.rank);
            });
 
            this.sortMvps();
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
                        let idx = this.getViewerIndex(value.viewer_id);

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
                    let idx = this.getViewerIndex(new_member.member.viewer_id);

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

                this.sortMvps();
                this.update();
            }
            catch(e)
            {
                console.error(e);
                // it's ping?
            }
        });

        this.initMyId = (url) => {
            let queries = this.queryVars(url);
            if (queries['uid'] !== undefined)
            {
                this.myid = parseInt(queries['uid']);
            }
        }

        this.queryVars = (url) => {
            let vars = {};
            let fidx = url.indexOf('?');
            if (fidx == -1) {
                return vars;
            }
            let tmp = url.slice(fidx + 1).split('&');

            tmp.forEach((value) => {
                let kv = value.split('=');
                vars[kv[0]] = kv[1];
            });

            return vars;
        }

        this.sortMvps = () => {
            if (this.mvps.length > 0) {
                this.mvps.sort((a, b) => {
                    if (a.rank > b.rank) return 1;
                    if (a.rank < b.rank) return -1;
                });
            }
        }

        this.getViewerIndex = (viewer_id) => {
            let idx = -1;
            this.mvps.filter((item, index) => {
                if (item.viewer_id === viewer_id) {
                    idx = index;
                    return true;
                }
                return false;
            });

            return idx;
        }

    </script>

</mvplist>
