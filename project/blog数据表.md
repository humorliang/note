### blog的cms精简版数据库设计(借鉴wordpress设计)：
- Table: bc_users (用户表)
```sql
-- 用户表字段
Field	                Type	              Null	Key	        Default	   Extra            desc
ID	                    bigint(20) unsigned	  PRI	NULL	               auto_increment   用户主键ID
user_login	            varchar(60)	 	      IND	 	                                    用户名
user_pass	            varchar(64)	 	 	 	                                            密码
user_nicename	        varchar(50)	 	      IND	 	                                    昵称
user_email	            varchar(100)	 	 	 	                                        邮箱
user_registered	        datetime	 	 	                    0000-00-00 00:00:00	        注册时间
user_activation_key	    varchar(60)	 	 	 	                                            激活码
user_status	            int(11)	 	 	                        0	                        用户状态（0,1 可用、不可用）
-- 用户表索引
Indexes
Keyname	                Type	             Cardinality	        Field
PRIMARY	                PRIMARY	                1	                ID
user_login_key	        INDEX	             None	                user_login
user_nicename	        INDEX	             None	                user_nicename
```
- Table: bc_usermeta (用户元数据表)
> 每个用户的特性信息称为元数据,它存储在wp_usermeta (储每个用户的QQ号码、手机号码等)
```sql
-- 用户组字段
Field	                Type	                 Null	Key	    Default	           Extra                   desc
umeta_id	            bigint(20) unsigned	 	        PRI	    NULL	           auto_increment          用户组主键Id
user_id	                bigint(20) unsigned	 	 	            '0'	               FK->wp_users.ID         外键到user
meta_key	            varchar(255)	         Yes	IND	    NULL	 
meta_value	            longtext	             Yes	IND	    NULL	

-- 用户组索引
Keyname	                Type	Cardinality	      Field
PRIMARY	               PRIMARY	9	              umeta_id
user_id	               INDEX	None	          user_id
meta_key	           INDEX	None	          meta_key
```
- Table: bc_terms
> 文章和链接分类以及文章的tag分类可以在bc_terms表里找到.常见的分类有文章的分类、链接的分类，实际上还有TAG，它也是一种特殊的分类方式
```sql
-- 分类表
Field	        Type	                Null	Key	    Default	        Extra                 desc
term_id	        bigint(20)unsigned	 	        PRI	 	                auto_increment        分类主键Id 
name	        varchar(200)	 	 	 	                                                  分类名
term_group	    bigint(10)	 	 	                    0	                                  所属组号

-- Indexes 分类表索引
Keyname	        Type	        Cardinality	        Field
PRIMARY	        PRIMARY	        2	                term_ID
slug	        UNIQUE	        2	                slug
name	        Index	        none	            name
```
- Table: bc_term_taxonomy
> 这张表描述了bc_terms表中每个条目的分类系统 (分类,链接,或tag).分类的方法
```sql
-- 分类方法表
Field	               Type	                Null	    Key	        Default	        Extra                desc
term_taxonomy_id	   bigint(20) unsigned	 	        PRI	 	                    auto_increment       分类方法主键ID
term_id	               bigint(20) unsigned	 	        UNI Pt1	    0	            FK->wp_terms.term_id 外键分类ID
taxonomy	           varchar(32)	 	                UNI Pt2	 	                                     分类方法名
description	           longtext	 	 	 	                                                             分类方法描述（文章、友链）
parent	               bigint(20) unsigned	 	 	                0	                                 分类方法父级
count	               bigint(20)	 	 	                        0	                                 分类方法数
-- Indexes索引
Keyname	                Type	    Cardinality	    Field
PRIMARY	                PRIMARY	    2	            term_taxonomy_id
term_id_taxonomy	    UNIQUE	    2	            term_id
taxonomy
taxonomy	            INDEX	    None	        taxonomy
```
- Table: bc_term_relationships
> 与文章有关的分类、来自bc_terms表的tags以及这一关联存在于bc_term_relationships表里. 链接与各自分类的联系也存储于这张表中.
```sql
-- 分类关系表
Field	                   Type	                    Null	    Key	             Default	  Extra                             desc           
object_id	               bigint(20) unsigned	 	            PRI Pt1	            0	                                        分类对象ID
term_taxonomy_id	       bigint(20) unsigned	 	            PRI Pt2 & IND	    0	  FK->bc_term_taxonomy.term_taxonomy_id 外键分类方法ID
-- Indexes索引
Keyname	                Type	        Cardinality	        Field
PRIMARY	                PRIMARY	        8	                object_id
term_taxonomy_id	    INDEX	        None	            term_taxonomy_id
```
- Table: bc_posts
> 文章信息表
```sql
-- 文章表
Field	                    Type	             Null	 Key	                 Default	          Extra             desc
id	                        bigint(20) unsigned	 	     PRI & IND Pt4	 	                          auto_increment    文章主键ID
post_author	                bigint(20) unsigned	 	 	                         0	                  FK->bc_users.ID   外键用户ID
post_date	                datetime	 	             IND Pt3	             0000-00-00 00:00:00	                文章发表时间
post_content	            longtext	 	 	 	                                                                    文章内容
post_title	                text	 	 	 	                                                                        文章标题
post_excerpt	            text	 	 	 	                                                                        文章描述
post_status	                varchar(20)	 	             IND PT2	            publish	                                文章状态(publish/libsave)
comment_status	            varchar(20)	 	 	                                open	                                评论状态
post_modified	            datetime	 	 	                                0000-00-00 00:00:00	                    文章修改时间
comment_count	            bigint(20)	 	 	                                0	                                    评论总数
-- Indexes索引表
Keyname	            Type	        Cardinality	    Field
PRIMARY	            PRIMARY	        2	            id
type_status_date	INDEX	        None	        post_status
                                                    post_date
post_author	        INDEX	        None	        post_author
```
- Table: bc_postmeta
> 每篇文章的特性信息被称为元数据，它存储在bc_postmeta. （比方文章中所用到的图片音频资源）
```sql
-- 文章元数据表
Field	                Type	                Null	Key	    Default	    Extra                desc
meta_id	                bigint(20) unsigned	 	        PRI	    NULL	    auto_increment       主键
post_id	                bigint(20) unsigned	 	        IND	    0	        FK->bc_posts.ID      外键文章主键ID
meta_key	            varchar(255)	        YES	    IND	    NULL	 
meta_value	            longtext	            YES	 	        NULL	 
-- Indexes 索引
Keyname	        Type	        Cardinality	        Field
PRIMARY	        PRIMARY	        13	                meta_ID
post_id	        INDEX	        15	                post_id
meta_key	    INDEX	        7	                meta_key
```
- Table: bc_comments
> 文章的评论和回复表存储的地方
```sql
-- 评论表
Field	                Type	                Null	Key	            Default	                Extra               desc
comment_ID	            bigint(20) unsigned	 	        PRI	            NULL	                auto_increment      评论主键ID
comment_post_ID	        bigint(20) unsigned	 	        IND	            0	                    FK->bc_posts.ID     外键文章主键ID
comment_author	        tinytext	 	 	 	                                                                    评论作者
comment_author_email	varchar(100)	 	 	 	                                                                评论作者邮箱
comment_author_IP	    varchar(100)	 	 	 	                                                                评论IP
comment_date	        datetime	 	 	                            0000-00-00 00:00:00	                        评论时间
comment_content	        text	 	 	 	                                                                        评论内容
comment_approved	    varchar(20)	 	                IND & Ind Pt1	1	                                        是否被允许
comment_agent	        varchar(255)	 	 	 	                                                                评论者的user-agent
comment_type	        varchar(20)	 	 	 	                                                                    评论的类型（回复pingback/普通normal）
comment_parent	        bigint(20) unsigned	 	 	                    0	                    FK->bc_comments.ID  外键自身ID
user_id	                bigint(20) unsigned	 	 	                    0	                    FK->bc_users.ID     外键用户ID
-- Indexes 索引
Keyname	                Type	    Cardinality	        Field
PRIMARY	                PRIMARY	    1	                comment_ID
comment_approved	    INDEX	    None	            comment_approved
comment_post_ID	        INDEX	    None	            comment_post_ID
comment_date	        INDEX	    None	            comment_date
comment_parent	        INDEX	    None	            comment_parent
```
- Table: bc_commentmeta
> 评论的特性信息称为元素据
```sql
-- 评论元素据表
Field	        Type	                Null	Key	    Default	        Extra                        desc
meta_id	        bigint(20) unsigned	 	        PRI	    NULL	        auto_increment               评论元数据主键ID
comment_id	    bigint(20) unsigned	 	        IND	    0	            FK->bc_comments.comment_id   外键评论ID
meta_key	    varchar(255)	        YES	    IND	    NULL	        
meta_value	    longtext	            YES	 	        NULL	 
-- Indexes 索引
Keyname	        Type	    Cardinality	        Field
PRIMARY	        PRIMARY	    0	                meta_ID
comment_id	    INDEX	    none	            comment_id
meta_key	    INDEX	    none	            meta_key
```
- Table: wp_links
> 友情链接，广告等存储
```sql
-- 友情链接表
Field	            Type	            Null	Key	        Default	        Extra               desc
link_id	            bigint(20) unsigned	 	    PRI	        NULL	        auto_increment      友链主键ID
link_url	        varchar(255)	 	 	 	                                                友链URL
link_name	        varchar(255)	 	 	 	                                                名称
link_image	        varchar(255)	 	 	 	                                                图片
link_description	varchar(255)	 	 	 	                                                描述
link_visible	    varchar(20)	 	            IND	        Y	                                是否可见
link_owner	        bigint(20) unsigned	 	 	            1	            FK->bc_users.ID     添加者用户ID
link_rating	        int(11)	 	 	                        0	                                评分等级
link_updated	    datetime	 	 	                   0000-00-00 00:00:00	 
-- Indexes索引
Keyname	            Type	    Cardinality	        Field
PRIMARY	            PRIMARY	    7	                link_ID
link_visible	    INDEX	    None	            link_visible
```
