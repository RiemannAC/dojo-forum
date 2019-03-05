# Dojo-Forum

## User stories

### 後台管理介面
- 進入後台必須有管理員 (admin) 權限（後台路由請設為 /admin）
- 後台可以 CRUD 文章的分類 (但不能刪除已經有被使用的分類)
- 後台可以瀏覽所有使用者清單，清單上可一目了然使用者的姓名、基本資料、是否有管理員 (admin) 權限
- 後台可以把其他使用者加為管理員 (admin)
- 管理員 (admin) 在前台瀏覽文章時，可以刪除任何人的文章

### 文章相關功能
- Post CRUD
- 每篇主題有多少回覆數 (replies_count)
- 每篇文章有多少瀏覽數 (viewed_count)
- 可以在同一頁直接進行回覆 (Comment)
- 在同一頁看見回覆內容
- 若使用者是該文章/回覆的作者，在本頁面可以同步進行編輯和刪除
- 可選擇用「最後回覆時間」排序文章
- 可選擇用「最多人進行回覆」排序文章
- 可選擇用最多人瀏覽數排序文章
- 張貼文章時，可以附檔上傳一張相片
- 使用者張貼文章時，可以選擇 Category (多選)，例如 [ ] 商業類 [ ] 技術類 [ ] 心理類
- 使用者可以瀏覽特定分類的文章

### Profile
- 使用者可以收藏/取消收藏文章（AJAX)
- Profile 頁裡包括自己的發文、回文、收藏、草稿、好友頁面

### 全站最新快訊
- Feeds 頁面，顯示以下資訊：
- 全站已註冊的使用者人數
- 全站總共有多少主題和回覆
- 最熱門的文章（最多人回覆）
- 聲量最大的使用者（最多回覆數）

### 文章狀態
- 新增文章時可以選擇草稿 (Draft) 狀態
- 草稿狀態只有自己看得到，稍候可以編輯將狀態改成「發布」。
- 草稿狀態的文章會統一歸進 Profile 頁面裡
- 已讀文章狀態顯示

### 好友
- 使用者可以對其他使用者發出好友請求
- 不能對自己發出好友請求、已經成為好友或已送出也不能再送
- 可以查看收到的好友請求，回覆答應或忽略（AJAX）
- 在 Profile 頁裡可以瀏覽我的好友清單

### 文章權限
- 文章可以設定權限（使用者在瀏覽文章清單時，只會看見自己有權限的文章目錄）：
- 開放給所有人都可以瀏覽和留言
- 限定好友才能瀏覽和留言
- 只有自己可以瀏覽和留言

### API 介面
- 瀏覽全部文章內容 GET https://www.riemann.xyz/api/v1/posts 不需登入 
- 瀏覽同分類全部文章內容 GET https://www.riemann.xyz/api/v1/posts?category_id=1 不需登入 
- 瀏覽單篇文章內容 GET https://www.riemann.xyz/api/v1/posts/22 需要登入 
- 新增文章	POST https://www.riemann.xyz/api/v1/posts 需要登入 
- 編輯文章	PATCH https://www.riemann.xyz/api/v1/posts/:id	需要登入 
- 刪除文章	DELETE https://www.riemann.xyz/api/v1/posts/:id	需要登入

### 其它
- RWD 設定

## Install project
```
$ git clone https://github.com/RiemannAC/dojo-forum.git
$ cd dojo-forum
$ bundle install
$ rails db:migrate
```

## Generate seed data
```
$ rails dev:fake_user
$ rails dev:fake_post
$ rails dev:fake_comment
$ rails dev:fake_collect
$ rails dev:fake_friend
```

## Demo 網址
- https://www.riemann.xyz
- Admin 帳號：admin@example.com
- Admin 密碼：12345678 